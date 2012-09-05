//
//  ComposeViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIDevice-hardware.h"
#import "Reachability2.h"
#import "FriendCache.h"

static inline double radians(double degrees) {
    return degrees * M_PI / 180;
}

@implementation ComposeViewController
@synthesize closeButton, sendButton, titleItem;
@synthesize navigationBar, maskView, alertBackgroundView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
 UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
 UIViewAutoresizingFlexibleWidth        = 1 << 1,
 UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
 UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
 UIViewAutoresizingFlexibleHeight       = 1 << 4,
 UIViewAutoresizingFlexibleBottomMargin = 1 << 5
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[FriendCache loadFromLocal];
	self.titleItem.title = @"新微博";
	if (!composeView) {
		CGRect composeViewFrame = CGRectMake(0, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
		composeView = [[ComposeView alloc]initWithFrame:composeViewFrame];
		composeView.composeViewController = self;
		composeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth
		| UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin
		| UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
	}
	[self.view insertSubview:composeView atIndex:1];
	
	//alertBackgroundView.image = [UIImage imageNamed:@"alertView-bg.png"];
}

- (void)viewWillAppear:(BOOL)animated {
	[composeView checkTextView];
	composeView.canResponseEmotion = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	composeView.canResponseEmotion = NO;
	[super viewWillDisappear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
}


- (void)postNewStatus:(Draft *)draft
{
	WeiboClient *client = [[WeiboClient alloc] initWithTarget:self 
													   action:@selector(tweetDidSucceed:obj:)];
	client.context = [draft retain];
	draft.draftStatus = DraftStatusSending;
	draft.clientCount++;
	if (draft.attachmentImage) {
		[client upload:draft.attachmentData status:draft.text latitude:draft.latitude longitude:draft.longitude];
	}
	else {
		[client post:draft.text latitude:draft.latitude longitude:draft.longitude];
	}
}

- (void)retweetOrComment:(Draft *)draft {
	if (draft.retweet) {
		WeiboClient *retweetClient = [[WeiboClient alloc] initWithTarget:self 
														   action:@selector(retweetDidSucceed:obj:)];
		retweetClient.context = [draft retain];
		if (draft.draftType == DraftTypeReplyComment 
			&& draft.replyToComment
			&& draft.text.length < 140 - draft.replyToStatus.user.screenName.length - 4) {
			draft.text = [NSString stringWithFormat:@"%@ //@%@:%@", draft.text, draft.replyToStatus.user.screenName, draft.replyToStatus.text];
			if (draft.text.length > 140) {
				draft.text = [draft.text substringToIndex:140];
			}
		}
		draft.draftStatus = DraftStatusSending;
		draft.clientCount++;
		[retweetClient repost:draft.replyToStatus.statusId tweet:draft.text isComment:draft.comment];		
	}
	else if (draft.comment) {
		WeiboClient *commentClient = [[WeiboClient alloc] initWithTarget:self 
																  action:@selector(commentDidSucceed:obj:)];
		commentClient.context = [draft retain];
		draft.draftStatus = DraftStatusSending;
		draft.clientCount++;
		long long commentId = draft.replyToComment ? draft.replyToComment.commentId : -1;
		[commentClient comment:draft.replyToStatus.statusId 
					 commentId:commentId
					   comment:draft.text];		
	}
	if (draft.replyToStatus.retweetedStatus 
		&& draft.commentToOriginalStatus) { // 同时原文评论
		WeiboClient *commentToOriginalClient = [[WeiboClient alloc] initWithTarget:self 
																			action:@selector(commentToOriginalDidSucceed:obj:)];
		commentToOriginalClient.context = [draft retain];
		draft.draftStatus = DraftStatusSending;
		draft.clientCount++;
		[commentToOriginalClient comment:draft.replyToStatus.retweetedStatus.statusId 
							   commentId:-1 
								 comment:[NSString stringWithFormat:@"%@.", draft.text]];
	}
	//save draft;
	//[draft updateDB];
	[draft save];
}

- (void)draftPostCompleted:(Draft *)sentDraft {
	if (sentDraft.clientCount == 0) {
		if (sentDraft.failedClientCount > 0) {
			//save draft;
			[sentDraft save];
			NSLog(@"%@", @"save draft");
		}
		else {
			//delete draft;
			[sentDraft delete];
			NSLog(@"%@", @"delete draft");
		}
		[[sentDraft retain] autorelease];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"draftPostCompleted" 
															object:sentDraft];
	}	
}

- (void)commentDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	Draft *sentDraft = (Draft *)sender.context;
	
	sentDraft.clientCount--;   
    if (sender.hasError) {
        [sender alert];
		sentDraft.draftStatus = DraftStatusSentFailt;
		sentDraft.failedClientCount++;
		[self draftPostCompleted:sentDraft];
		[sender release];
		[sentDraft release];
        return;
    }
	sentDraft.comment = NO;
    NSDictionary *dic = nil;
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)obj;    
    }
	
    if (dic) {
        Comment* comment = [Comment commentWithJsonDictionary:dic];
		NSLog(@"comment id:%lld", comment.commentId);
		if (comment && comment.commentId > 0) {
			//delete draft!
			if (sentDraft) {
				//[sentDraft deleteFromDB];
				[sentDraft delete];
			}
		}
    }
	[self draftPostCompleted:sentDraft];	
	[sender release];
	[sentDraft release];
}


- (void)tweetDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	Draft *sentDraft = (Draft *)sender.context;
	
    sentDraft.clientCount--;
    if (sender.hasError) {
        [sender alert];
		sentDraft.draftStatus = DraftStatusSentFailt;
		sentDraft.failedClientCount++;
 		[self draftPostCompleted:sentDraft];
		[sender release];
		[sentDraft release];
      return;
    }
	
    NSDictionary *dic = nil;
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)obj;    
    }
	
    if (dic) {
        Status* sts = [Status statusWithJsonDictionary:dic];
		NSLog(@"sts id:%lld", sts.statusId);
		if (sts && sts.statusId > 0) {
			//delete draft!
			if (sentDraft) {
				//[sentDraft deleteFromDB];
				[sentDraft delete];
			}
			[[ZhiWeiboAppDelegate getAppDelegate]refresh];
		}
    }
	[self draftPostCompleted:sentDraft];
	[sender release];
	[sentDraft release];
}

- (void)retweetDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	Draft *sentDraft = (Draft *)sender.context;
	if (!sender.hasError) {
		sentDraft.retweet = NO;
	}
	[self tweetDidSucceed:sender obj:obj];
}


- (void)commentToOriginalDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	Draft *sentDraft = (Draft *)sender.context;
	if (!sender.hasError) {
		sentDraft.commentToOriginalStatus = NO;
	}
	[self commentDidSucceed:sender obj:obj];
}

- (void)close {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)closeButtonTouch:(id)sender {
	[composeView close];
    [self close];
}

- (IBAction)sendButtonTouch:(id)sender {
	Draft *draft = [composeView getDraft];
	if (!draft || draft.text.length == 0) {
		return;
	}
	if (draft.draftType == DraftTypeNewTweet) {
		[self postNewStatus:draft];
	}
	else {
		[self retweetOrComment:draft];
	}
	[composeView clear];
	[composeView close];
	[self close];
	//[FriendCache storeToLocal];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[composeView release];
    [super dealloc];
}

- (void)composeNewTweet {	
	Draft *_draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
	titleItem.title = @"新微博";
	composeView.draft = _draft;
	[_draft release];
	[_draft save];
}

- (void)replyTweet:(Status *)status comment:(Comment *)comment {
	Draft *_draft = [[Draft alloc]initWithType:DraftTypeReplyComment];
	_draft.replyToStatus = status;
	_draft.replyToComment = comment;
	_draft.comment = YES;
	titleItem.title = @"发评论";
	composeView.draft = _draft;
	[_draft release];	
	[_draft save];
}

- (void)retweet:(Status*)status {
	Draft *_draft = [[Draft alloc]initWithType:DraftTypeReTweet];
	_draft.replyToStatus = status;
	_draft.retweet = YES;
	titleItem.title = @"转发微博";
	composeView.draft = _draft;
	[_draft release];
	[_draft save];
}

- (void)advise {
	Draft *_draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
	_draft.text = [NSString stringWithFormat:@"#智微博意见反馈# @智微博 #OS Version:%@# ",[UIDevice currentDevice].systemVersion];
	titleItem.title = @"意见反馈";
	[composeView loadDraft:_draft];
	[_draft release];
	[_draft save];
}

- (void)enableSendButton:(BOOL)enabled {
	sendButton.enabled = enabled;
}

- (void)beginCompress {
	maskView.hidden = NO;
}

- (void)endCompress {
	maskView.hidden = YES;
}

- (UIImage *)fixImageOrientation:(UIImage *)img {
    CGSize size = [img size];
	
    UIImageOrientation imageOrientation = [img imageOrientation];
	
    if (imageOrientation == UIImageOrientationUp)
        return img;
	
    CGImageRef imageRef = [img CGImage];
    CGContextRef bitmap = CGBitmapContextCreate(
												NULL,
												size.width,
												size.height,
												CGImageGetBitsPerComponent(imageRef),
												4 * size.width,
												CGImageGetColorSpace(imageRef),
												CGImageGetBitmapInfo(imageRef));
	
    CGContextTranslateCTM(bitmap, size.width, size.height);
	
    switch (imageOrientation) {
        case UIImageOrientationDown:
            // rotate 180 degees CCW
            CGContextRotateCTM(bitmap, radians(180.));
            break;
        case UIImageOrientationLeft:
            // rotate 90 degrees CW
            CGContextRotateCTM(bitmap, radians(-90.));
            break;
        case UIImageOrientationRight:
            // rotate 90 degrees5 CCW
            CGContextRotateCTM(bitmap, radians(90.));
            break;
        default:
            break;
    }
	
    CGContextDrawImage(bitmap, CGRectMake(0, 0, size.width, size.height), imageRef);
	
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    CGContextRelease(bitmap);
    UIImage *oimg = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
	
    return oimg;
}

- (UIImage *)resizeImage:(UIImage *)original toSize:(MediaResize)resize {
	CGSize smallSize, mediumSize, largeSize, originalSize;
	UIImageOrientation orientation = original.imageOrientation; 
 	switch (orientation) { 
		case UIImageOrientationUp: 
		case UIImageOrientationUpMirrored:
		case UIImageOrientationDown: 
		case UIImageOrientationDownMirrored:
			smallSize = CGSizeMake(480, 320);
			mediumSize = CGSizeMake(960, 640);
			largeSize = CGSizeMake(1600, 1066);
			if([[UIDevice currentDevice] platformString] == IPHONE_4G_NAMESTRING)
				originalSize = CGSizeMake(2592, 1936);
			else if([[UIDevice currentDevice] platformString] == IPHONE_3GS_NAMESTRING)
				originalSize = CGSizeMake(2048, 1536);
			else
				originalSize = CGSizeMake(1600, 1200);
			break;
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			smallSize = CGSizeMake(320, 480);
			mediumSize = CGSizeMake(640, 960);
			largeSize = CGSizeMake(1066, 1600);
			if([[UIDevice currentDevice] platformString] == IPHONE_4G_NAMESTRING)
				originalSize = CGSizeMake(1936, 2592);
			else if([[UIDevice currentDevice] platformString] == IPHONE_3GS_NAMESTRING)
				originalSize = CGSizeMake(1536, 2048);
			else
				originalSize = CGSizeMake(1200, 1600);
	}
	
	// Resize the image using the selected dimensions
	UIImage *resizedImage = original;
	switch (resize) {
		case kResizeSmall:
			resizedImage = [original resizedImageWithContentMode:UIViewContentModeScaleAspectFill 
														  bounds:smallSize 
											interpolationQuality:kCGInterpolationHigh];
			break;
		case kResizeMedium:
			resizedImage = [original resizedImageWithContentMode:UIViewContentModeScaleAspectFill 
														  bounds:mediumSize 
											interpolationQuality:kCGInterpolationHigh];
			break;
		case kResizeLarge:
			resizedImage = [original resizedImageWithContentMode:UIViewContentModeScaleAspectFill 
														  bounds:largeSize 
											interpolationQuality:kCGInterpolationHigh];
			break;
		case kResizeOriginal:
			resizedImage = [original resizedImageWithContentMode:UIViewContentModeScaleAspectFill 
														  bounds:originalSize 
											interpolationQuality:kCGInterpolationHigh];
			break;
	}
	return resizedImage;
}


- (void)showImagePicker:(BOOL)hasCamera
{
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    //picker.composeView = self;
    picker.delegate = self;
    if (hasCamera) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentModalViewController:picker animated:YES];
}


- (void)showUserNamesSearchViewController {
	[self presentModalViewController:userNamesSearchViewController animated:YES];
}

- (void)showTrendSearchViewController {
	[self presentModalViewController:trendSearchViewController animated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // do nothing here
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	[self performSelectorInBackground:@selector(compressImageInBackground:) 
						   withObject:image];
	
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
	
    [self dismissModalViewControllerAnimated:true];
	[self beginCompress];
}


- (void) compressImageInBackground:(UIImage *)image {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	int size = kResizeMedium;
	
	NetworkStatus connectionStatus = [[Reachability2 sharedReachability] internetConnectionStatus];
	if (connectionStatus == ReachableViaWiFiNetwork) { //WIFI 大图
		size = kResizeLarge;
	}	else {
		size = kResizeMedium;
	}
	 

	UIImage *postImage = [self resizeImage:image toSize:size];
	/*
	CGFloat maxSize = 768;
	if ((maxSize < image.size.width || maxSize < image.size.height) ||
		image.imageOrientation != UIImageOrientationUp)
		postImage = [image imageScaledToSizeWithSameAspectRatio:CGSizeMake(maxSize, maxSize)];
	else {
		postImage = image;
	}
	 */
	
	[composeView setAttachmentImage:postImage];
    [self performSelectorOnMainThread:@selector(completeCompressingTask) withObject:nil waitUntilDone:YES];
    [pool release];
}

- (void) completeCompressingTask {
	[self endCompress];
    [composeView performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.1];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:true];
}

- (void)loadDraft:(Draft *)_draft {
	if(!_draft) return;
	switch (_draft.draftType) {
		case DraftTypeNewTweet:
			titleItem.title = @"新微博";
			break;
		case DraftTypeReTweet:
			titleItem.title = @"转发微博";
			break;
		case DraftTypeReplyComment:
			titleItem.title = @"发评论";
			break;
		default:
			break;
	}
	[composeView loadDraft:_draft];
}

- (void)addTrend:(NSString *)trend {
	[composeView addTrend:trend];
}

- (void)addUserScreenName:(NSString *)userScreenName {
	[composeView addUserScreenName:userScreenName];
}

@end
