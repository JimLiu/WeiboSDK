//
//  WeiboAccountCell.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-1.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WeiboAccounts.h"
#import "UserQuery.h"
#import "ImageDownloader.h"
#import "ImageDownloadReceiver.h"
#import "Images.h"

@interface WeiboAccountCell : UITableViewCell {
    WeiboAccount *_weiboAccount;
    
    ImageDownloader *_downloader;
    ImageDownloadReceiver *_imageDownloadReceiver;

}

@property (nonatomic, retain) WeiboAccount *weiboAccount;

- (void)refresh;

@end
