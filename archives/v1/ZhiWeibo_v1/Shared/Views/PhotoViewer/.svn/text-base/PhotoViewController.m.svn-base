//
//  PhotoViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-30.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoImageView.h"

@interface PhotoViewController (Private)

- (void)setupToolbar;

@end


@implementation PhotoViewController

- (void)showImage:(Photo *)photo {
	[photoImageView setPhoto:photo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	photoImageView = [[PhotoImageView alloc]initWithFrame:self.view.bounds];
	photoImageView.photoImageViewDelegate = self;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePhoto)];
	photoImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth 
		| UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin 
		| UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin 
		| UIViewAutoresizingFlexibleBottomMargin;

	[self.view addSubview:photoImageView];
	self.view.backgroundColor = [UIColor blackColor];
	self.wantsFullScreenLayout = YES;

}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if(!_storedOldStyles) {
		_oldStatusBarSyle = [UIApplication sharedApplication].statusBarStyle;
		
		_oldNavBarTintColor = [self.navigationController.navigationBar.tintColor retain];
		_oldNavBarStyle = self.navigationController.navigationBar.barStyle;
		_oldNavBarTranslucent = self.navigationController.navigationBar.translucent;
		
		_oldToolBarTintColor = [self.navigationController.toolbar.tintColor retain];
		_oldToolBarStyle = self.navigationController.toolbar.barStyle;
		_oldToolBarTranslucent = self.navigationController.toolbar.translucent;
		_oldToolBarHidden = [self.navigationController isToolbarHidden];
		
		_storedOldStyles = YES;
	}	
	
	if ([self.navigationController isToolbarHidden]) {
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
	
	self.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.translucent = YES;
	
	self.navigationController.toolbar.tintColor = nil;
	self.navigationController.toolbar.barStyle = UIBarStyleBlack;
	self.navigationController.toolbar.translucent = YES;
	
	[self setupToolbar];
	
}

- (void)resetToolbar {
	self.navigationController.navigationBar.barStyle = _oldNavBarStyle;
	self.navigationController.navigationBar.tintColor = _oldNavBarTintColor;
	self.navigationController.navigationBar.translucent = _oldNavBarTranslucent;
	
	[[UIApplication sharedApplication] setStatusBarStyle:_oldStatusBarSyle animated:YES];
	
	if(!_oldToolBarHidden) {
		
		if ([self.navigationController isToolbarHidden]) {
			[self.navigationController setToolbarHidden:NO animated:YES];
		}
		
		self.navigationController.toolbar.barStyle = _oldNavBarStyle;
		self.navigationController.toolbar.tintColor = _oldNavBarTintColor;
		self.navigationController.toolbar.translucent = _oldNavBarTranslucent;
		
	} else {
		
		[self.navigationController setToolbarHidden:_oldToolBarHidden animated:YES];
		
	}
}

- (void)viewDidUnload{
	photoImageView=nil;
	[self resetToolbar];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self resetToolbar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
   	return (UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);
	
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	_rotating = YES;

	photoImageView.hidden = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
	[photoImageView rotateToOrientation:toInterfaceOrientation];
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
	photoImageView.hidden = NO;
	_rotating = NO;
	
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)setupToolbar {
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];

	
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonHit:)];
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[self setToolbarItems:[NSArray arrayWithObjects:flex, action, nil]];
	
	_actionButton=action;
	
	[action release];
	[flex release];
	
}


#pragma mark -
#pragma mark Bar/Caption Methods

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated{
	/*
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	
	[[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade]; //UIStatusBarAnimationFade
	
#else
	
	[[UIApplication sharedApplication] setStatusBarHidden:hidden animated:animated];
	
#endif
	 */
	
	if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
		[[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone]; 
	} else { 
		//id<UIApplicationDelegate> app = (id)[UIApplication sharedApplication];
		//[app setStatusBarHidden:hidden animated:animated];
		[[UIApplication sharedApplication] setStatusBarHidden:hidden animated:animated];

	}
}

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated{
	if (hidden&&_barsHidden) return;
	
	[self setStatusBarHidden:hidden animated:animated];
	
	[self.navigationController setNavigationBarHidden:hidden animated:animated];
	[self.navigationController setToolbarHidden:hidden animated:animated];

	_barsHidden=hidden;
	
}

- (void)toggleBarsNotification:(NSNotification*)notification{
	[self setBarsHidden:!_barsHidden animated:YES];
}


#pragma mark -
#pragma mark Actions

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo {
}


- (void)savePhoto{
	
	UIImageWriteToSavedPhotosAlbum(photoImageView.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil );
	
}

- (void)loadOriginalPhoto {
	[photoImageView loadOriginalPhoto];
}

- (void)copyPhoto{
	
	[[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(photoImageView.imageView.image) forPasteboardType:@"public.png"];
	
}

- (void)emailPhoto{
	
	MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
	[mailViewController setSubject:@"分享图片"];
	[mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation(photoImageView.imageView.image)] mimeType:@"png" fileName:@"Photo.png"];
	mailViewController.mailComposeDelegate = self;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	}
#endif
	
	[self presentModalViewController:mailViewController animated:YES];
	[mailViewController release];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	[self dismissModalViewControllerAnimated:YES];
	
	NSString *mailError = nil;
	
	switch (result) {
		case MFMailComposeResultSent: ; break;
		case MFMailComposeResultFailed: mailError = @"发送失败，请稍候重试...";
			break;
		default:
			break;
	}
	
	if (mailError != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mailError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}


#pragma mark -
#pragma mark UIActionSheet Methods

- (void)actionButtonHit:(id)sender{
	
	UIActionSheet *actionSheet;
	
	if ([MFMailComposeViewController canSendMail]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制", @"查看大图", @"Email", nil];
		
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"复制", @"查看大图", nil];
	} 
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.delegate = self;
	
	[actionSheet showInView:self.view];
	[self setBarsHidden:YES animated:YES];
	
	[actionSheet release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	[self setBarsHidden:NO animated:YES];
	
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
		[self copyPhoto];
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
		[self loadOriginalPhoto];	
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
		[self emailPhoto];
	} 
}



#pragma mark -
#pragma mark Memory

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
}


- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[photoImageView release], photoImageView=nil;
	[_oldToolBarTintColor release], _oldToolBarTintColor = nil;
	[_oldNavBarTintColor release], _oldNavBarTintColor = nil;
	
    [super dealloc];
}


#pragma mark -
#pragma mark PhotoImageViewDelegate

- (void)touch {
	[self setBarsHidden:!_barsHidden animated:YES];
}

- (void)photoDidFinishLoading:(Photo *)photo {
}

- (void)photoDidFailToLoad:(Photo *)photo {
}
@end
