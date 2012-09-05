//
//  CommentCellViewDoc.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-28.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CommentCellViewDoc.h"

static NSMutableDictionary *gTweetDocument = nil;

@implementation CommentCellViewDoc
@synthesize comment, docWidth;

- (id)init {
	if (self = [super init]) {
		profileImageCellWidth = 60;
		[self initDoc];
	}
	return self;
}


+ (CommentCellViewDoc *)documentWithComment:(Comment *)comment_ width:(CGFloat)_width {
	if (!gTweetDocument) {
		gTweetDocument = [[NSMutableDictionary alloc]init];
	}
	NSString *cacheKey = [NSString stringWithFormat:@"comment-CI:%lld-W:%f", comment_.commentId, _width];
	CommentCellViewDoc *doc = [gTweetDocument objectForKey:cacheKey];
	if (!doc) {
		doc = [[CommentCellViewDoc alloc] init];
		doc.docWidth = _width;
		doc.comment = comment_;
		[gTweetDocument setObject:doc forKey:cacheKey];
		[doc release];
	}
	[doc refreshTimestamp];
	return doc;
}

- (void)initSizeWithWidth {
	
	if (docWidth <= 0) {
		return;
	}
	timestampLayout.frame = CGRectMake(0, 4, docWidth - 8, 0);
	
	commentLayout.frame = CGRectMake(profileImageCellWidth, 24, docWidth - profileImageCellWidth - 6, 0);
	[commentLayout setNeedsLayout];
	
	[self setNeedsLayout];
}

- (void)initContentWithComment {	
	profileImageNode.url = [NSString stringWithFormat:@"@%@", comment.user.screenName];
	profileImageNode.imageUrl = comment.user.profileImageUrl;
	authorNode.text = comment.user.screenName;
	
	NSMutableArray *nodes = [self parseStatus:comment.text layout:commentLayout];
	[commentLayout reset];
	for (TweetNode *node in nodes) {
		[commentLayout addNode:node];
	}
	timestampNode.text = comment.timestamp;	
}

- (void)dealloc {
	
	profileImageLayout = nil;
	profileImageNode = nil;
	
	authorLayout = nil;
	authorNode = nil;
	
	commentLayout = nil;	
	timestampLayout = nil;
	timestampNode = nil;

	
	[comment release];
	[super dealloc];
}

- (void)initDoc {
	//-------------profileImage
	profileImageLayout = [[TweetLayout alloc] 
						  initWithFrame:CGRectMake(4, 4, 52, 52) 
						  doc:self];
	[self addLayout:profileImageLayout];
	[profileImageLayout release];
	
	profileImageNode = [profileImageLayout addNodeForImageLink:nil imageUrl:nil
														 width:52 height:52];
	profileImageNode.cacheName = @"profileImages";
	profileImageNode.className = @"profileImageMiddle";
	
	static UIImage *defaultProfileImage;
	if (!defaultProfileImage) {
		defaultProfileImage = [[UIImage imageNamed:@"ProfilePlaceholderOverWhite.png"] retain];
	}
	profileImageNode.defaultImage = defaultProfileImage;
	
	
	//--------------timestamp
	timestampLayout = [[TweetLayout alloc]initWithFrame:CGRectMake(0, 4, docWidth - 8, 0)
													doc:self];
	timestampLayout.font = [UIFont boldSystemFontOfSize:12];
	timestampLayout.textColor = [UIColor colorWithRed:0x9F/255.0f green:0x9F/255.0f blue:0xA2/255.0f alpha:1];
	timestampLayout.horizontalAlign = LayoutHorizontalAlignRight;
	[self addLayout:timestampLayout];
	[timestampLayout release];
	timestampNode = [timestampLayout addNodeForText:nil];
	
	//-------------author
	authorLayout = [[TweetLayout alloc] initWithFrame:CGRectMake(profileImageCellWidth, 4, 300, 0) doc:self];
	[self addLayout:authorLayout];
	[authorLayout release];
	authorLayout.font = [UIFont boldSystemFontOfSize:15];
	authorNode = [authorLayout addNodeForText:nil];
	
	//-------------comment
	commentLayout = [[TweetLayout alloc] initWithFrame:CGRectMake(profileImageCellWidth, 24, docWidth - profileImageCellWidth - 6, 0) doc:self];
	commentLayout.font = [UIFont systemFontOfSize:15];
	commentLayout.linkFont = [UIFont boldSystemFontOfSize:15];
	commentLayout.linkTextColor = [UIColor colorWithRed:0x23/255.0F green:0x6E/255.0F blue:0xD8/255.0F alpha:1];
	[self addLayout:commentLayout];
	[commentLayout release];	
}


- (void)setComment:(Comment *)newComment {
	
	if (comment != newComment) {
		[comment release];
		comment = [newComment retain];
		if (comment != nil) {
			[self initContentWithComment];
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


- (void)refreshTimestamp {
	if (comment) {
		timestampNode.text = comment.timestamp;
	}
}

- (id)initWithComment:(Comment*)_comment width:(CGFloat)width_ {
	if (self = [self init]) {
		self.comment = _comment;
		self.docWidth = width_;
		
		[self initSizeWithWidth];
	}
	return self;
}

@end
