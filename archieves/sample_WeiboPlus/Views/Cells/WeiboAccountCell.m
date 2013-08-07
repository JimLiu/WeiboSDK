//
//  WeiboAccountCell.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-1.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboAccountCell.h"

@implementation WeiboAccountCell
@synthesize weiboAccount = _weiboAccount;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _downloader = [ImageDownloader profileImagesDownloader];
        _imageDownloadReceiver = [[ImageDownloadReceiver alloc]init];
        _imageDownloadReceiver.completionBlock = ^(NSData *imageData, NSString *url, NSError *error) {
            [self imageDidDownload:imageData url:url error:error];
        };

        CALayer *imageLayer = self.imageView.layer;
        imageLayer.cornerRadius = 3;
        imageLayer.masksToBounds = YES;
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return self;
}

- (void)dealloc {
    _imageDownloadReceiver.completionBlock = nil;
    [_imageDownloadReceiver release];
    [_weiboAccount release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10,10,32,32);
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 52;
    self.textLabel.frame = frame;
}

- (void)refresh {
    NSString *screenName = [_weiboAccount screenName] ? [NSString stringWithFormat:@"@%@", _weiboAccount.screenName] : _weiboAccount.userId;
    self.textLabel.text = screenName;
    if (_weiboAccount.selected) {
        UIImageView *accImageView = [[UIImageView alloc] initWithImage:[Images checkImage]];
        //[accImageView setFrame:CGRectMake(0, 0, 14, 13)];
        self.accessoryView = accImageView;
        [accImageView release];
    }
    else {
        self.accessoryView = nil;
    }
}

- (void)setWeiboAccount:(WeiboAccount *)weiboAccount {
    if (_weiboAccount != weiboAccount) {
        if (_weiboAccount) {
            [_downloader removeDelegate:_imageDownloadReceiver forURL:_weiboAccount.profileImageUrl];
        }
        [_weiboAccount release];
        _weiboAccount = [weiboAccount retain];
        self.imageView.image = [Images profilePlaceholderOverWhiteImage];

        if (_weiboAccount) {
            if (_weiboAccount.profileImageUrl) {
                [_downloader activeRequest:_weiboAccount.profileImageUrl delegate:_imageDownloadReceiver];
            }
            else {
                UserQuery *query = [UserQuery query];
                query.completionBlock = ^(WeiboRequest *request, User *user, NSError *error) {
                    if (error) {
                        //
                        NSLog(@"UserQuery error: %@", error);
                    }
                    else {
                        _weiboAccount.screenName = user.screenName;
                        _weiboAccount.profileImageUrl = user.profileLargeImageUrl;
                        [_downloader activeRequest:_weiboAccount.profileImageUrl delegate:_imageDownloadReceiver];
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                                 (unsigned long)NULL), ^(void) {
                            [[WeiboAccounts shared]addAccount:_weiboAccount];
                        });
                        [self setNeedsDisplay];
                    }
                };
                [query queryWithUserId:[_weiboAccount.userId longLongValue]];
            }
            
        }
    }
    [self refresh];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)imageDidDownload:(NSData *)imageData url:(NSString *)url error:(NSError *)error {
    if (error) {
        NSLog(@"imageDownloadFailed: %@, %@", url, [error localizedDescription]);
        return;
    }
    //NSLog(@"imageDidDownload: %@", url);
    UIImage *image = [UIImage imageWithData:imageData];
    if (image) {
        self.imageView.image = image;
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeOutAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        fadeOutAnimation.toValue = [NSNumber numberWithFloat:1.0];
        fadeOutAnimation.duration = 0.255;
        [self.imageView.layer addAnimation:fadeOutAnimation forKey:@"opacity"];
    }
    
}

@end
