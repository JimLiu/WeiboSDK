//
//  CommentViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CommentViewController.h"
#import "EmoticonDataSource.h"
#import "RegexKitLite.h"
#import "Photo.h"
#import "TrendsTimelineController.h"
#import "TweetViewController.h"
#import "RepostTimelineController.h"


@implementation CommentViewController
@synthesize userView, toolbar;
@synthesize comment, webViewController, photoViewController;
@synthesize mapViewController;
@synthesize replyButton, retweetButton, favoriteButton, actionButton;

- (void)initWebView {
	[webView release];
	webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 80, 320, 292)];
	webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	webView.delegate = self;
	//webView.detectsPhoneNumbers = NO;
	webView.dataDetectorTypes = UIDataDetectorTypeNone;
	[self.view addSubview:webView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.hidesBottomBarWhenPushed = YES;
		self.title = @"评论";
		//userTabBarController = [[UserTabBarController alloc] initWithoutNib];
		actionButtonActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
													 cancelButtonTitle:@"取消" destructiveButtonTitle:nil
													 otherButtonTitles:@"复制微博内容", @"在浏览器中打开",@"短消息发送",@"邮件发送", nil];
	}
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		self.hidesBottomBarWhenPushed = YES;
		self.title = @"评论";
		//userTabBarController = [[UserTabBarController alloc] initWithoutNib];
		actionButtonActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
													 cancelButtonTitle:@"取消" destructiveButtonTitle:nil
													 otherButtonTitles:@"复制微博内容", @"在浏览器中打开",@"短消息发送",@"邮件发送", nil];
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self initWebView];
	webView.backgroundColor = [UIColor whiteColor];
	webView.opaque = NO;
	UIView *contentView = [self getDocumentView];
	CGRect frame = contentView.frame;
	frame.origin.y = -100;
	contentView.frame = frame;	
	[userView addTarget:self
				 action:@selector(userViewTouch:)
	   forControlEvents:UIControlEventTouchUpInside];
	[self loadHtml];
}

- (void)setToolbarHidden:(BOOL)_bool {
	if (_bool != toolbar.hidden) {
		if (_bool == YES) {
			toolbar.hidden = YES;
			CGRect rect = webView.frame;
			rect.size.height += 44;
			webView.frame = rect;
		}
		else {
			toolbar.hidden = NO;
			CGRect rect = webView.frame;
			rect.size.height -= 44;
			webView.frame = rect;
		}
	}
}

- (void)viewWillAppear:(BOOL)animated {
	userView.user = comment.user;
	[self setToolbarHidden:([WeiboEngine getCurrentUser] == nil)];
	[super viewWillAppear:animated];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration {
	
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
	
	CGRect toolbarFrame = toolbar.frame;
	CGRect webViewFrame = webView.frame;
	toolbarFrame.origin.y += toolbarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
	webViewFrame.size.height += toolbarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
	toolbarFrame.size.height = self.navigationController.navigationBar.frame.size.height;
	toolbar.frame = toolbarFrame;
	webView.frame = webViewFrame;
	
	
	[userView setNeedsDisplay];
}

- (void)userViewTouch:(id)sender {
	UserTabBarController *userTabBarController = [[[UserTabBarController alloc] initWithoutNib] autorelease]; 
	[userTabBarController loadUser:comment.user];
	[self.navigationController pushViewController:userTabBarController animated:YES];
}

- (NSString *) decodeString:(NSString *)string {
	NSString * spacedDecoded = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	return [spacedDecoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}

- (NSMutableString *)parseEmoticonNodes:(NSMutableString *)_html
								   text:(NSString *)string {
	NSMutableArray *emoticons = [EmoticonDataSource emoticons];
	if (emoticons.count == 0) {
		[_html appendString:string];
		return _html;
	}
	static NSMutableString * emoticonRex;
	if (!emoticonRex) {
		emoticonRex = [[NSMutableString stringWithString:@""] retain];
		for (int i=0; i<emoticons.count; i++) {
			Emoticon *emoticon = [emoticons objectAtIndex:i];
			[emoticonRex appendString:[[emoticon.phrase stringByReplacingOccurrencesOfString:@"[" withString:@"\\["] stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"]];
			if (i < emoticons.count - 1) {
				[emoticonRex appendString:@"|"];
			}
		}
	}
	
	
	NSInteger stringIndex = 0;
	
	while (stringIndex < string.length) {
		NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
		NSRange startRang = [string rangeOfRegex:emoticonRex
										 inRange:searchRange];
		
		if (startRang.location != NSNotFound) {
			NSRange beforeRange = NSMakeRange(searchRange.location,
											  startRang.location - searchRange.location);
			if (beforeRange.length) {
				[_html appendString:[string substringWithRange:beforeRange]];
			}
			
			NSString *phrase = [string substringWithRange:startRang];
			for (Emoticon *emo in emoticons) {
				if ([phrase isEqualToString:emo.phrase]) {
					[_html appendFormat:@"<img src=\"%@\" alt=\"%@\" width=\"%d\" height=\"%d\" />"
					 , emo.gifUrl, emo.phrase, emo.width, emo.height];
					break;
				}
			}
			
			stringIndex = startRang.location + startRang.length;
		}
		else {
			[_html appendString:[string substringWithRange:searchRange]];
			break;
		}
	}
	
	return _html;
}

- (NSString *)parseStatus:(NSString *)string {
	NSMutableString *_html = [NSMutableString string];
	
	NSInteger stringIndex = 0;
	
	while (stringIndex < string.length) {
		NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
		NSRange startRang = [string rangeOfRegex:@"[a-zA-Z0-9%_.+\\-]+@[a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6}|@[a-zA-Z0-9_\\u4e00-\\u9fa5]+|#[^#]+#|https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"
										 inRange:searchRange];
		
		if (startRang.location != NSNotFound) {
			NSRange beforeRange = NSMakeRange(searchRange.location,
											  startRang.location - searchRange.location);
			if (beforeRange.length) {
				[self parseEmoticonNodes:_html text:[string substringWithRange:beforeRange]];
			}
			NSString *url = [string substringWithRange:startRang];
			NSString *text = [NSString stringWithString:url];
			if (![url isMatchedByRegex:@"https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"]) {
				url = [NSString stringWithFormat:@"zhiweibo://%@", [self encodeString:text]];
			}			
			[_html appendFormat:@"<a href=\"%@\">%@</a>", url, text];			
			stringIndex = startRang.location + startRang.length;
		}
		else {
			[self parseEmoticonNodes:_html text:[string substringWithRange:searchRange]];
			break;
		}
	}
	
	return _html;
}


- (void)appendPhotoHtml:(NSMutableString *)html 
			   photoUrl:(NSString *)photoUrl 
				 status:(Status*)_status{
	if ((photoUrl && photoUrl.length > 0) || (_status.latitude > 0 && _status.longitude > 0)) {
		[html appendString:@"<div id=\"thumbnailSection\">"];
		BOOL hasImage;
		if (photoUrl && photoUrl.length > 0) {
			ImageCache *imageCache = [ImageCache cacheWithName:@"tweetImages"];
			if ([imageCache hasImageForURL:photoUrl]) {
				photoUrl = [imageCache cachePathForURL:photoUrl];
			}
			[html appendFormat:@"<a href=\"zhiweibo://photo\"><img src=\"%@\" /></a>", photoUrl];
			hasImage = YES;
		}
		if (_status.latitude != 0 && _status.longitude != 0) {
			if (hasImage) {
				[html appendString:@"<br />"];
			}
			[html appendString:@"<a href=\"\" class=\"noCallout static-map\" style=\"width:290px;\" >&nbsp;</a>"];
		}
		[html appendString:@"</div>"];
	}	
}

- (NSMutableString *)generateTweetHtml {
	NSMutableString *html = [NSMutableString string];
	[html appendString:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"];
	[html appendString:@"<html>"];
	[html appendString:@"<head>"];
	[html appendString:@"<meta http-equiv=\"Content-type\" content=\"text/html; charset=UTF-8\" />"];
	[html appendString:@"<title>Tweet Detail</title>"];
	[html appendString:@"<meta name=\"viewport\" content=\"width=device-width; minimum-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>"];
	[html appendString:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"tweet_details.css\" media=\"screen\" />"];
	[html appendString:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"tweet_details_retina.css\" media=\"only screen and (-webkit-min-device-pixel-ratio: 2)\">"];
	[html appendString:@"<script type=\"text/javascript\" src=\"jquery.js\"></script>"];
	[html appendString:@"<script type=\"text/javascript\" src=\"tweet_details.js\"></script>"];
	[html appendString:@"<script type=\"text/javascript\">"];
	[html appendString:@"$(document).ready(function(){ "];
	double latitude = comment.status.retweetedStatus ? comment.status.retweetedStatus.latitude : comment.status.latitude;
	double longitude = comment.status.retweetedStatus ? comment.status.retweetedStatus.longitude : comment.status.latitude;
	if (latitude > 0 && longitude > 0) {
		int width = comment.status.retweetedStatus ? 270 : 290;
		[html appendFormat:@"loadCoordinateMap(%f, %f, %d, 100);", latitude, longitude, width];
	}
	[html appendString:@"});"];
	[html appendString:@"</script>"];
	[html appendString:@"</head>"];
	[html appendString:@"<body bgColor=\"white\">"];
	[html appendString:@"<div class=\"content\">"];
	[html appendString:@"<div id=\"headerSpace\"></div>"];
	[html appendString:@"<div id=\"tweet\">"];
	[html appendString:[self parseStatus:comment.text]];
	[html appendString:@"</div>"];
	NSString *photoUrl = comment.status.thumbnailPic;
	if (comment.status) {
		[html appendString:@"<div id=\"retweet\" class=\"top\">"];
		[html appendString:@"<div id=\"retweetContent\">"];
		[html appendFormat:@"<a href=\"zhiweibo://%@\"><span class=\"retweetAuthorProfileImage\" style=\"background-image:url(%@);\">&nbsp;</span>%@</a>: "
		 , [self encodeString:[NSString stringWithFormat:@"@%@", comment.status.user.screenName]]
		 , [comment.status.user.profileImageUrl stringByReplacingOccurrencesOfString:@"/50/" withString:@"/30/"]
		 , comment.status.user.screenName];
		[html appendString:[self parseStatus:comment.status.text]];
		[html appendString:@"</div>"];
		photoUrl = comment.status.thumbnailPic;
		[self appendPhotoHtml:html photoUrl:photoUrl status:comment.status.retweetedStatus];
		[html appendString:@"<div class=\"footer\">"];
		[html appendFormat:@"<a href=\"%@\">%@</a> <strong>&middot;</strong> %@", comment.status.sourceUrl, comment.status.source, comment.status.timeString];
		[html appendString:@"<div class=\"replyChain\">"];
		[html appendFormat:@"<a href=\"zhiweibo://retweetForwards\">&nbsp;&nbsp;<img src=\"miniretweet@2x.png\" /> 原文转发<span id=\"retweetForwardsCount\">%@</span>&nbsp;&nbsp;</a>",
		 comment.status.retweetsCount > 0 ? [NSString stringWithFormat:@"(%d)", comment.status.retweetsCount] : @""];
		[html appendString:@"&nbsp;&nbsp;"];
		[html appendFormat:@"<a href=\"zhiweibo://retweetComments\">&nbsp;&nbsp;<img src=\"mini-reply@2x.png\" /> 原文评论<span id=\"retweetCommentsCount\">%@</span>&nbsp;&nbsp;</a>",
		 comment.status.commentsCount > 0 ? [NSString stringWithFormat:@"(%d)", comment.status.commentsCount] : @""];
		[html appendString:@"<br><br>"];
		[html appendFormat:@"<a href=\"zhiweibo://retweet\">&nbsp;&nbsp;<img src=\"miniretweet@2x.png\" /> 查看原文</a>"];
		[html appendString:@"</div>"];		
		[html appendString:@"</div>"];
		[html appendString:@"</div>"];
	}
	
	[html appendString:@"<div id=\"footer\" class=\"footer\">"];
	[html appendFormat:@"<a href=\"%@\">%@</a> <strong>&middot;</strong> %@", comment.sourceUrl, comment.source, comment.timeString];
	[html appendString:@"</div>"];
	[html appendString:@"<div class=\"replyChain\">"];
	//[html appendFormat:@"<a href=\"zhiweibo://forwards\">&nbsp;&nbsp;<img src=\"miniretweet@2x.png\" /> 转发<span id=\"forwardsCount\">%@</span>&nbsp;&nbsp;</a>",
	// [comment.status retweetsCountText]];
	[html appendString:@"&nbsp;&nbsp;"];
	//[html appendFormat:@"<a href=\"zhiweibo://comments\">&nbsp;&nbsp;<img src=\"mini-reply@2x.png\" /> 评论<span id=\"commentsCount\">%@</span>&nbsp;&nbsp;</a>",
	// [comment.status commentsCountText]];
	[html appendString:@"</div>"];	
	[html appendString:@"<div id=\"footerSpace\"></div>"];
	[html appendString:@"</div>"];
	[html appendString:@"</body>"];
	[html appendString:@"</html>"];
	//NSLog(@"HTML:%@", html);
	return html;
}

- (void)loadHtml {
	//webView.hidden = YES;
	NSString *html = [self generateTweetHtml];
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	[webView loadHTMLString:html baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[webView release];
	//[userTabBarController release];
	//userTabBarController = nil;
	loadCommentCountsClient.delegate = nil;
	[loadCommentCountsClient release];
	loadCommentCountsClient = nil;
	[comment release];
	[actionButtonActionSheet release];
    [super dealloc];
}

- (void)setComment:(Comment *)_comment {
	if (comment != _comment) {
		[comment release];
		comment = [_comment retain];
		userView.user = comment.user;
		
		[self loadHtml];
		[self loadCommentsCount];
	}
}


- (void)loadCommentsCount {
	if (!comment) {
		return;
	}
	[loadCommentCountsClient release];
	loadCommentCountsClient = nil;
	loadCommentCountsClient = [[WeiboClient alloc] initWithTarget:self
														   action:@selector(commentsCountDidReceive:obj:)];
	NSMutableArray *statusIds = [NSMutableArray array];
	[statusIds addObject:[NSNumber numberWithLongLong:comment.status.statusId]];
	[loadCommentCountsClient getCommentCounts:statusIds];
}


- (void)commentsCountDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
	
    if (sender.hasError) {
		NSLog(@"commentsCountDidReceive error!!!, errorMessage:%@, errordetail:%@"
			  , sender.errorMessage, sender.errorDetail);
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
		[loadCommentCountsClient release];
		loadCommentCountsClient = nil;
        return;
    }
	NSArray *ary = (NSArray*)obj;   
	for (int i = [ary count] - 1; i >= 0; --i) {
		NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
		if (![dic isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		long long statusId = [dic getLongLongValueValueForKey:@"id" defaultValue:-1];
		int comments = [dic getIntValueForKey:@"comments" defaultValue:-1];
		int rt = [dic getIntValueForKey:@"rt" defaultValue:-1];
		if (statusId > 0 && (comments >= 0 || rt >= 0)) {
			if (comment.status.statusId == statusId) {
				comment.status.commentsCount = comments;
				comment.status.retweetsCount = rt;
			}
			else if (comment.status.retweetedStatus && comment.status.retweetedStatus.statusId == statusId) {
				comment.status.retweetedStatus.commentsCount = comments;
				comment.status.retweetedStatus.retweetsCount = rt;
			}
			NSMutableString *script = [NSMutableString string];
			[script appendFormat:@"document.getElementById('commentsCount').innerText='%@';document.getElementById('forwardsCount').innerText='%@';"
			 , [comment.status commentsCountText], [comment.status retweetsCountText]];
			if (comment.status.retweetedStatus) {
				[script appendFormat:@"document.getElementById('retweetCommentsCount').innerText='%@';document.getElementById('retweetForwardsCount').innerText='%@';"
				 , [comment.status.retweetedStatus commentsCountText], [comment.status.retweetedStatus retweetsCountText]];
			}
			//NSLog(script);
			[webView stringByEvaluatingJavaScriptFromString:script];
		}
		
	}
	[loadCommentCountsClient release];
    loadCommentCountsClient = nil;
	[self loadHtml];
}


- (UIView*)descendantOrSelfWithClass:(UIView *)v viewClass:(Class)cls {
	if ([v isKindOfClass:cls])
		return v;
	
	for (UIView* child in v.subviews) {
		UIView* it = [self descendantOrSelfWithClass:child viewClass:cls];
		if (it)
			return it;
	}
	
	return nil;
}

- (UIView *)getDocumentView {
	UIView* docView;
	UIView* scroller = [self descendantOrSelfWithClass:webView viewClass:NSClassFromString(@"UIScroller")];
	
	if (scroller == nil) {
		UIScrollView *scrollView = (UIScrollView *)[self descendantOrSelfWithClass:webView viewClass:NSClassFromString(@"UIScrollView")];
		docView = [self descendantOrSelfWithClass:scrollView viewClass:NSClassFromString(@"UIWebDocumentView")];
	}
	else {
		docView = [self descendantOrSelfWithClass:scroller viewClass:NSClassFromString(@"UIWebDocumentView")];
	}	
	return docView;
}


- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    //_webView.hidden = NO;         
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeOther)
		return YES;
	NSString *href = [[request URL] absoluteString];
	if ([href isMatchedByRegex:@"https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"]) {
		[self.navigationController pushViewController:webViewController animated:YES];
		NSURL *url = [NSURL URLWithString:href];
		[webViewController loadUrl:url];
	}
	else if ([href hasPrefix:@"zhiweibo://"]){
		NSString *command = [self decodeString:[href substringFromIndex:11] ];
		if ([command isEqualToString:@"comments"]) {
			commentsController = [[[TweetCommentsController alloc] init] autorelease];
			commentsController.status = comment.status;
			commentsController.title = @"评论列表";
			[self.navigationController pushViewController:commentsController animated:TRUE];
		}
		else if ([command isEqualToString:@"retweetForwards"]) {
			RepostTimelineController *repostTimelineController = [[[RepostTimelineController alloc] initWithNibName:@"TimelineController" bundle:nil] autorelease];
			[repostTimelineController setStatus:comment.status];
			repostTimelineController.title = @"原文转发列表";
			[self.navigationController pushViewController:repostTimelineController animated:TRUE];
		}
		else if ([command isEqualToString:@"retweetComments"]) {
			commentsController = [[[TweetCommentsController alloc] init] autorelease];
			commentsController.status = comment.status;
			commentsController.title = @"原文评论列表";
			[self.navigationController pushViewController:commentsController animated:TRUE];
		}
		else if ([command isEqualToString:@"retweet"]) {
			if (comment.status) {
				TweetViewController *tweet = [[[TweetViewController alloc] init] autorelease];
				tweet.status = comment.status;
				[self.navigationController pushViewController:tweet animated:TRUE];
			}
		}
		else if ([command isEqualToString:@"photo"]) {
			//NSString *photoUrl = status.retweetedStatus ? status.retweetedStatus.originalPic : status.originalPic;
			Photo *p = [Photo photoWithStatus:comment.status];
			//p.URL = photoUrl;
			[self.navigationController pushViewController:photoViewController animated:YES];
			[photoViewController showImage:p];
		}
		else if ([command hasPrefix:@"map:"]) {
			[self.navigationController pushViewController:mapViewController animated:YES];
			[mapViewController showStatus:comment.status];
		}
		else if ([command hasPrefix:@"@"]) {
			UserTabBarController *userTabBarController = [[[UserTabBarController alloc] initWithoutNib] autorelease]; 
			[userTabBarController loadUserByScreenName:[command substringFromIndex:1]];
			[self.navigationController pushViewController:userTabBarController animated:YES];
		}
		else if ([command isMatchedByRegex:@"#[^#]+#"]) {
			NSString *trend = [command substringWithRange:NSMakeRange(1, command.length - 2)];
			TrendsTimelineController *c = [[[TrendsTimelineController alloc] initWithTrendsName:trend] autorelease];
			c.title = trend;
			[self.navigationController pushViewController:c animated:YES];
		}
		
	}
	return NO;
}

- (IBAction)didReplyButtonTouch:(id)sender {
	[[ZhiWeiboAppDelegate getAppDelegate] replyTweet:comment.status comment:comment];
}

- (IBAction)didRetweetButtonTouch:(id)sender{
	
}

- (IBAction)didActionButtonTouch:(id)sender {
	if (![actionButtonActionSheet isVisible]) {
		[actionButtonActionSheet showInView:self.view];
	}
}

- (void)didFavoriteButtonTouch:(id)sender {
	
}

#pragma mark -
#pragma mark ActionSheet

- (NSString *)getTweetText {
	NSMutableString *body = [NSMutableString stringWithFormat:@"%@\n",comment.text];
	if (comment.status) {
		[body appendFormat:@"微博原文:%@\n",comment.status.text];
		if (comment.status.thumbnailPic.length > 0) {
			[body appendFormat:@"图片地址:%@\n",comment.status.thumbnailPic];
		}
	}
	[body appendFormat:@"via 智微博"];
	return body;
}

- (void)copyText:(NSString *)text {
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	pasteBoard.string = [self getTweetText];
}

- (void)copyUrl:(NSString *)url {
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	pasteBoard.URL = [NSURL URLWithString:url];
}

-(void) openTweetInSafari {
	NSString *url = [NSString stringWithFormat:@"http://api.t.sina.com.cn/%d/statuses/%lld", comment.status.user.userId, comment.status.statusId];
	/*
	 if([[UIApplication sharedApplication] canOpenURL:url])
	 [[UIApplication sharedApplication] openURL:url];
	 */
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController loadUrl:[NSURL URLWithString:url]];
}

- (void)openSMSViewController {
	Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (smsClass != nil && [MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
		if([MFMessageComposeViewController canSendText])
		{
			controller.body = [self getTweetText];
			controller.messageComposeDelegate = self;
			[self presentModalViewController:controller animated:YES];
		}
	}
}

- (void)openMailViewController {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil && [mailClass canSendMail]) {
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		[picker setSubject:[NSString stringWithFormat:@"%@的评论",comment.user.screenName]];
		
		NSString *emailBody = [self getTweetText];
		[picker setMessageBody:emailBody isHTML:NO];
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0:
			[self copyText:comment.text];
			break;
		case 1:
			[self openTweetInSafari];
			break;
		case 2:
			[self openSMSViewController];
			break;
		case 3:
			[self openMailViewController];
			break;
		default:
			break;
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	switch (result) {
		case MessageComposeResultCancelled:
			[[ZhiWeiboAppDelegate getAppDelegate] alert:@"失败" message:@"发送取消"];
			break;
		case MessageComposeResultFailed:
			[[ZhiWeiboAppDelegate getAppDelegate] alert:@"失败" message:@"发送失败"];
			break;
		case MessageComposeResultSent:
			[[ZhiWeiboAppDelegate getAppDelegate] alert:@"成功" message:@"发送成功"];
			break;
		default:
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			[[ZhiWeiboAppDelegate getAppDelegate] alert:@"成功" message:@"保存成功"];
			break;
		case MFMailComposeResultSent:
			[[ZhiWeiboAppDelegate getAppDelegate] alert:@"成功" message:@"发送成功"];
			break;
		case MFMailComposeResultFailed:
			[[ZhiWeiboAppDelegate getAppDelegate] alert:@"失败" message:@"发送失败"];
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
