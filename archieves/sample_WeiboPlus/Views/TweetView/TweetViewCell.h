//
//  TweetViewCell.h
//  WeiboPlus
//
//  Created by junmin liu on 12-10-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "ABTableViewCell.h"
#import "TweetViewCellLayout.h"
#import "ImageDownloader.h"
#import "ImageDownloadReceiver.h"
#import "Images.h"

@interface TweetViewCell : ABTableViewCell {
    TweetViewCellLayout *_layout;
    ImageDownloader *_downloader;
    ImageDownloadReceiver *_tweetAuthorImageDownloadReceiver;
    ImageDownloadReceiver *_retweetAuthorImageDownloadReceiver;
    UIImage *_tweetAuthorImage;
    UIImage *_retweetAuthorImage;
    
    UIImage *_drawedImage;
    BOOL _isDrawing;
    
    CALayer *_tweetAuthorProfileImageLayer;
    CALayer *_retweetAuthorProfileImageLayer;
}
@property (nonatomic, retain) TweetViewCellLayout *layout;

@end
