//
//  UserABTableViewCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 11-1-3.
//  Copyright 2011 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABTableViewCell.h"
#import "User.h"
#import "ImageDownloader.h"
#import "TweetImageStyle.h"
#import "ImageDownloadReceiver.h"

@interface UserABTableViewCell : ABTableViewCell {
	CGRect profileImageRect;	
	User*               user;
	UIImage *profileImage;
	ImageDownloader *downloader;
    ImageDownloadReceiver*     _receiver;	
}

@property(nonatomic, retain) User*      user;
@property (nonatomic, assign) CGRect profileImageRect;

@end
