//
//  UserCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-12.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ImageDownloader.h"
#import "TweetImageStyle.h"
#import "ImageDownloadReceiver.h"

@interface UserCell : UITableViewCell {
	User*               user;
	UIImage *profileImage;
	ImageDownloader *downloader;
    ImageDownloadReceiver*     _receiver;
}

@property(nonatomic, retain) User*      user;

@end
