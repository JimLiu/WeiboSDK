//
//  WebBrowserView.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebBrowserViewDelegate

- (void)hideWebBrowser;

@end


@interface WebBrowserView : UIView <UIWebViewDelegate,UIActionSheetDelegate> {
	UIWebView *webView;
	UIToolbar *toolBar;
	
	UIBarButtonItem *btnGoBack;
	UIBarButtonItem *btnGoForward;
	UIButton *btnRefresh;
	UIBarButtonItem *btnZoomOut;
	UIBarButtonItem *btnAction;
	UIBarButtonItem *space;
	UILabel *lblTitle;
	UIImageView *loadingView;
	UIActivityIndicatorView *activityIndicatorView;
	UIActionSheet *actionSheet;
	
	id<WebBrowserViewDelegate> webBrowserViewDelegate;
}

@property (nonatomic, assign) id<WebBrowserViewDelegate> webBrowserViewDelegate;

- (void)didBtnGoForwardTouch:(id)sender;
- (void)didBtnGoBackTouch:(id)sender;
- (void)didBtnRefreshTouch:(id)sender;
- (void)didBtnActionTouch:(id)sender;
- (void)didBtnZoomOutTouch:(id)sender;
- (void)loadURL:(NSURL *)url;

@end
