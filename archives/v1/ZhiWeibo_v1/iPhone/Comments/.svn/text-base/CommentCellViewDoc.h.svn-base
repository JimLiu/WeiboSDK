//
//  CommentCellViewDoc.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-28.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetDocument.h"
#import "Comment.h"

@interface CommentCellViewDoc : TweetDocument {
	Comment *comment;
	CGFloat docWidth;
	CGFloat profileImageCellWidth;
	
	TweetLayout *profileImageLayout;
	TweetImageLinkNode *profileImageNode;
	
	TweetLayout *timestampLayout;
	TweetTextNode *timestampNode;
	
	TweetLayout *authorLayout;
	TweetTextNode *authorNode;
	
	TweetLayout *commentLayout;	
}

@property (nonatomic, retain) Comment *comment;
@property (nonatomic, assign) CGFloat docWidth;

- (id)initWithComment:(Comment*)_comment width:(CGFloat)_width;
- (void)refreshTimestamp;
+ (CommentCellViewDoc *)documentWithComment:(Comment *)comment_ width:(CGFloat)_width;
- (void)initDoc;
- (void)initContentWithComment;

@end
