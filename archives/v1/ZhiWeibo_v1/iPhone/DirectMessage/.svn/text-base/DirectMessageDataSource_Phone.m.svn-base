//
//  DirectMessageDataSource_Phone.m
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "DirectMessageDataSource_Phone.h"
#import "ConversationController.h"

@implementation DirectMessageDataSource_Phone

- (UITableViewCell *)getConversationTableViewCell:(UITableView *)_tableView 
									 conversation:(Conversation*)conversation {
    static NSString *CellIdentifier = @"ConversationCell";
    
    ConversationTableViewCell *cell = (ConversationTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    cell.conversation = conversation;
    return cell;
	
}


@end
