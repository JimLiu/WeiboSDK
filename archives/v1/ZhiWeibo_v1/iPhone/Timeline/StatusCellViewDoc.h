//
//  StatusCellViewDoc.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-8.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetDocument.h"
#import "Status.h"

@interface StatusCellViewDoc : TweetDocument {
	Status *status;
	CGFloat docWidth;
	CGFloat profileImageCellWidth;
	
	TweetLayout *profileImageLayout;
	TweetImageLinkNode *profileImageNode;
	
	TweetLayout *timestampLayout;
	TweetTextNode *timestampNode;
	TweetImageNode *locationImageNode;
	
	TweetLayout *authorLayout;
	TweetTextNode *authorNode;
	TweetImageNode *authorVerifiedImageNode;
	
	TweetLayout *statusLayout;
	
	TweetLayout *retweetBackgroundLayout;
	TweetImageNode *retweetBackgroundImageNode;
	
	TweetLayout *repostLayoutAuthor;
	TweetImageNode *repostImageNode;
	TweetImageNode *repostAuthorImageNode;
	TweetImageNode *repostAuthorVerifiedImageNode;
	TweetLinkNode *repostAuthorLinkNode;
	
	TweetLayout *retweetLayout;
	
	TweetLayout *repostSourceLayout;
	TweetTextNode *repostSourceNode;
	
	TweetLayout *repostCommentsLayout;
	TweetLinkNode *repostCommentsLinkNode;
	TweetTextNode *repostCommentsSplitTextNode;
	TweetLinkNode *repostRetweetsLinkNode;
	
	TweetLayout *sourceLayout;
	TweetTextNode *sourceNode;
	
	TweetLayout *commentsLayout;
	TweetLinkNode *commentsLinkNode;
	TweetTextNode *commentsSplitTextNode;
	TweetLinkNode *retweetsLinkNode;
	
	TweetLayout *imageLayout;
	TweetImageLinkNode *imageNode;
}

@property (nonatomic, retain) Status *status;
@property (nonatomic, assign) CGFloat docWidth;

- (id)initWithStatus:(Status*)_status width:(CGFloat)_width;
- (void)refresh;
- (void)refreshTimestamp;
- (void)refreshComments;
+ (StatusCellViewDoc *)documentWithStatus:(Status *)status_ width:(CGFloat)_width;

@end

