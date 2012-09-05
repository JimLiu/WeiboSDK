//
//  RootViewController.h
//  helloWeibo
//
//  Created by junmin liu on 11-4-12.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "Status.h"
#import "TableCellDownloadReceiver.h"
#import "ImageDownloader.h"

@interface RootViewController : UITableViewController {
    NSMutableArray *statuses;
    
    NSMutableDictionary *cellReceivers;
}
//

@end
