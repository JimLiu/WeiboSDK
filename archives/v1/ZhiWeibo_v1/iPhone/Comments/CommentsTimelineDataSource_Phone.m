//
//  CommentsTimelineDataSource_Phone.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CommentsTimelineDataSource_Phone.h"


@implementation CommentsTimelineDataSource_Phone

- (UITableViewCell *)getCommentTableViewCell:(UITableView *)_tableView 
									 comment:(Comment*)comment {
	CommentToMeCellViewDoc *commentDoc = [CommentToMeCellViewDoc documentWithComment:comment
																	   width:_tableView.frame.size.width];
	static NSString *CellIdentifier = @"CommentCell";
	TweetCell *cell = (TweetCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault 
								 reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.doc = commentDoc;
	cell.tweetCellDelegate = self;
	return cell;
}

- (CGFloat)getCommentTableViewCellHeight:(UITableView *)_tableView 
								comment:(Comment*)comment {
	CommentToMeCellViewDoc *commentDoc = [CommentToMeCellViewDoc documentWithComment:comment 
																	   width:_tableView.frame.size.width];
	CGFloat height = commentDoc.height + 4; // margin-bottom: 10
	if (height < 60) {
		height = 60;
	}
	return height;
}


@end
