//
//  WebViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-20.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIActionSheetDelegate> {
    IBOutlet UIWebView* webView;
    IBOutlet UILabel*   titleLabel;
    IBOutlet UIToolbar* toolbar;
	
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;
    
    //NSURL*               url;
    NSURL*                  openingURL;
    NSURL*                  currentURL;
}

@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, retain) UILabel*   titleLabel;
@property (nonatomic, retain) UIToolbar* toolbar;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *forwardButton;


@property (nonatomic, retain) NSURL* currentURL;

- (void)loadUrl:(NSURL *)_url;

- (void)loadHtml:(NSString *)html;

- (IBAction)goBack: (id)sender;
- (IBAction)goForward: (id)sender;
- (IBAction)onAction: (id)sender;

- (IBAction)reload:(id)sender;
- (IBAction)stop:(id)sender;

@end
