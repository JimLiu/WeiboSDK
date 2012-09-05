//
//  Connection.m
//  TwitterFon
//
//  Created by kaz on 7/25/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import "URLConnection.h"
#import "StringUtil.h"
#import "DebugUtils.h"

#define NETWORK_TIMEOUT 120.0

@implementation URLConnection

@synthesize buf;
@synthesize statusCode;
@synthesize requestURL;

NSString *TWITTERFON_FORM_BOUNDARY = @"0194784892923";

- (id)initWithDelegate:(id)aDelegate engine:(OAuthEngine *)__engine
{
	self = [super init];
	_engine = [__engine retain];
	delegate = aDelegate;
    statusCode = 0;
    needAuth = false;
	return self;
}

- (void)dealloc
{
	[_engine release];
    [requestURL release];
	[connection release];
	[buf release];
	[super dealloc];
}


- (void)get:(NSString*)aURL
{
    [connection release];
	[buf release];
    statusCode = 0;
    
    self.requestURL = aURL;
    
    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    [URL autorelease];
	NSURL *finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@source=%@", 
											URL,
											([URL rangeOfString:@"?"].location != NSNotFound) ? @"&" : @"?" , 
											_engine.consumerKey]];
	
	NSMutableURLRequest* req;
	OAMutableURLRequest* oaReq;
	if (needAuth) {
		oaReq = [[[OAMutableURLRequest alloc] initWithURL:finalURL
											   consumer:_engine.consumer 
												  token:_engine.accessToken 
												  realm: nil
									  signatureProvider:nil] autorelease];
		req = oaReq;
	}
	else {
		req = [NSMutableURLRequest requestWithURL:finalURL
									  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
								  timeoutInterval:NETWORK_TIMEOUT];
	}
    [req setHTTPShouldHandleCookies:NO];
	
    if (needAuth)
		[oaReq prepare];
	/*
	NSDictionary *dic = [req allHTTPHeaderFields];
	for (NSString *key in [dic allKeys]) {
		NSLog(@"key:%@, value:%@", key, [dic objectForKey:key]);
	}
	 */
 	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)post:(NSString*)aURL body:(NSString*)body
{
    [connection release];
	[buf release];
    statusCode = 0;
    
    self.requestURL = aURL;
    
    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	[URL autorelease];
	NSURL *finalURL = [NSURL URLWithString:URL];
	NSMutableURLRequest* req;
	OAMutableURLRequest* oaReq;
	if (needAuth) {
		oaReq = [[[OAMutableURLRequest alloc] initWithURL:finalURL
												 consumer:_engine.consumer 
													token:_engine.accessToken 
													realm: nil
										signatureProvider:nil] autorelease];
		req = oaReq;
	}
	else {
		req = [NSMutableURLRequest requestWithURL:finalURL
									  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
								  timeoutInterval:NETWORK_TIMEOUT];
	}
    [req setHTTPMethod:@"POST"];
    [req setHTTPShouldHandleCookies:NO];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    [req setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
	NSString *finalBody = [NSString stringWithString:@""];
	if (body) {
		finalBody = [finalBody stringByAppendingString:body];
	}
	finalBody = [finalBody stringByAppendingString:[NSString stringWithFormat:@"%@source=%@", 
													(body) ? @"&" : @"?" , 
													_engine.consumerKey]];
	
	[req setHTTPBody:[finalBody dataUsingEncoding:NSUTF8StringEncoding]];
    if (needAuth)
		[oaReq prepare];
	
	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)post:(NSString*)aURL data:(NSData*)data
{
    [connection release];
	[buf release];
    statusCode = 0;

    self.requestURL = aURL;

    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    [URL autorelease];
	NSURL *finalURL = [NSURL URLWithString:URL];
	NSMutableURLRequest* req;
	OAMutableURLRequest* oaReq;
	if (needAuth) {
		oaReq = [[[OAMutableURLRequest alloc] initWithURL:finalURL
												 consumer:_engine.consumer 
													token:_engine.accessToken 
													realm: nil
										signatureProvider:nil] autorelease];
		req = oaReq;
	}
	else {
		req = [NSMutableURLRequest requestWithURL:finalURL
									  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
								  timeoutInterval:NETWORK_TIMEOUT];
	}
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", TWITTERFON_FORM_BOUNDARY];
    [req setHTTPShouldHandleCookies:NO];
    [req setHTTPMethod:@"POST"];
    [req setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:data];
    if (needAuth)
		[oaReq prepare];
	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)cancel
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;    
    if (connection) {
        [connection cancel];
        [connection autorelease];
        connection = nil;
    }
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)aResponse;
    if (resp) {
        statusCode = resp.statusCode;
        NSLog(@"Response: %d", statusCode);
    }
	[buf setLength:0];
}

- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
	[buf appendData:data];
}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	[connection autorelease];
	connection = nil;
	[buf autorelease];
	buf = nil;
    
    NSString* msg = [NSString stringWithFormat:@"Error: %@ %@",
                     [error localizedDescription],
                     [[error userInfo] objectForKey:NSErrorFailingURLStringKey]];
    
    NSLog(@"Connection failed: %@", msg);
    
    [self URLConnectionDidFailWithError:error];
    
}


- (void)URLConnectionDidFailWithError:(NSError*)error
{
    // To be implemented in subclass
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString* s = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
    
    [self URLConnectionDidFinishLoading:s];
	//NSLog(@"connectionDidFinishLoading:%@", s);

    [connection autorelease];
    connection = nil;
    [buf autorelease];
    buf = nil;
}

- (void)URLConnectionDidFinishLoading:(NSString*)content
{
    // To be implemented in subclass
}

@end
