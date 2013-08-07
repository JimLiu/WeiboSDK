//
//  TweetViewCell1.m
//  WeiboPlus
//
//  Created by junmin liu on 12-11-21.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TweetViewCell1.h"

@interface TweetViewCell1() {
}

@property (nonatomic, retain) UIImage *tweetAuthorImage;
@property (nonatomic, retain) UIImage *retweetAuthorImage;

@end


@implementation TweetViewCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _downloader = [ImageDownloader profileImagesDownloader];
        _tweetAuthorImageDownloadReceiver = [[ImageDownloadReceiver alloc]init];
        _tweetAuthorImageDownloadReceiver.completionBlock = ^(NSData *imageData, NSString *url, NSError *error) {
            [self receiver:_tweetAuthorImageDownloadReceiver didDownloadWithImageData:imageData url:url error:error];
        };
        _retweetAuthorImageDownloadReceiver = [[ImageDownloadReceiver alloc]init];
        _retweetAuthorImageDownloadReceiver.completionBlock = ^(NSData *imageData, NSString *url, NSError *error) {
            [self receiver:_retweetAuthorImageDownloadReceiver didDownloadWithImageData:imageData url:url error:error];
        };
        _tweetAuthorImage = nil;
        _retweetAuthorImage = nil;
        
        _tweetAuthorProfileImageLayer = [self profileImageLayer];
        _retweetAuthorProfileImageLayer = [self profileImageLayer];
        [contentView.layer addSublayer:_tweetAuthorProfileImageLayer];
        [contentView.layer addSublayer:_retweetAuthorProfileImageLayer];
        
        _tweetTextLayer = [[[TweetLayer alloc]init] autorelease];
        _retweetTextLayer = [[[TweetLayer alloc]init] autorelease];
        _tweetAuthorLayer = [[[TweetLayer alloc]init] autorelease];
        _retweetAuthorLayer = [[[TweetLayer alloc]init] autorelease];
        _tweetTimeLayer = [self textLayer];
        _retweetTimeLayer = [self textLayer];
        [contentView.layer addSublayer:_tweetTextLayer];
        [contentView.layer addSublayer:_retweetTextLayer];
        [contentView.layer addSublayer:_tweetAuthorLayer];
        [contentView.layer addSublayer:_retweetAuthorLayer];
        [contentView.layer addSublayer:_tweetTimeLayer];
        [contentView.layer addSublayer:_retweetTimeLayer];
    }
    return self;
}

- (void)dealloc {
    [_layout release];
    _tweetAuthorImageDownloadReceiver.completionBlock = nil;
    [_tweetAuthorImageDownloadReceiver release];
    _retweetAuthorImageDownloadReceiver.completionBlock = nil;
    [_retweetAuthorImageDownloadReceiver release];
    [_tweetAuthorImage release];
    [_retweetAuthorImage release];
    
    [super dealloc];
}

- (CALayer *)profileImageLayer {
    CALayer *layer = [CALayer layer];
    layer.shouldRasterize = YES;
    layer.frame = CGRectMake(10, 10, 34, 34);
    layer.masksToBounds = YES;
    layer.rasterizationScale = [[UIScreen mainScreen] scale];
    layer.drawsAsynchronously = YES;
    return layer;
}

- (CATextLayer *)textLayer {
    CATextLayer *layer = [CATextLayer layer];
    layer.shouldRasterize = YES;
    layer.wrapped = YES;
    layer.rasterizationScale = [[UIScreen mainScreen] scale];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.drawsAsynchronously = YES;
    layer.foregroundColor = [UIColor colorWithWhite:187/255.f alpha:1.0].CGColor;
    layer.fontSize = 11;
    NSDictionary *actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"contents", nil];
    layer.actions = actions;
    [actions release];
    return layer;
}

- (void)setTweetLayers {
    _tweetTextLayer.document = _layout.tweetDocument;
    _retweetTextLayer.document = _layout.retweetDocument;
    _tweetAuthorLayer.document = _layout.tweetAuthorDocument;
    _retweetAuthorLayer.document = _layout.retweetAuthorDocument;
    NSString *timeText = [NSString stringWithFormat:@"%@・%@", [_layout.status statusTimeString], [_layout.status source]];
    _tweetTimeLayer.string = timeText;
    if (_layout.status.retweetedStatus) {
        timeText = [NSString stringWithFormat:@"%@・%@", [_layout.status.retweetedStatus statusTimeString], [_layout.status.retweetedStatus source]];
        _retweetTimeLayer.string = timeText;
    }
}

- (void)setLayout:(TweetViewCellLayout *)layout {
    if (_layout != layout) {
        [_downloader removeDelegate:_tweetAuthorImageDownloadReceiver forURL:_layout.status.user.profileImageUrl];
        if (_layout.status.retweetedStatus) {
            [_downloader removeDelegate:_retweetAuthorImageDownloadReceiver forURL:_layout.status.retweetedStatus.user.profileImageUrl];
        }
        self.tweetAuthorImage = nil;
        self.retweetAuthorImage = nil;
        _tweetAuthorProfileImageLayer.contents = (id)[self profileHolderImage].CGImage;
        _retweetAuthorProfileImageLayer.contents = (id)[self profileHolderImage].CGImage;
        [_layout release];
        _layout = [layout retain];
        [self performSelectorInBackground:@selector(setTweetLayers) withObject:nil];
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        _tweetAuthorProfileImageLayer.frame = _layout.tweetAuthorProfileImageRect;
        _retweetAuthorProfileImageLayer.frame = _layout.retweetAuthorProfileImageRect;
        _tweetTextLayer.frame = _layout.tweetTextRect;
        _retweetTextLayer.frame = _layout.retweetTextRect;
        _tweetAuthorLayer.frame = _layout.tweetAuthorTextRect;
        _retweetAuthorLayer.frame = _layout.retweetAuthorTextRect;
        _tweetTimeLayer.frame = _layout.tweetTimeTextRect;
        _retweetTimeLayer.frame = _layout.retweetTimeTextRect;
        [CATransaction commit];
        [_downloader activeRequest:_layout.status.user.profileImageUrl delegate:_tweetAuthorImageDownloadReceiver];
        if (_layout.status.retweetedStatus) {
            [_downloader activeRequest:_layout.status.retweetedStatus.user.profileImageUrl delegate:_retweetAuthorImageDownloadReceiver];
        }
        
        [self setNeedsDisplay];
        [self setNeedsLayout];
    }
}

- (UIImage *)processImageData:(NSData *)imageData rect:(CGRect)rect {
    UIImage *image = [UIImage imageWithData:imageData];
    if (image) {
        CGRect bounds = rect;
        bounds.origin = CGPointZero;
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0);
        //CGContextRef c = UIGraphicsGetCurrentContext();
        //CGContextScaleCTM(c, scale, scale);
        
        [image drawInRect:bounds];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return image;
}

- (UIImage *)profileHolderImage {
    static UIImage *profileHolderImage = nil;
    if (!profileHolderImage) {
        UIImage *image = [Images profilePlaceholderOverWhiteImage];
        if (image) {
            CGRect rect = _layout.tweetAuthorProfileImageRect;
            CGRect bounds = rect;
            bounds.origin = CGPointZero;
            UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
            //CGContextRef c = UIGraphicsGetCurrentContext();
            //CGContextScaleCTM(c, scale, scale);
            
            [image drawInRect:bounds];
            profileHolderImage = [UIGraphicsGetImageFromCurrentImageContext() retain];
            
            UIGraphicsEndImageContext();
        }
        
    }
    return profileHolderImage;
    
}

- (void)processTweetAuthorImageData:(NSData *)imageData {
    self.tweetAuthorImage = [self processImageData:imageData rect:_layout.tweetAuthorProfileImageRect];
    _tweetAuthorProfileImageLayer.contents = (id)self.tweetAuthorImage.CGImage;
}

- (void)processRetweetAuthorImageData:(NSData *)imageData {
    self.retweetAuthorImage = [self processImageData:imageData rect:_layout.retweetAuthorProfileImageRect];
    _retweetAuthorProfileImageLayer.contents = (id)self.retweetAuthorImage.CGImage;
}

- (void)receiver:(ImageDownloadReceiver *)receiver didDownloadWithImageData:(NSData *)imageData
             url:(NSString *)url error:(NSError *) error {
    
    if (error) {
        NSLog(@"imageDownloadFailed: %@, %@", url, [error localizedDescription]);
        return;//
    }
    if (receiver == _tweetAuthorImageDownloadReceiver) {
        [self performSelectorInBackground:@selector(processTweetAuthorImageData:) withObject:imageData];
    }
    else {
        [self performSelectorInBackground:@selector(processRetweetAuthorImageData:) withObject:imageData];
    }
}

/*
- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
    //CGContextRef context = UIGraphicsGetCurrentContext();
    [[Images tweetOuterBackgroundImage]drawInRect:self.bounds];
    if (_layout.status.retweetedStatus) {
        [[Images tweetInnerBackgroundImage] drawInRect:_layout.retweetRect];
    }

}
*/


@end
