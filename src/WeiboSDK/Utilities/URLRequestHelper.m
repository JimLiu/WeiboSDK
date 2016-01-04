//
//  URLRequestHelper.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "URLRequestHelper.h"

NSString *kUserAgent = @"Openlab WeiboSDK";


@interface FileInfo : NSObject

- (id)initWithKey:(NSString *)key
         filename:(NSString *)filename
      contentType:(NSString *)contentType
             data:(NSData *)data;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, strong) NSData *data;

@end

@implementation FileInfo

- (id)initWithKey:(NSString *)key
         filename:(NSString *)filename
      contentType:(NSString *)contentType
             data:(NSData *)data {
    self = [super init];
    if (self) {
        self.key = key;
        self.fileName = filename;
        self.contentType = contentType;
        self.data = data;
    }
    return self;
}

@end


@interface PostItem : NSObject

- (id)initWithKey:(NSString *)key value:(NSString *)value;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end

@implementation PostItem

- (id)initWithKey:(NSString *)key value:(NSString *)value {
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end


@implementation URLRequestHelper

+ (NSString*)encodeURL:(NSString *)string
{
	NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if ([[params objectForKey:key] isKindOfClass:[NSData class]]) {
            continue;
        }
        NSString *value = [params objectForKey:key];
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", [self encodeURL:key], [self encodeURL:value]]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return @"image/jpeg";
}

+ (NSMutableURLRequest *)getRequestWithUrl:(NSString *)url
                                    params:(NSDictionary *)params {
    
    NSString* urlString = [self serializeURL:url params:params];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString] cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval: 30.f];
    [request setHTTPMethod: @"GET"];
    [request setValue: kUserAgent forHTTPHeaderField: @"User-Agent"];
    return request;
}


+ (NSMutableURLRequest *)postRequestWithUrl:(NSString *)url
                                     params:(NSDictionary *)params {
    NSURL* postURL = [NSURL URLWithString:url];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:postURL  cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval: 30.f];
    [request setHTTPMethod: @"POST"];
    [request setValue: kUserAgent forHTTPHeaderField: @"User-Agent"];
    
    NSMutableArray *postData = [NSMutableArray array];
    NSMutableArray *fileData = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        id val = [params objectForKey:key];
        if ([val isKindOfClass:[NSData class]]) {
            NSString *contentType = [self contentTypeForImageData:val];
            if (contentType) {
                FileInfo *fileInfo = [[FileInfo alloc] initWithKey:key filename:[contentType stringByReplacingOccurrencesOfString:@"/" withString:@"_from_openlab_weibosdk."] contentType:contentType data:val];
                [fileData addObject:fileInfo];
            }
        }
        else {
            PostItem *postItem = [[PostItem alloc]initWithKey:key value:val];
            [postData addObject:postItem];
        }
    }
    NSMutableData *requestData = nil;
    if (fileData.count > 0) {
        requestData = [self buildMultipartFormDataPostBodyWithPostData:postData withFileData:fileData forRequest:request];
    }
    else {
        requestData = [self buildURLEncodedPostBodyWithPostData:postData forRequest:request];
    }
    [request setValue: [NSString stringWithFormat: @"%lu", (unsigned long)[requestData length]] forHTTPHeaderField: @"Content-Length"];
    [request setHTTPBody:requestData];
    return request;
}




+ (void)appendPostString:(NSString *)string toData:(NSMutableData *)data {
    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSMutableData *)buildMultipartFormDataPostBodyWithPostData:(NSMutableArray *)postData
                                      withFileData:(NSMutableArray *)fileData
                                        forRequest:(NSMutableURLRequest*) request
{
    NSMutableData *requestData = [NSMutableData data];
	NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
	CFUUIDRef uuid = CFUUIDCreate(nil);
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
	CFRelease(uuid);
	NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    
    
    [request setValue: [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, stringBoundary] forHTTPHeaderField: @"Content-Type"];
    
	[self appendPostString:[NSString stringWithFormat:@"--%@\r\n",stringBoundary]
                    toData:requestData];
    
	// Adds post data
	NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
	NSUInteger i=0;
	for (PostItem *item in postData) {
		[self appendPostString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",item.key]
                        toData:requestData];
		[self appendPostString:item.value toData:requestData];
		i++;
		if (i != [postData count] || [fileData count] > 0) { //Only add the boundary if this is not the last item in the post body
			[self appendPostString:endItemBoundary toData:requestData];
		}
	}
    
	// Adds files to upload
	i=0;
	for (FileInfo *fileInfo in fileData) {
        
		[self appendPostString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileInfo.key, fileInfo.fileName] toData:requestData];
		[self appendPostString:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", fileInfo.contentType] toData:requestData];
        
		[requestData appendData:fileInfo.data];
		i++;
		// Only add the boundary if this is not the last item in the post body
		if (i != [fileData count]) {
			[self appendPostString:endItemBoundary toData:requestData];
		}
	}
    
	[self appendPostString:[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary]  toData:requestData];
    return requestData;
}

+ (NSMutableData *)buildURLEncodedPostBodyWithPostData:(NSMutableArray *)postData
                                 forRequest:(NSMutableURLRequest*) request
{
    NSMutableData *requestData = [NSMutableData data];
	NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    [request setValue: [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset] forHTTPHeaderField: @"Content-Type"];
    
	NSUInteger i=0;
	NSUInteger count = [postData count]-1;
	for (PostItem *item in postData) {
        NSString *data = [NSString stringWithFormat:@"%@=%@%@", [self encodeURL:item.key], [self encodeURL:item.value],(i<count ?  @"&" : @"")];
        [self appendPostString:data toData:requestData];
		i++;
	}
    return requestData;
}



@end
