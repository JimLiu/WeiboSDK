//
//  UserProfileImageView.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-26.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ImageDownloader.h"
#import "TweetImageStyle.h"
#import "ImageDownloadReceiver.h"

@interface UserProfileImageView : UIButton {
    User*               user;
	CGRect profileImageRect;	
	UIImage *profileImage;
	ImageDownloader *downloader;
    ImageDownloadReceiver*     _receiver;	
}

@property (nonatomic, retain) User*      user;
@property (nonatomic, assign) CGRect profileImageRect;

@end
