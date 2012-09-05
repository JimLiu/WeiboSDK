//
//  TableCellDownloadReceiver.h
//  helloWeibo
//
//  Created by junmin liu on 11-4-20.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TableCellDownloadReceiver : NSObject {
    UITableView *tableView;
    NSIndexPath *indexPath;
}

@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSIndexPath *indexPath;

@end
