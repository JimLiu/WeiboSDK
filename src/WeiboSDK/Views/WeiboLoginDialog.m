//
//  WeiboLoginDialog.m
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import "WeiboLoginDialog.h"

@interface WeiboLoginDialog()

@property (nonatomic, weak) id<WeiboLoginDialogDelegate> loginDelegate;

@end

@implementation WeiboLoginDialog

-(id) initWithURL:(NSURL *) loginURL
         delegate:(id <WeiboLoginDialogDelegate>) delegate {
    self = [super init];
    if (self) {
        self.requestURL = loginURL;
        self.loginDelegate = delegate;
    }
    return self;
}

- (void) dialogDidSucceed:(NSURL*)url {
    NSRange range = [url.absoluteString rangeOfString:@"code="];
    if (range.location != NSNotFound)
    {
        NSString *code = [url.absoluteString substringFromIndex:range.location + range.length];
        NSLog(@"code: %@", code);
        // if it was not canceled
        if (![code isEqualToString:@"21330"])
        {
            if ([self.loginDelegate respondsToSelector:@selector(dialogLogin:)])
            {
                [self.loginDelegate dialogLogin:code];
                [self dismissWithSuccess:YES animated:YES];
            }
        }
        else {
            if ([self.loginDelegate respondsToSelector:@selector(dialogNotLogin:)]) {
                [self.loginDelegate dialogNotLogin:YES];
            }
            [self dismissWithSuccess:NO animated:YES];
        }
    }
    
}

@end
