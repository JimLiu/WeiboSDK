//
//  WeiboDialog.h
//  WeiboSDK
//
//  Created by Liu Jim on 8/3/13.
//  Copyright (c) 2013 openlab. All rights reserved.
//
// 参考代码：FBDialog

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WeiboDialogDelegate;

@interface WeiboDialog : UIView <UIWebViewDelegate> {
    UIWebView *_webView;
    UIActivityIndicatorView *_spinner;
    UIButton *_closeButton;
    UIInterfaceOrientation _orientation;
    UIView *_modalBackgroundView;
}

@property (nonatomic, weak) id<WeiboDialogDelegate> delegate;
@property (nonatomic, strong) NSURL* requestURL;


- (void)show;

- (void)load;

- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated;

- (void)dismissWithError:(NSError*)error animated:(BOOL)animated;

- (void)dialogWillAppear;

- (void)dialogWillDisappear;

- (void)dialogDidSucceed:(NSURL *)url;

- (void)dialogDidCancel:(NSURL *)url;

@end

@protocol WeiboDialogDelegate <NSObject>

@optional


- (void)dialogDidComplete:(WeiboDialog *)dialog;
- (void)dialogDidNotComplete:(WeiboDialog *)dialog;
- (void)dialogCompleteWithUrl:(NSURL *)url;
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url;
- (void)dialog:(WeiboDialog*)dialog didFailWithError:(NSError *)error;

@end
