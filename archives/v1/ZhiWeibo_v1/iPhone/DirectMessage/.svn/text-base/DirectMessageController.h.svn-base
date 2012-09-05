//
//  DirectMessageController.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-2.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectMessageDataSource_Phone.h"
#import "PullRefreshTableView.h"
#import "ConversationController.h"

@interface DirectMessageController : UITableViewController<DirectMessageDataSourceDelegate,ConversationControllerDelegate> {
	DirectMessageDataSource_Phone *dataSource;
	ConversationController *conversationController;
}

@property (nonatomic, retain) IBOutlet ConversationController *conversationController;

- (DirectMessageDataSource_Phone *)dataSource;

- (IBAction)refreshButtonTouch:(id)sender;

- (IBAction)composeButtonTouch:(id)sender;

- (void)loadTimeline;

@end
