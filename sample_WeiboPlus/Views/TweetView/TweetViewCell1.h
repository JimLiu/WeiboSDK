//
//  TweetViewCell1.h
//  WeiboPlus
//
//  Created by junmin liu on 12-11-21.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "ABTableViewCell.h"
#import "TweetViewCellLayout.h"
#import "ImageDownloader.h"
#import "ImageDownloadReceiver.h"
#import "Images.h"
#import "TweetLayer.h"


@interface TweetViewCell1 : ABTableViewCell {
    TweetViewCellLayout *_layout;
    ImageDownloader *_downloader;
    ImageDownloadReceiver *_tweetAuthorImageDownloadReceiver;
    ImageDownloadReceiver *_retweetAuthorImageDownloadReceiver;
    UIImage *_tweetAuthorImage;
    UIImage *_retweetAuthorImage;

    
    CALayer *_tweetAuthorProfileImageLayer;
    CALayer *_retweetAuthorProfileImageLayer;
    
    TweetLayer *_tweetTextLayer;
    TweetLayer *_retweetTextLayer;
    TweetLayer *_tweetAuthorLayer;
    TweetLayer *_retweetAuthorLayer;
    CATextLayer *_tweetTimeLayer;
    CATextLayer *_retweetTimeLayer;
}

@property (nonatomic, retain) TweetViewCellLayout *layout;


@end
