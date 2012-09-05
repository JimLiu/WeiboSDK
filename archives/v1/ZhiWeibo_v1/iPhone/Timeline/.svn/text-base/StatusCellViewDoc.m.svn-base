//
//  StatusCellViewDoc.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-8.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "StatusCellViewDoc.h"

#define kMarginLeft 8
#define kMarginRight 12
#define kMarginTop 8
#define kMarginV 6
#define kPhotoWidth 60
#define kPhotoHeight 60
#define kPhotoMargin 4
#define kProfileImageSize 24
#define kRetweetMarginH 8
#define kRetweetMarginTop 16
#define kRetweetMarginBottom 8

static NSMutableDictionary *gTweetDocument = nil;
static UIFont *defaultTimestampFont;
static UIColor *defaultTimestampTextColor;
static UIFont *defaultAuthorFont;
static UIImage *defaultLocationImage;
static UIFont *defaultRepostSourceFont;
static UIColor *defaultRepostTextColor;
static UIFont *defaultRepostCommentsFont;
static UIFont *defaultRepostCommentsLinkFont;
static UIColor *defaultRepostCommentsTextColor;
static UIColor *defaultRepostCommentsLinkTextColor;
static UIFont *defaultSourceFont;
static UIColor *defaultSourceTextColor;
static UIFont *defaultCommentsFont;
static UIFont *defaultCommentsLinkFont;
static UIColor *defaultCommentsTextColor;
static UIColor *defaultCommentsLinkTextColor;

static UIImage *defaultAuthorVerifiedImageNode = nil;

static UIImage *retweetBackgroundImage = nil;
static UIImage *defaultTweetImage = nil;


@interface StatusCellViewDoc (Private)

- (void)initDoc;

@end

@implementation StatusCellViewDoc
@synthesize status, docWidth;

- (id)init {
	if (self = [super init]) {
		docWidth = 320;
		profileImageCellWidth = 72;
		[self initDoc];
	}
	return self;
}


+ (StatusCellViewDoc *)documentWithStatus:(Status *)status_ width:(CGFloat)_width {
	if (!gTweetDocument) {
		gTweetDocument = [[NSMutableDictionary alloc]init];
	}
	NSString *cacheKey = [NSString stringWithFormat:@"status-SI:%lld-W:%f", status_.statusId, _width];
	StatusCellViewDoc *doc = [gTweetDocument objectForKey:cacheKey];
	if (!doc) {
		doc = [[StatusCellViewDoc alloc] init];
		doc.docWidth = _width;
		doc.status = status_;
		[gTweetDocument setObject:doc forKey:cacheKey];
		[doc release];
	}
	[doc refresh];
	return doc;
}

- (NSString *)getImageUrl {
	NSString *imageUrl = nil;
	if (status.thumbnailPic && status.thumbnailPic.length > 0) {
		imageUrl = status.thumbnailPic;
	}
	else if (status.retweetedStatus && status.retweetedStatus.thumbnailPic && status.retweetedStatus.thumbnailPic.length > 0) {
		imageUrl = status.retweetedStatus.thumbnailPic;
	}
	return imageUrl;
}

- (void)initSizeWithWidth {
	
	if (docWidth <= 0) {
		return;
	}
	CGFloat y = kMarginTop;
	profileImageLayout.frame = CGRectMake(kMarginLeft, y, kProfileImageSize, kProfileImageSize);
	authorLayout.frame = CGRectMake(kMarginLeft * 2 + kProfileImageSize, y + 2, docWidth - kMarginLeft * 2 - kProfileImageSize - kMarginRight, 15);
	timestampLayout.frame = CGRectMake(0, y + 4, docWidth - kMarginRight, 12);
	
	y += kProfileImageSize + kMarginV;
	CGFloat textWidth = docWidth - kMarginLeft - kMarginRight + 4;
	NSString *photoUrl = status.retweetedStatus ? status.retweetedStatus.thumbnailPic : status.thumbnailPic;
	BOOL hasPhoto = photoUrl && photoUrl.length > 0;
	if (hasPhoto && !status.retweetedStatus) { // 非转发，有图
		textWidth = docWidth - kPhotoWidth - kPhotoMargin - kMarginLeft - kMarginRight + 4;
		imageLayout.frame = CGRectMake(docWidth - kPhotoWidth - kMarginRight, y, kPhotoWidth, kPhotoWidth);
	}
	statusLayout.frame = CGRectMake(kMarginLeft, y - 2, textWidth, 0);
	[statusLayout setNeedsLayout];
	
	CGFloat textHeight = statusLayout.frame.size.height;
	y = statusLayout.frame.origin.y + statusLayout.frame.size.height;
	if (status.retweetedStatus) {
		y += 0;
		CGFloat marginH = kMarginLeft + kMarginRight + kRetweetMarginH * 2;
		CGFloat marginV = kRetweetMarginTop + kRetweetMarginBottom;
		if (hasPhoto) {
			textWidth = docWidth - kPhotoWidth - kPhotoMargin * 2 - marginH + 4;
			imageLayout.frame = CGRectMake(docWidth - kPhotoWidth - kMarginRight - kRetweetMarginH, y + kRetweetMarginTop, kPhotoWidth, kPhotoHeight);
		}
		else {
			textWidth = docWidth - marginH + 4;
		}
		retweetLayout.frame = CGRectMake(kMarginLeft + kRetweetMarginH, y + kRetweetMarginTop, textWidth, 0);
		[retweetLayout setNeedsLayout];
		textHeight = retweetLayout.frame.size.height + 20;
		if (hasPhoto && textHeight < kPhotoHeight) { 
			textHeight = kPhotoHeight;
		}
		//repostSourceLayout.frame = CGRectMake(kMarginLeft + kRetweetMarginH, y + textHeight, docWidth - kMarginLeft - kMarginRight, 14);
		//retweetCommentsBounds = CGRectMake(kMarginLeft + kRetweetMarginH, y + kRetweetMarginTop + textHeight - 14, textWidth, 14);
		repostCommentsLayout.frame = CGRectMake(kMarginLeft + kRetweetMarginH, y + kRetweetMarginTop + textHeight - 14, textWidth, 14);
		retweetBackgroundImageNode.height = textHeight + marginV;
		retweetBackgroundLayout.frame = CGRectMake(kMarginLeft, y, docWidth - kMarginLeft - kMarginRight, textHeight + marginV);
		retweetBackgroundImageNode.width = retweetBackgroundLayout.frame.size.width;
		retweetBackgroundImageNode.imageWidth = retweetBackgroundImageNode.width;
		retweetBackgroundImageNode.imageHeight = retweetBackgroundImageNode.height;		
		[retweetBackgroundLayout setNeedsLayout];
		y += kRetweetMarginTop + textHeight + kRetweetMarginBottom;	
	}
	else {
		repostCommentsLayout.frame = CGRectZero;
		repostSourceLayout.frame = CGRectZero;
		retweetBackgroundLayout.frame = CGRectZero;
		retweetLayout.frame = CGRectZero;
		repostLayoutAuthor.frame = CGRectZero;
		if (hasPhoto && textHeight < kPhotoHeight) {
			textHeight = kPhotoHeight;
		}
		y = statusLayout.frame.origin.y + textHeight;
	}
	//sourceBounds = CGRectMake(kMarginLeft, y + kMarginV, width, 20);
	//commentsBounds = CGRectMake(width - 200 - kMarginRight, y + kMarginV, 200, 20);
	sourceLayout.frame = CGRectMake(kMarginLeft, y + kMarginV, statusLayout.frame.size.width, 14);
	commentsLayout.frame = CGRectMake(kMarginLeft, y + kMarginV, docWidth - kMarginLeft - kMarginRight, 14);
	if (!hasPhoto) {
		imageLayout.frame = CGRectZero;
	}	
	if (status.latitude != 0 && status.longitude != 0) {
		locationImageNode.defaultImage = defaultLocationImage;// .imageUrl = @"bundle://mini-pin-classic.png";
	}
	else {
		locationImageNode.defaultImage = nil;
	}

	[self setNeedsLayout];
}

- (void)initContentWithStatus {	
	profileImageNode.url = [NSString stringWithFormat:@"@%@", status.user.screenName];
	profileImageNode.imageUrl = status.user.profileImageUrl;
	authorNode.text = status.user.screenName;
	
	NSMutableArray *nodes = [self parseStatus:status.text layout:statusLayout];
	[statusLayout reset];
	for (TweetNode *node in nodes) {
		[statusLayout addNode:node];
	}
	if (status.user.verified) {
		authorVerifiedImageNode.defaultImage = defaultAuthorVerifiedImageNode;
	}
	else {
		authorVerifiedImageNode.defaultImage = nil;
	}
	
	if (status.retweetedStatus) {
		repostAuthorImageNode.imageUrl = status.retweetedStatus.user.profileImageUrl;
		repostAuthorLinkNode.url = [NSString stringWithFormat:@"@%@", status.retweetedStatus.user.screenName];
		repostAuthorLinkNode.text = status.retweetedStatus.user.screenName;
		repostSourceNode.text = [NSString stringWithFormat:@"来自 %@", status.retweetedStatus.source];
		
		NSMutableArray *retweetLayoutNodes = [self parseStatus:status.retweetedStatus.text layout:retweetLayout];
		[retweetLayout reset];
		[retweetLayout addNode:repostAuthorImageNode];
		[retweetLayout addNode:repostAuthorLinkNode];
		if (status.retweetedStatus.user.verified) {
			repostAuthorVerifiedImageNode = [retweetLayout addNodeForImageUrl:nil width:12 height:13];
			repostAuthorVerifiedImageNode.defaultImage = defaultAuthorVerifiedImageNode;
			repostAuthorVerifiedImageNode.margin = UIEdgeInsetsMake(3, 1, 0, 1); 
		}
		[retweetLayout addNodeForText:@": "];
		for (TweetNode *node in retweetLayoutNodes) {
			[retweetLayout addNode:node];
		}
		
	}
	
	NSString *imageUrl = [self getImageUrl];
	if (imageUrl && imageUrl.length > 0) {
		imageNode.imageUrl = imageUrl;
		imageNode.url = [NSString stringWithFormat:@"photo:%lld",status.statusId];
	}
	else {
		imageLayout.frame = CGRectZero;
	}
	timestampNode.text = status.timestamp;	
	sourceNode.text = [NSString stringWithFormat:@"来自 %@", status.source];
	[self refreshComments];
}

- (void)dealloc {
	
	profileImageLayout = nil;
	profileImageNode = nil;
	
	authorLayout = nil;
	authorNode = nil;
	
	statusLayout = nil;
	
	retweetBackgroundLayout = nil;
	retweetBackgroundImageNode = nil;
	
	repostLayoutAuthor = nil;
	repostImageNode = nil;
	
	[repostAuthorImageNode release];
	repostAuthorImageNode = nil;
	[repostAuthorLinkNode release];
	repostAuthorLinkNode = nil;
	
	retweetLayout = nil;
	
	[repostCommentsLinkNode release];
	[repostRetweetsLinkNode release];
	[commentsLinkNode release];
	[retweetsLinkNode release];
	
	imageLayout = nil;
	imageNode = nil;
	
	timestampLayout = nil;
	timestampNode = nil;
	
	[status release];
	[super dealloc];
}

- (void)initDoc {
	CGFloat y = kMarginTop;
	//-------------profileImage
	profileImageLayout = [[TweetLayout alloc] 
						  initWithFrame:CGRectMake(kMarginLeft, y, kProfileImageSize, kProfileImageSize)
						  doc:self];
	[self addLayout:profileImageLayout];
	[profileImageLayout release];
	
	profileImageNode = [profileImageLayout addNodeForImageLink:nil imageUrl:nil
														 width:kProfileImageSize height:kProfileImageSize];
	profileImageNode.cacheName = @"profileImages";
	profileImageNode.className = @"profileImageSmall";
	
	static UIImage *defaultProfileImage;
	if (!defaultProfileImage) {
		defaultProfileImage = [[[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"] resizeImageWithNewSize:CGSizeMake(24, 24)] retain];
	}
	profileImageNode.defaultImage = defaultProfileImage;
	
	
	//--------------timestamp
	if (!defaultTimestampFont) {
		defaultTimestampFont = [[UIFont boldSystemFontOfSize:12] retain];
	}
	if (!defaultTimestampTextColor) {
		defaultTimestampTextColor = [[UIColor colorWithRed:0x9F/255.0f green:0x9F/255.0f blue:0xA2/255.0f alpha:1] retain];
	}
	if (!defaultLocationImage) {
		defaultLocationImage = [[UIImage imageNamed:@"mini-pin-classic.png"]retain];
	}
	timestampLayout = [[TweetLayout alloc]initWithFrame:CGRectMake(0, y + 4, docWidth - kMarginRight, 12)
													doc:self];
	timestampLayout.font = defaultTimestampFont;
	timestampLayout.textColor = defaultTimestampTextColor;
	timestampLayout.horizontalAlign = LayoutHorizontalAlignRight;
	[self addLayout:timestampLayout];
	[timestampLayout release];
	locationImageNode = [timestampLayout addNodeForImageUrl:nil width:10 height:13];
	locationImageNode.margin = UIEdgeInsetsMake(0, 2, 0, 2); 
	timestampNode = [timestampLayout addNodeForText:nil];
	
	//-------------author
	authorLayout = [[TweetLayout alloc] initWithFrame:CGRectMake(kMarginLeft + 2 + kProfileImageSize, y + 2, docWidth - kMarginLeft * 2 - kProfileImageSize - kMarginRight, 15) doc:self];
	[self addLayout:authorLayout];
	[authorLayout release];
	if (!defaultAuthorFont) {
		defaultAuthorFont = [[UIFont boldSystemFontOfSize:15] retain];
	}
	if (!defaultAuthorVerifiedImageNode) {
		defaultAuthorVerifiedImageNode = [[UIImage imageNamed:@"verified.png"] retain];
	}
	authorLayout.font = defaultAuthorFont;
	authorNode = [authorLayout addNodeForText:nil];
	authorVerifiedImageNode = [authorLayout addNodeForImageUrl:nil width:12 height:13];
	authorVerifiedImageNode.margin = UIEdgeInsetsMake(4, 1, 0, 2);
	//authorVerifiedImageNode.verticalAlign = LayoutVerticalAlignBottom;
	
	//-------------status
	statusLayout = [[TweetLayout alloc] initWithFrame:CGRectMake(profileImageCellWidth, 32, docWidth - profileImageCellWidth - 14, 0) doc:self];
	//statusLayout.font = [UIFont systemFontOfSize:15];
	//statusLayout.linkFont = [UIFont boldSystemFontOfSize:15];
	//statusLayout.linkTextColor = [UIColor colorWithRed:0x23/255.0F green:0x6E/255.0F blue:0xD8/255.0F alpha:1];
	[self addLayout:statusLayout];
	[statusLayout release];
	
	//-------------retweet
	//-------------splitline
	CGRect splitLineFrame = CGRectMake(profileImageCellWidth, statusLayout.frame.origin.y + statusLayout.frame.size.height + 10
									   , docWidth - profileImageCellWidth - 26, 60);
	retweetBackgroundLayout = [[TweetLayout alloc] initWithFrame:splitLineFrame doc:self];
	[self addLayout:retweetBackgroundLayout];
	[retweetBackgroundLayout release];
	retweetBackgroundImageNode = [retweetBackgroundLayout addNodeForImageUrl:nil 
															   width:splitLineFrame.size.width 
															  height:splitLineFrame.size.height];
	
	if (!retweetBackgroundImage) {
		retweetBackgroundImage = [[[UIImage imageNamed:@"retweet_bg.png"] stretchableImageWithLeftCapWidth:32 topCapHeight:16] retain];
	}
	retweetBackgroundImageNode.defaultImage = retweetBackgroundImage;
		
	//-------------retweet
	retweetLayout = [[TweetLayout alloc]initWithFrame:CGRectMake(profileImageCellWidth, splitLineFrame.origin.y + 20, docWidth - profileImageCellWidth - 20, 0)
												  doc:self];
	//retweetLayout.font = [UIFont systemFontOfSize:15];
	//retweetLayout.linkFont = [UIFont boldSystemFontOfSize:15];
	//retweetLayout.linkTextColor = [UIColor colorWithRed:0x23/255.0F green:0x6E/255.0F blue:0xD8/255.0F alpha:1];
	repostAuthorImageNode = [[retweetLayout addNodeForImageUrl:nil
															 width:16 height:16] retain];
	repostAuthorImageNode.margin = UIEdgeInsetsMake(0, 0, 0, 2);
	repostAuthorLinkNode = [[retweetLayout addNodeForLink:nil url:nil] retain];

	[self addLayout:retweetLayout];
	[retweetLayout release];
	
	//-------------repostSource
	if (!defaultRepostSourceFont) {
		defaultRepostSourceFont = [[UIFont systemFontOfSize:13] retain];
	}
	if (!defaultRepostTextColor) {
		defaultRepostTextColor = [[UIColor lightGrayColor] retain];
	}
	repostSourceLayout = [[TweetLayout alloc]initWithFrame:CGRectZero 
													   doc:self];
	repostSourceLayout.font = defaultRepostSourceFont;
	repostSourceLayout.textColor = defaultRepostTextColor;
	repostSourceNode = [repostSourceLayout addNodeForText:nil];
	[self addLayout:repostSourceLayout];
	[repostSourceLayout release];
	
	//-------------repostComments
	if (!defaultRepostCommentsFont) {
		defaultRepostCommentsFont = [[UIFont systemFontOfSize:13] retain];
	}
	if (!defaultRepostCommentsLinkFont) {
		defaultRepostCommentsLinkFont = [[UIFont systemFontOfSize:13] retain];
	}
	if (!defaultRepostCommentsTextColor) {
		defaultRepostCommentsTextColor = [[UIColor lightGrayColor] retain];
	}
	if (!defaultRepostCommentsLinkTextColor) {
		defaultRepostCommentsLinkTextColor = [[UIColor colorWithWhite:0x69/255.0F alpha:1] retain];
	}
	repostCommentsLayout = [[TweetLayout alloc]initWithFrame:CGRectZero 
														 doc:self];
	//repostCommentsLayout.horizontalAlign = LayoutHorizontalAlignRight;
	repostCommentsLayout.font = defaultRepostCommentsFont;
	repostCommentsLayout.linkFont = defaultRepostCommentsLinkFont;
	repostCommentsLayout.textColor = defaultRepostCommentsTextColor;
	repostCommentsLayout.linkTextColor = defaultRepostCommentsLinkTextColor;
	repostRetweetsLinkNode = [[repostCommentsLayout addNodeForLink:nil url:@"retweetForwards"] retain];
	repostCommentsSplitTextNode = [repostCommentsLayout addNodeForText:@"  |  "];
	repostCommentsLinkNode = [[repostCommentsLayout addNodeForLink:nil url:@"retweetComments"] retain];
	[self addLayout:repostCommentsLayout];
	[repostCommentsLayout release];
	
	//-------------sourceLayout
	if (!defaultSourceFont) {
		defaultSourceFont = [[UIFont systemFontOfSize:13] retain];
	}
	if (!defaultSourceTextColor) {
		defaultSourceTextColor = [[UIColor lightGrayColor] retain];
	}
	sourceLayout = [[TweetLayout alloc]initWithFrame:CGRectZero 
												 doc:self];
	sourceLayout.font = defaultSourceFont;
	sourceLayout.textColor = defaultSourceTextColor;
	sourceNode = [sourceLayout addNodeForText:nil];
	[self addLayout:sourceLayout];
	[sourceLayout release];
	
	//-------------repostComments
	if (!defaultCommentsFont) {
		defaultCommentsFont = [[UIFont systemFontOfSize:13] retain];
	}
	if (!defaultCommentsLinkFont) {
		defaultCommentsLinkFont = [[UIFont systemFontOfSize:13] retain];
	}
	if (!defaultCommentsTextColor) {
		defaultCommentsTextColor = [[UIColor lightGrayColor] retain];
	}
	if (!defaultCommentsLinkTextColor) {
		defaultCommentsLinkTextColor = [[UIColor colorWithWhite:0x69/255.0F alpha:1] retain];
	}
	commentsLayout = [[TweetLayout alloc]initWithFrame:CGRectZero 
														 doc:self];
	commentsLayout.horizontalAlign = LayoutHorizontalAlignRight;
	commentsLayout.font = defaultCommentsFont;
	commentsLayout.linkFont = defaultCommentsLinkFont;
	commentsLayout.textColor = defaultCommentsTextColor;
	commentsLayout.linkTextColor = defaultCommentsLinkTextColor;
	retweetsLinkNode = [[commentsLayout addNodeForLink:nil url:@"forwards"] retain];
	commentsSplitTextNode = [commentsLayout addNodeForText:@"  |  "];
	commentsLinkNode = [[commentsLayout addNodeForLink:nil url:@"comments"] retain];
	[self addLayout:commentsLayout];
	[commentsLayout release];
	
	//-------------image
	CGFloat imageTop = retweetLayout.frame.origin.y + retweetLayout.frame.size.height + 10;
	imageLayout = [[TweetLayout alloc]initWithFrame:CGRectMake(profileImageCellWidth, imageTop, docWidth - profileImageCellWidth, 84)
												doc:self];
	[self addLayout:imageLayout];
	[imageLayout release];
	
	imageNode = [imageLayout addNodeForImageLink:@"image" imageUrl:nil width:kPhotoWidth height:kPhotoWidth];
	imageNode.className = @"tweetImageSmall"; 
	//NSLog(@"%@",[NSString stringWithFormat:@"statusId:%lld",status.statusId]);
	if (!defaultTweetImage) {
		defaultTweetImage = [[UIImage imageNamed:@"TweetImageloading.png"]retain];
	}
	imageNode.defaultImage = defaultTweetImage;

}


- (void)setStatus:(Status *)newStatus {
	
	if (status != newStatus) {
		[status release];
		status = [newStatus retain];
		if (status != nil) {
			[self initContentWithStatus];
			[self initSizeWithWidth];
		}
		[self setNeedsLayout];
	}
	
}


- (void)setDocWidth:(CGFloat)newWidth {
	if (docWidth != newWidth) {
		docWidth = newWidth;
		[self initSizeWithWidth];
		[self setNeedsLayout];
	}
}

- (void)refresh {
	[self refreshTimestamp];
	[self refreshComments];
	[self setNeedsDisplay];
}

- (void)refreshTimestamp {
	if (status) {
		timestampNode.text = status.timestamp;
		[timestampLayout setNeedsLayout];
		[timestampNode setNeedsDisplay];
	}
}

- (void)refreshComments {
	if (status) {
		if (status.commentsCount >= 0) {
			NSString *retweetsCountText = status.retweetsCount > 0 ? [NSString stringWithFormat:@"转发(%d)", status.retweetsCount] : @"转发";
			NSString *commentsCountText = status.commentsCount > 0 ? [NSString stringWithFormat:@"评论(%d)", status.commentsCount] : @"评论";
			commentsLinkNode.text = commentsCountText;
			commentsLinkNode.url = [NSString stringWithFormat:@"comment:%lld",status.statusId];
			retweetsLinkNode.text = retweetsCountText;
			retweetsLinkNode.url = [NSString stringWithFormat:@"retweet:%lld",status.statusId];
			commentsSplitTextNode.text = @"  |  ";
		}
		else {
			commentsSplitTextNode.text = @"";
		}
		[commentsLayout setNeedsLayout];
		[commentsLinkNode setNeedsDisplay];
		[retweetsLinkNode setNeedsDisplay];
		
		if (status.retweetedStatus) {
			if (status.retweetedStatus.commentsCount >= 0) {
				NSString *retweetedStatusRetweetsCountText = status.retweetedStatus.retweetsCount > 0 ? [NSString stringWithFormat:@"原文转发(%d)", status.retweetedStatus.retweetsCount] : @"原文转发";
				NSString *retweetedStatusCommentsCountText = status.retweetedStatus.commentsCount > 0 ? [NSString stringWithFormat:@"原文评论(%d)", status.retweetedStatus.commentsCount] : @"原文评论";
				repostCommentsLinkNode.text = retweetedStatusCommentsCountText;
				repostCommentsLinkNode.url = [NSString stringWithFormat:@"repostcomment:%lld",status.statusId];
				repostRetweetsLinkNode.text = retweetedStatusRetweetsCountText;
				repostRetweetsLinkNode.url = [NSString stringWithFormat:@"repostretweet:%lld",status.statusId];
				repostCommentsSplitTextNode.text = @"  |  ";
			}
			else {
				repostCommentsSplitTextNode.text = @"";
			}
			[repostCommentsLayout setNeedsLayout];
			[repostCommentsLinkNode setNeedsDisplay];
			[repostRetweetsLinkNode setNeedsDisplay];
		}
	}
}

- (id)initWithStatus:(Status*)_status width:(CGFloat)width_ {
	if (self = [self init]) {
		self.status = _status;
		self.docWidth = width_;
		
		[self initSizeWithWidth];
	}
	return self;
}


@end
