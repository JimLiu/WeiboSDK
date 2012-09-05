//
//  RepostTimelineDataSource_Phone.m
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepostTimelineDataSource_Phone.h"


@implementation RepostTimelineDataSource_Phone

- (UITableViewCell *)getStatusTableViewCell:(UITableView *)_tableView 
									 status:(Status*)_status { 
	
	StatusCellViewDoc *stsDoc = [StatusCellViewDoc documentWithStatus:_status
																width:_tableView.frame.size.width];
	//stsDoc.docWidth = tableView.frame.size.width;
	static NSString *CellIdentifier = @"StatusCell";
	TweetCell *cell = (TweetCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault 
								 reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.doc = stsDoc;
	cell.tweetCellDelegate = self;
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

- (void)refreshTweetCell:(Status *)_status {
	StatusCellViewDoc *stsDoc = [StatusCellViewDoc documentWithStatus:_status
																width:tableView.frame.size.width];
	[stsDoc refresh];
}

- (CGFloat)getStatusTableViewCellHeight:(Status *)_status {
	
	StatusCellViewDoc *stsDoc = [StatusCellViewDoc documentWithStatus:_status
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
