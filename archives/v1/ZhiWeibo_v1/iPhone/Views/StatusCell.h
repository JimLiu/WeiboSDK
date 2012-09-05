//
//  StatusCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABTableViewCell.h"
#import "Status.h"
#import "User.h"
#import "ImageDownloader.h"
#import "TweetImageStyle.h"
#import "ImageDownloadReceiver.h"
#import "StatusLayout.h"

@interface StatusCell : ABTableViewCell {
	Status *status;
    ImageDownloadReceiver*     profileReceiver;
    ImageDownloadReceiver*     photoReceiver;
	ImageDownloader *profileDownloader;
	ImageDownloader *photoDownloader;
	
	UIImage *profileImage;
	UIImage * photoImage;
}

+ (UIImage *) defaultProfileImage;
+ (UIImage *)defaultPhotoImage;
+ (UIImage *)retweetBackgroundImage;

@property (nonatomic, retain) Status *status;

@end
