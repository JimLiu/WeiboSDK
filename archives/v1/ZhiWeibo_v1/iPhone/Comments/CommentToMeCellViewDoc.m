//
//  CommentToMeCellViewDoc.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommentToMeCellViewDoc.h"


static NSMutableDictionary *gTweetDocument = nil;

@implementation CommentToMeCellViewDoc

+ (CommentToMeCellViewDoc *)documentWithComment:(Comment *)comment_ width:(CGFloat)_width {
	if (!gTweetDocument) {
		gTweetDocument = [[NSMutableDictionary alloc]init];
	}
	NSString *cacheKey = [NSString stringWithFormat:@"comment-TM:%lld-W:%f", comment_.commentId, _width];
	CommentToMeCellViewDoc *doc = [gTweetDocument objectForKey:cacheKey];
	if (!doc) {
		doc = [[CommentToMeCellViewDoc alloc] init];
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
	
	commentSourceLayout.frame = CGRectMake(profileImageCellWidth, 40+commentLayout.frame.size.height, docWidth - profileImageCellWidth - 6, 0);
	[commentSourceLayout setNeedsLayout];
	
	[self setNeedsLayout];
}

- (void)initContentWithComment {	
	[super initContentWithComment];
	//NSMutableString *statusString = [NSMutableString stringWithString:comment.status.text];
	NSString *text = [NSString stringWithFormat:@"回复微博:%@",comment.status.text];
	if([text sizeWithFont:[UIFont systemFontOfSize:15]].width > (docWidth - profileImageCellWidth - 50)*2) {
		NSRange range = NSMakeRange(0, 15);
		while ([[text substringWithRange:range] sizeWithFont:[UIFont systemFontOfSize:15]].width < (docWidth - profileImageCellWidth - 50)*2) {
			//NSLog(@"%g, %g",docWidth - profileImageCellWidth - 30,[[text substringWithRange:range] sizeWithFont:[UIFont systemFontOfSize:15]].width);
			range = NSMakeRange(0, (range.length)+1);
		}
		text = [NSString stringWithFormat:@"%@...",[text substringWithRange:range]];
	}
	
	[commentSourceLayout reset];
	TweetTextNode *node = [[[TweetTextNode alloc] initWithText:text layout:commentSourceLayout] autorelease];
	[commentSourceLayout addNode:node];	
}

- (void) initDoc {
	[super initDoc];
	//-------------commentSource
	commentSourceLayout = [[TweetLayout alloc] initWithFrame:CGRectMake(profileImageCellWidth, 24, docWidth - profileImageCellWidth - 6, 0) doc:self];
	commentSourceLayout.font = [UIFont systemFontOfSize:15];
	commentSourceLayout.linkFont = [UIFont boldSystemFontOfSize:15];
	commentSourceLayout.linkTextColor = [UIColor colorWithRed:0x23/255.0F green:0x6E/255.0F blue:0xD8/255.0F alpha:1];
	[self addLayout:commentSourceLayout];
	[commentSourceLayout release];
}

- (void)dealloc {
	commentSourceLayout = nil;
	[super dealloc];
}

@end
