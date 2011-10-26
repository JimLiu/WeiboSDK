//
//  TableCellDownloadReceiver.m
//  helloWeibo
//
//  Created by junmin liu on 11-4-20.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "TableCellDownloadReceiver.h"


@implementation TableCellDownloadReceiver
@synthesize tableView;
@synthesize indexPath;

- (void)imageDidDownload:(UIImage *)image url:(NSString *)url {
    if (tableView) {
        NSArray *indexPathes = [tableView indexPathsForVisibleRows];
        int i = [indexPathes indexOfObject:indexPath];
        if (i > -1) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = image;
        }
    }
}


- (void)imageDownloadFailed:(NSError *)error url:(NSString *)url {
    NSLog(@"imageDownloadFailed: %@, %@", url, [error localizedDescription]);
}


- (void)dealloc {
    [indexPath release];
    [super dealloc];
}

@end
