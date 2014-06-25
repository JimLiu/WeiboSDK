//
//  WeiboRequestOperation.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/4/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "WeiboRequestOperation.h"

NSString *const WeiboAPIErrorDomain = @"com.openlab.weibosdk.api";
NSString *const WeiboAuthErrorNotification = @"WeiboAuthErrorNotification";
static const int kGeneralErrorCode = 10000;

@interface WeiboRequestOperation () {
    BOOL _executing;
    BOOL _finished;
}

@property (nonatomic, copy) WeiboRequestCompletedBlock completedBlock;
@property (nonatomic, copy) void (^cancelBlock)();

@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished) BOOL finished;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, assign) dispatch_queue_t queue;

@end

@implementation WeiboRequestOperation

@synthesize executing=_executing;
@synthesize finished=_finished;

- (id)initWithRequest:(NSURLRequest *)request
                queue:(dispatch_queue_t)queue
            completed:(WeiboRequestCompletedBlock)completedBlock
            cancelled:(void (^)())cancelBlock
{
    if ((self = [super init]))
    {
        _queue = queue;
        _request = request;
        _completedBlock = [completedBlock copy];
        _cancelBlock = [cancelBlock copy];
        _executing = NO;
        _finished = NO;
    }
    return self;
}

- (void)start
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if (self.isCancelled)
        {
            self.finished = YES;
            [self reset];
            return;
        }
                       
        self.executing = YES;
        self.connection = [NSURLConnection.alloc initWithRequest:self.request delegate:self startImmediately:NO];
        [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];     
        [self.connection start];
    
        if (!self.connection)
        {
            if (self.completedBlock)
            {
                self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Connection can't be initialized"}]);
            }
        }
    });
}

- (void)cancel
{
    if (self.isFinished) return;
    [super cancel];
    if (self.cancelBlock) self.cancelBlock();
    
    if (self.connection)
    {
        [self.connection cancel];
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    
    [self reset];
}

- (void)done
{
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.cancelBlock = nil;
        self.completedBlock = nil;
        self.connection = nil;
        self.responseData = nil;
    });
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent
{
    return YES;
}


- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
    return [NSError errorWithDomain:WeiboAPIErrorDomain code:code userInfo:errorData];
    
}

- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
	NSError *parseError = nil;
    
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
    
	if (parseError)
    {
        if (error != nil)
        {
            *error = [self formError:kGeneralErrorCode
                            userInfo:parseError.userInfo];
        }
	}
    
	if ([result isKindOfClass:[NSDictionary class]])
	{
		if ([result objectForKey:@"error_code"] != nil && [[result objectForKey:@"error_code"] intValue] != 200)
		{
            
            int errorCode = [[result objectForKey:@"error_code"] intValue];
            NSError *_error = [self formError:errorCode userInfo:result];;
            if (error != nil)
            {
                *error = _error;
            }
            if (   errorCode == 21301
                || errorCode == 21314
                || errorCode == 21315
                || errorCode == 21316
                || errorCode == 21317
                || errorCode == 21332) {
                _sessionDidExpire = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:WeiboAuthErrorNotification
                                                                    object:_error];
            }
            
			
		}
	}
	
	return result;
}


#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400)
    {
        NSUInteger expected = response.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;        
        dispatch_async(self.queue, ^
       {
           self.responseData = [NSMutableData.alloc initWithCapacity:expected];
       });
    }
    else
    {
        [self.connection cancel];
        
        if (self.completedBlock)
        {
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:[((NSHTTPURLResponse *)response) statusCode] userInfo:nil]);
        }
        
        [self done];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    dispatch_async(self.queue, ^
    {
        [self.responseData appendData:data];
   });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    self.connection = nil;
    
    WeiboRequestCompletedBlock completionBlock = self.completedBlock;
    
    if (completionBlock)
    {
        dispatch_async(self.queue, ^
        {
            NSError* error = nil;
            //NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
            id result = [self parseJsonResponse:self.responseData error:&error];

            dispatch_async(dispatch_get_main_queue(), ^
            {
               completionBlock(result, self.responseData, nil);
               self.completionBlock = nil;
               [self done];
            });
        });
    }
    else
    {
        [self done];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    if (self.completedBlock)
    {
        self.completedBlock(nil, nil, error);
    }
    
    [self done];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    if (self.request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData)
    {
        // Prevents caching of responses
        return nil;
    }
    else
    {
        return cachedResponse;
    }
}

@end
