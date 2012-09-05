//
//  TweetCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-16.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetDocument.h"
#import "TweetCellView.h"

@protocol TweetCellDelegate

- (void)processTweetNode:(TweetNode*)node;

@end


@interface TweetCell : UITableViewCell {
    TweetCellView*  cellView;
	TweetDocument *doc;
	
	BOOL enableSelected;
	
	TweetNode *highlightNode;
	
	id<TweetCellDelegate> tweetCellDelegate;
}

@property (nonatomic, retain) TweetDocument *doc;
@property (nonatomic, assign) BOOL enableSelected;
@property (nonatomic, assign) id<TweetCellDelegate> tweetCellDelegate;

@end
