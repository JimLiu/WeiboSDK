//
//  WeiboLoginDialog.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboDialog.h"
#import "WeiboAuthentication.h"

@protocol WeiboLoginDialogDelegate;

@interface WeiboLoginDialog : WeiboDialog

-(id) initWithURL:(NSURL *) loginURL
         delegate:(id <WeiboLoginDialogDelegate>) delegate;

@end

@protocol WeiboLoginDialogDelegate <NSObject>

- (void)dialogLogin:(NSString*)code;

- (void)dialogNotLogin:(BOOL)cancelled;

@end