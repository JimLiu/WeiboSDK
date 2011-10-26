//
//  MentionsTimelineDataSource_Phone.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "MentionsTimelineDataSource_Phone.h"


@implementation MentionsTimelineDataSource_Phone

- (UITableViewCell *)getStatusTableViewCell:(UITableView *)_tableView 
									 status:(Status*)status {
	
	StatusCellViewDoc *stsDoc = [StatusCellViewDoc documentWithStatus:status
																width:_tableView.frame.size.width];
	//stsDoc.docWidth = tableView.frame.size.width;
	static NSString *CellIdentifier = @"StatusCell";
	TweetCell *cell = (TweetCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault 
								 reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.tweetCellDelegate = self;
	cell.doc = stsDoc;
	return cell;
	
	/*
	 static NSString *CellIdentifier = @"StatusCell";
	 
	 StatusCell *cell = (StatusCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	 if (cell == nil) {
	 cell = [[[StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	 }
	 
	 cell.status = status;
	 
	 return cell;
	 */ 
}

- (void)refreshTweetCell:(Status *)status {
	StatusCellViewDoc *stsDoc = [StatusCellViewDoc documentWithStatus:status
																width:tableView.frame.size.width];
	[stsDoc refresh];
}

- (CGFloat)getStatusTableViewCellHeight:(Status *)status {
	
	StatusCellViewDoc *stsDoc = [StatusCellViewDoc documentWithStatus:status
																width:tableView.frame.size.width];
	//stsDoc.docWidth = tableView.frame.size.width;
	CGFloat height = stsDoc.height + 8; // margin-bottom: 4
	if (height < 44) {
		height = 44;
	}
	return height;
	/*
	 StatusLayout *layout = [StatusLayout layoutWithStatus:status width:tableView.frame.size.width];
	 CGFloat height = layout.height;
	 if (height < 44) {
	 height = 44;
	 }
	 return height;
	 */
}
@end
