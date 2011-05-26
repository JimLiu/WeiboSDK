//
//  OAuth.m
//
//  Created by Jaanus Kase on 12.01.10.
//  Copyright 2010. All rights reserved.
//

#import "OAuth.h"
#include <CommonCrypto/CommonDigest.h>
#import "OAHMAC_SHA1SignatureProvider.h"
#import "NSString+URLEncoding.h"
#import "ASIFormDataRequest.h"
#import "OAuthCallbacks.h"
#import "ApplicationHelper.h"

@implementation OAuth

@synthesize oauth_token;
@synthesize oauth_token_secret;
@synthesize oauth_token_authorized;
@synthesize oauth_verifier;
@synthesize delegate;
@synthesize user_id;
@synthesize screen_name;
@synthesize error_code;
@synthesize error;
@synthesize error_CN;
@synthesize requestTokenURL = _requestTokenURL, accessTokenURL = _accessTokenURL, authorizeURL = _authorizeURL, verifyCredentialsURL = _verifyCredentialsURL;

#pragma mark -
#pragma mark Init and dealloc

/**
 * Initialize an OAuth context object with a given consumer key and secret. These are immutable as you
 * always work in the context of one app.
 */
- (id) initWithConsumerKey:(NSString *)aConsumerKey 
		 andConsumerSecret:(NSString *)aConsumerSecret {
    self = [super init];
	if (self) {
		oauth_consumer_key = [aConsumerKey copy];
		oauth_consumer_secret = [aConsumerSecret copy];
		oauth_signature_method = @"HMAC-SHA1";
		oauth_version = @"1.0";
		self.oauth_token = @"";
		self.oauth_token_secret = @"";
		self.oauth_verifier = @"";
		srandom(time(NULL)); // seed the random number generator, used for generating nonces
		self.oauth_token_authorized = NO;
		self.delegate = nil;
		self.user_id = @"";
		self.screen_name = @"";
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
	if (self) {
		srandom(time(NULL)); // seed the random number generator, used for generating nonces
		oauth_consumer_key = [[decoder decodeObjectForKey:@"oauth_consumer_key"]retain];
		oauth_consumer_secret = [[decoder decodeObjectForKey:@"oauth_consumer_secret"]retain];
		oauth_signature_method = [[decoder decodeObjectForKey:@"oauth_signature_method"]retain];
		oauth_version = [[decoder decodeObjectForKey:@"oauth_version"]retain];
		oauth_token = [[decoder decodeObjectForKey:@"oauth_token"]retain];
		oauth_token_secret = [[decoder decodeObjectForKey:@"oauth_token_secret"]retain];
		oauth_verifier = [[decoder decodeObjectForKey:@"oauth_verifier"]retain];
		user_id = [[decoder decodeObjectForKey:@"user_id"]retain];
		screen_name = [[decoder decodeObjectForKey:@"sourceUrl"]retain];
		oauth_token_authorized = [decoder decodeBoolForKey:@"oauth_token_authorized"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:oauth_consumer_key forKey:@"oauth_consumer_key"];
	[encoder encodeObject:oauth_consumer_secret forKey:@"oauth_consumer_secret"];
	[encoder encodeObject:oauth_signature_method forKey:@"oauth_signature_method"];
	[encoder encodeObject:oauth_version forKey:@"oauth_version"];
	[encoder encodeObject:oauth_token forKey:@"oauth_token"];
	[encoder encodeObject:oauth_token_secret forKey:@"oauth_token_secret"];
	[encoder encodeObject:oauth_verifier forKey:@"oauth_verifier"];
	[encoder encodeObject:user_id forKey:@"user_id"];
	[encoder encodeObject:screen_name forKey:@"screen_name"];
	[encoder encodeBool:oauth_token_authorized forKey:@"oauth_token_authorized"];
}


- (void) dealloc {
	[oauth_consumer_key release];
	[oauth_consumer_secret release];
	[oauth_token release];
	[oauth_token_secret release];
	[user_id release];
	[screen_name release];
	self.authorizeURL = nil;
	self.requestTokenURL = nil;
	self.accessTokenURL = nil;
	self.verifyCredentialsURL = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark KVC

/**
 * We specify a set of keys that are known to be returned from OAuth responses, but that we are not interested in.
 * In case of any other keys, we log them since they may indicate changes in API that we are not prepared
 * to deal with, but we continue nevertheless.
 * This is only relevant for the Twitter request/authorize convenience methods that do HTTP calls and parse responses.
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	// KVC: define a set of keys that are known but that we are not interested in. Just ignore them.
	if ([[NSSet setWithObjects:
		  @"oauth_callback_confirmed",
		  nil] containsObject:key]) {
		
	// ... but if we got a new key that is not known, log it.
	} else {
		NSLog(@"Got unknown key from provider response. Key: \"%@\", value: \"%@\"", key, value);
	}
}

#pragma mark -
#pragma mark Public methods

/**
 * You will be calling this most of the time in your app, after the bootstrapping (authorization) is complete. You pass it
 * a set of information about your HTTP request (HTTP method, URL and any extra parameters), and you get back a header value
 * that you can put in the "Authorization" header. The header will also include a signature.
 *
 * "params" should be NSDictionary with any extra material to add in the signature. If you are doing a POST request,
 * this needs to exactly match what you will be POSTing. If you are GETting, this should include the parameters in your
 * QUERY_STRING; if there are none, this is nil.
 */
- (NSString *) oAuthHeaderForMethod:(NSString *)method andUrl:(NSString *)url andParams:(NSDictionary *)params {
	return [self oAuthHeaderForMethod:method 
							   andUrl:url
							andParams:params
					   andTokenSecret:self.oauth_token_authorized ? oauth_token_secret : @""];
}

/**
 * An extra method that lets the caller override the token secret used to sign the header. This is determined automatically
 * most of the time based on if our token has been authorized or not and you can use the method without the extra parameter,
 * but we need to override it for our /authorize request because our token has not been authorized by this point,
 * yet we still need to sign our /authorize request with both consumer and token secrets.
 */
- (NSString *) oAuthHeaderForMethod:(NSString *)method
							 andUrl:(NSString *)url
						  andParams:(NSDictionary *)params
					 andTokenSecret:(NSString *)token_secret {

	OAHMAC_SHA1SignatureProvider *sigProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	
	// If there were any params, URLencode them.
	NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithCapacity:[params count]];
	if (params) {
		for (NSString *key in [params allKeys]) {
			[_params setObject:[[params objectForKey:key] encodedURLParameterString] forKey:key];
		}
	}
	
	// Given a signature base and secret key, calculate the signature.
	NSString *oauth_signature = [sigProvider
								 signClearText:[self oauth_signature_base:method
																  withUrl:url
																andParams:_params]
								 withSecret:[NSString stringWithFormat:@"%@&%@", oauth_consumer_secret, token_secret]];
	[sigProvider release];
	
	// Return the authorization header using the signature and parameters (if any).
	return [self oauth_authorization_header:oauth_signature withParams:_params];
}

/**
 * When the user invokes the "sign out" function in the app, forget the current OAuth context.
 * We still remember consumer key and secret
 * since those are for an app and don't change, but we forget everything else.
 */
- (void) forget {
	self.oauth_token_authorized = NO;
	self.oauth_token = @"";
	self.oauth_token_secret = @"";
	self.oauth_verifier = @"";
	self.user_id = @"";
	self.screen_name = @"";
}

- (NSString *) description {
	return [NSString stringWithFormat:@"OAuth context object with consumer key \"%@\", token \"%@\". Authorized: %@",
			oauth_consumer_key, self.oauth_token, self.oauth_token_authorized ? @"YES" : @"NO"]; 
}

- (WeiboConnection *)getWeiboConnectionWithDelegate:(id)_delegate 
											 action:(SEL)anAction {
	return nil;
}


#pragma mark -
#pragma mark Weibo convenience methods

/**
 * Given a request URL, request an unauthorized OAuth token from that URL. This starts
 * the process of getting permission from user. This is done synchronously. If you want
 * threading, do your own.
 *
 * This is the request/response specified in OAuth Core 1.0A section 6.1.
 */
- (void) synchronousRequestToken {
	
	// Invalidate the previous request token, whether it was authorized or not.
	self.oauth_token_authorized = NO; // We are invalidating whatever token we had before.
	self.oauth_token = @"";
	self.oauth_token_secret = @"";
	
	// Calculate the header.
    //NSDictionary *params = [NSDictionary dictionaryWithObject:@"oob" forKey:@"oauth_callback"];
	NSString *oauth_header = [self oAuthHeaderForMethod:@"POST" andUrl:[self.requestTokenURL absoluteString] andParams:nil];
	
	// Synchronously perform the HTTP request.
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.requestTokenURL];
	request.requestMethod = @"POST";
	request.timeOutSeconds = 120;
	[request addRequestHeader:@"Authorization" value:oauth_header];
	//NSLog(@"Authorization Header(%@): %@", [self.requestTokenURL absoluteString], oauth_header);
	[request startSynchronous];
	[ApplicationHelper increaseNetworkActivityIndicator];
	NSError *err = [request error];
	if (err) {
		NSLog(@"error: %@", [err localizedDescription]);
	}
	if ([request error]) {
		if ([self.delegate respondsToSelector:@selector(requestTokenDidFail:)]) {
			[delegate requestTokenDidFail:self];
		}
	} else {
		NSArray *responseBodyComponents = [[request responseString] componentsSeparatedByString:@"&"];
		// For a successful response, break the response down into pieces and set the properties
		// with KVC. If there's a response for which there is no local property or ivar, this
		// may end up with setValue:forUndefinedKey:.
		for (NSString *component in responseBodyComponents) {
			NSArray *subComponents = [component componentsSeparatedByString:@"="];
			[self setValue:[subComponents objectAtIndex:1] forKey:[subComponents objectAtIndex:0]];			
		}
		if ([self.delegate respondsToSelector:@selector(requestTokenDidSucceed:)]) {
			[delegate requestTokenDidSucceed:self];
		}
	}
	[ApplicationHelper decreaseNetworkActivityIndicator];
}

- (void) synchronousAuthorizeTokenWithUserInfo:(NSDictionary *)userInfo {
	NSString *username = [userInfo objectForKey:@"username"];
	NSString *password = [userInfo objectForKey:@"password"];
	[self synchronousAuthorizeTokenWithUsername:username password:password];
}

- (void) synchronousAuthorizeTokenWithUsername:(NSString *)username
									  password:(NSString *)password {
	
    NSLog(@"login with username: %@", username);
	self.oauth_token_authorized = NO; // We are invalidating whatever token we had before.
	self.oauth_token = @"";
	self.oauth_token_secret = @"";
	self.error_code = @"";
	self.error = @"";
	self.error_CN = @"";
	
	NSMutableDictionary *_params = [NSMutableDictionary dictionary];
	[_params setObject:username forKey:@"x_auth_username"];
	[_params setObject:password forKey:@"x_auth_password"];
	[_params setObject:@"client_auth" forKey:@"x_auth_mode"];
	[_params setObject:oauth_consumer_key forKey:@"oauth_consumer_key"];
	[_params setObject:@"HMAC-SHA1" forKey:@"oauth_signature_method"];
	[_params setObject:@"1.0" forKey:@"oauth_version"];
	//[_params setObject:@"HMAC-SHA1" forKey:@"oauth_signature"];
	OAHMAC_SHA1SignatureProvider *sigProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
	
	// Given a signature base and secret key, calculate the signature.
	NSString *oauth_signature = [sigProvider
								 signClearText:[self oauth_signature_base:@"POST"
																  withUrl:[self.accessTokenURL absoluteString]
																andParams:_params]
								 withSecret:[NSString stringWithFormat:@"%@&%@", oauth_consumer_secret, @""]];
	[sigProvider release];
	
	[_params setObject:oauth_timestamp forKey:@"oauth_timestamp"];
	[_params setObject:oauth_nonce forKey:@"oauth_nonce"];
	
	
	NSMutableArray *chunks = [[[NSMutableArray alloc] init] autorelease];
	
	for (NSString *key in [[_params allKeys] sortedArrayUsingSelector:@selector(compare:)]) {		
		[chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", key, [[_params objectForKey:key] encodedURLParameterString]]];
	}

	// Signature will be the last component of our header.
	[chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", @"oauth_signature", [oauth_signature encodedURLParameterString]]];
	
	NSString *oauth_header = [NSString stringWithFormat:@"OAuth %@", [chunks componentsJoinedByString:@", "]];
	
	NSLog(@"Authorization: %@ , url: %@", oauth_header, [self.accessTokenURL absoluteString]);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.accessTokenURL];
	request.requestMethod = @"POST";
	[request addRequestHeader:@"Authorization" value:oauth_header];
	[request startSynchronous];
	
	[ApplicationHelper increaseNetworkActivityIndicator];
	
	if ([request error]) {
		NSError *err = [request error];
		NSLog(@"synchronousAuthorizeTokenWithUsername request error:  %@", [err localizedDescription]);
		if ([self.delegate respondsToSelector:@selector(authorizeTokenDidFail:)]) {
			[delegate authorizeTokenDidFail:self];
		}
	} else {
		NSArray *responseBodyComponents = [[request responseString] componentsSeparatedByString:@"&"];
        NSLog(@"synchronousAuthorizeTokenWithUsername response: %@", responseBodyComponents);
		for (NSString *component in responseBodyComponents) {
			// Twitter as of January 2010 returns oauth_token, oauth_token_secret, user_id and screen_name.
			// We support all these.
			//NSLog(@"component: %@", component);
			NSArray *subComponents = [component componentsSeparatedByString:@"="];
			/*
			if ([@"error_code" isEqualToString:[subComponents objectAtIndex:0]]
				&& [[subComponents objectAtIndex:1] intValue] > 0) {
				
			}
			 */
            if ([subComponents count] == 2) {
                [self setValue:[[subComponents objectAtIndex:1]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[subComponents objectAtIndex:0]];			
            }
		}
		if ([error_code intValue] > 0) {
			NSLog(@"error_cn: %@", error_CN);
			if ([self.delegate respondsToSelector:@selector(authorizeTokenDidFail:)]) {
				[delegate authorizeTokenDidFail:self];
			}
		}
		else {
			self.oauth_token_authorized = YES;
			if ([self.delegate respondsToSelector:@selector(authorizeTokenDidSucceed:)]) {
				[delegate authorizeTokenDidSucceed:self];
			}
		}
	}
	[ApplicationHelper decreaseNetworkActivityIndicator];
	
}


/**
 * By this point, we have a token, and we have a verifier such as PIN from the user. We combine
 * these together and exchange the unauthorized token for a new, authorized one.
 *
 * This is the request/response specified in OAuth Core 1.0A section 6.3.
 */
- (void) synchronousAuthorizeTokenWithVerifier:(NSString *)_oauth_verifier {
	
	
	self.oauth_verifier = _oauth_verifier;
	
	// We manually specify the token as a param, because it has not yet been authorized
	// and the automatic state checking wouldn't include it in signature construction or header,
	// since oauth_token_authorized is still NO by this point.
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
							oauth_token, @"oauth_token",
							oauth_verifier, @"oauth_verifier",
							nil];
	
	NSString *oauth_header = [self oAuthHeaderForMethod:@"POST" andUrl:[self.accessTokenURL absoluteString] andParams:params andTokenSecret:oauth_token_secret];

	//NSLog(@"Authorization: %@", oauth_header);

	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.accessTokenURL];
	request.requestMethod = @"POST";
	[request addRequestHeader:@"Authorization" value:oauth_header];
	[request startSynchronous];
	
	[ApplicationHelper increaseNetworkActivityIndicator];
	
	if ([request error]) {
		if ([self.delegate respondsToSelector:@selector(authorizeTokenDidFail:)]) {
			[delegate authorizeTokenDidFail:self];
		}
	} else {
		NSArray *responseBodyComponents = [[request responseString] componentsSeparatedByString:@"&"];
		for (NSString *component in responseBodyComponents) {
			// Twitter as of January 2010 returns oauth_token, oauth_token_secret, user_id and screen_name.
			// We support all these.
			//NSLog(@"component: %@", component);
			NSArray *subComponents = [component componentsSeparatedByString:@"="];
			[self setValue:[subComponents objectAtIndex:1] forKey:[subComponents objectAtIndex:0]];			
		}
		
		self.oauth_token_authorized = YES;
		if ([self.delegate respondsToSelector:@selector(authorizeTokenDidSucceed:)]) {
			[delegate authorizeTokenDidSucceed:self];
		}
	}
	[ApplicationHelper decreaseNetworkActivityIndicator];
}


/**
 * Verify with the provider whether the credentials are currently valid. YES if yes.
 */
/*
- (BOOL) synchronousVerifyCredentials {
	
	NSString *oauth_header = [self oAuthHeaderForMethod:@"GET" andUrl:[self.verifyCredentialsURL absoluteString] andParams:nil];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.verifyCredentialsURL];
	request.requestMethod = @"GET";
	[request addRequestHeader:@"Authorization" value:oauth_header];
	[request startSynchronous];
	[
	if ([request error]) {
		return NO;
	} else {
		return YES;
	}
}
 */

#pragma mark -
#pragma mark Internal utilities for crypto, signing.

/**
 * Given a HTTP method, URL and a set of parameters, calculate the signature base string according to the spec.
 * Some ideas for the implementation come from OAMutableUrlRequest
 * (http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/OAMutableURLRequest.m).
 */
- (NSString *) oauth_signature_base:(NSString *)httpMethod withUrl:(NSString *)url andParams:(NSDictionary *)params {
	
	// Freshen the context. Get a fresh timestamp and calculate a nonce.
	// Nonce algorithm is sha1(timestamp || random), i.e
	// we concatenate timestamp with a random string, and then sha1 it.
	int timestamp = time(NULL);
	oauth_timestamp = [NSString stringWithFormat:@"%d", timestamp];
	int myRandom = random();
	oauth_nonce = [self sha1:[NSString stringWithFormat:@"%d%d", timestamp, myRandom]];
	
	NSMutableDictionary *parts = [NSMutableDictionary dictionaryWithCapacity:[[self oauth_base_components] count]];
	
	[NSMutableArray arrayWithCapacity:[[self oauth_base_components] count]];
	
	// Include all the OAuth base components into signature base string, no matter what else is going on.
	for (NSString *part in [self oauth_base_components]) {
		[parts setObject:[self valueForKey:part] forKey:part];
	}
	
	if (params) {		
		[parts addEntriesFromDictionary:params];
	}
	
	// Sort the base string components and make them into string key=value pairs.
	NSMutableArray *normalizedBase = [NSMutableArray arrayWithCapacity:[parts count]];
	for (NSString *key in [[parts allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
		[normalizedBase addObject:[NSString stringWithFormat:@"%@=%@", key, [parts objectForKey:key]]];
	}
	
	NSString *normalizedRequestParameters = [normalizedBase componentsJoinedByString:@"&"];
	
	// Return the signature base string. Note that the individual parameters must have previously
	// already URL-encoded and here we are encoding them again; thus you will see some
	// double URL-encoding for params. This is normal.
	NSString *ret = [NSString stringWithFormat:@"%@&%@&%@",
            httpMethod,
            [url encodedURLParameterString],
            [normalizedRequestParameters encodedURLParameterString]];
	//NSLog(@"normalizedRequestParameters: %@, ret: %@",normalizedRequestParameters, ret);
	return ret;
}

/**
 * Given a calculated signature (by this point it is Base64-encoded string) and a set of parameters, return
 * the header value that you will stick in the "Authorization" header.
 */
- (NSString *) oauth_authorization_header:(NSString *)oauth_signature withParams:(NSDictionary *)params {
	NSMutableArray *chunks = [[[NSMutableArray alloc] init] autorelease];
	
	// First add all the base components.
	[chunks addObject:[NSString stringWithString:@"OAuth realm=\"\""]];
	for (NSString *part in [self oauth_base_components]) {
		[chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", part, [[self valueForKey:part] encodedURLParameterString]]];
	}
	
	// Add parameter values if any. They don't really have to be sorted, but we do it anyway
	// just to be nice and make the output somewhat more parsable.
	
	/*
	if (params) {
		for (NSString *key in [[params allKeys] sortedArrayUsingSelector:@selector(compare:)]) {		
			[chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", key, [params objectForKey:key]]];
		}
	}
	 */
	
	// Signature will be the last component of our header.
	[chunks addObject:[NSString stringWithFormat:@"%@=\"%@\"", @"oauth_signature", [oauth_signature encodedURLParameterString]]];
	
	return [NSString stringWithFormat:@"%@", [chunks componentsJoinedByString:@", "]];
}

/**
 * Return the set of OAuth base components to always include in signature base string and header. If we have an authorized token, we use it,
 * otherwise we don't. The token is not authorized for /request and /access_token. For the former, we don't need to include the token.
 * For the latter, we include it manually as an input parameter to the methods.
 */
- (NSArray *) oauth_base_components {
	if (self.oauth_token_authorized) {
		return [NSArray arrayWithObjects:@"oauth_timestamp", @"oauth_nonce",
				@"oauth_signature_method", @"oauth_consumer_key", @"oauth_version", @"oauth_token", nil]; //@"oauth_verifier",
	} else {
		return [NSArray arrayWithObjects:@"oauth_timestamp", @"oauth_nonce",
				@"oauth_signature_method", @"oauth_consumer_key", @"oauth_version", @"oauth_token",  nil];
	}
}

// http://stackoverflow.com/questions/1353771/trying-to-write-nsstring-sha1-function-but-its-returning-null
- (NSString *)sha1:(NSString *)str {
	const char *cStr = [str UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, strlen(cStr), result);
	NSMutableString *out = [NSMutableString stringWithCapacity:20];
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[out appendFormat:@"%02X", result[i]];
	}
	return [out lowercaseString];
}

@end
