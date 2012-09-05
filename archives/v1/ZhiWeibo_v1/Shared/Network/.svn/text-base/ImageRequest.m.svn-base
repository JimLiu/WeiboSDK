//
//  ImageConnection.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-4.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ImageRequest.h"
#import "ZhiWeiboAppDelegate.h"

@implementation ImageRequest
@synthesize buf;
@synthesize statusCode;
@synthesize requestURL;

- (id)initWithDelegate:(id)aDelegate
{
	if (self = [super init]) {
		delegate = aDelegate;
	}
	return self;
}

- (void)dealloc
{
    [requestURL release];
	[connection cancel];
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
	NSURL *finalURL = [NSURL URLWithString:URL];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:finalURL
													   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
												   timeoutInterval:120.0];
    
  	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [ZhiWeiboAppDelegate increaseNetworkActivityIndicator];
}


- (void)cancel
{
    [ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];    
    if (connection) {
        [connection cancel];
        [connection autorelease];
        connection = nil;
    }
}

- (void)connection:(NSURLConnection *)aConnection 
	didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)aResponse;
    if (resp) {
        statusCode = resp.statusCode;
    }
	NSDictionary *headers = [resp allHeaderFields];
	contentLength = [[headers objectForKey:@"Content-Length"] intValue];
	[buf setLength:0];
	NSLog(@"got to connection did receive response, contentLength:%d, statusCode:%d, url:%@, buf: %d"
		  , contentLength, statusCode, requestURL, buf == nil);
}

- (void)connection:(NSURLConnection *)aConn 
		didReceiveData:(NSData *)data
{
	//NSLog(@"1got some data total: %i", buf.length);
	[buf appendData:data];
	//NSLog(@"2got some data %i, total: %i", data.length, buf.length);
}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
    [ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];
	[connection autorelease];
	connection = nil;
	[buf autorelease];
	buf = nil;
    
    NSString* msg = [NSString stringWithFormat:@"Error: %@ %@",
                     [error localizedDescription],
                     [[error userInfo] objectForKey:NSErrorFailingURLStringKey]];
    
    NSLog(@"Connection failed: %@", msg);
    
    [delegate imageRequestDidFailWithError:error sender:self];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
    
    [ZhiWeiboAppDelegate decreaseNetworkActivityIndicator];
    
	if (buf.length == contentLength) {
		UIImage *image = [UIImage imageWithData:buf];    
		[delegate imageRequestDidSucceed:image sender:self];
		[connection autorelease];
		connection = nil;
		[buf autorelease];
		buf = nil;
		NSLog(@"connectionDidFinishLoading, url:%@, buf: %d", requestURL, buf == nil);
	}
	else {
		NSLog(@"!!connectionDidFinishLoading failed???, url:%@, buf: %d", requestURL, buf == nil);
		
	}
}


@end
