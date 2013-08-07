//
//  TweetViewCell.m
//  WeiboPlus
//
//  Created by junmin liu on 12-10-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TweetViewCell.h"

@interface TweetViewCell() {
}

@property (nonatomic, retain) UIImage *tweetAuthorImage;
@property (nonatomic, retain) UIImage *retweetAuthorImage;
@property (nonatomic, retain) UIImage *drawedImage;

@end

@implementation TweetViewCell
@synthesize layout = _layout;
@synthesize drawedImage = _drawedImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        contentView.backgroundColor = [UIColor whiteColor];
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
    [_drawedImage release];
    
    [super dealloc];
}

- (CALayer *)profileImageLayer {
    CALayer *layer = [CALayer layer];
    layer.shouldRasterize = YES;
    layer.frame = CGRectMake(10, 10, 34, 34);
    //layer.masksToBounds = YES;
    layer.rasterizationScale = [[UIScreen mainScreen] scale];
    layer.drawsAsynchronously = YES;
    NSDictionary *actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"contents", nil];
    layer.actions = actions;
    [actions release];
    return layer;
}

- (void)resetProfileImageLayers {
    _tweetAuthorProfileImageLayer.contents = (id)[self profileHolderImage].CGImage;
    _retweetAuthorProfileImageLayer.contents = (id)[self profileHolderImage].CGImage;
}

- (void)setLayout:(TweetViewCellLayout *)layout {
    if (_layout != layout) {
        [_downloader removeDelegate:_tweetAuthorImageDownloadReceiver forURL:_layout.status.user.profileImageUrl];
        if (_layout.status.retweetedStatus) {
            [_downloader removeDelegate:_retweetAuthorImageDownloadReceiver forURL:_layout.status.retweetedStatus.user.profileImageUrl];
        }
        self.tweetAuthorImage = nil;
        self.retweetAuthorImage = nil;
        _isDrawing = NO;
        self.drawedImage = nil;
        [self performSelectorInBackground:@selector(resetProfileImageLayers) withObject:nil];
        [_layout release];
        _layout = [layout retain];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        _tweetAuthorProfileImageLayer.frame = _layout.tweetAuthorProfileImageRect;
        _retweetAuthorProfileImageLayer.frame = _layout.retweetAuthorProfileImageRect;
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

- (void)displayProfileImages {
    if (!_isDrawing) {
        if (self.tweetAuthorImage) {
            [_tweetAuthorProfileImageLayer performSelectorInBackground:@selector(setContents:) withObject:(id)self.tweetAuthorImage.CGImage];
        }
        if (self.retweetAuthorImage) {
            [_retweetAuthorProfileImageLayer performSelectorInBackground:@selector(setContents:) withObject:(id)self.retweetAuthorImage.CGImage];
        }
    }

}

- (void)processTweetAuthorImageData:(NSData *)imageData {
    self.tweetAuthorImage = [self processImageData:imageData rect:_layout.tweetAuthorProfileImageRect];
    //_tweetAuthorProfileImageLayer.contents = (id)self.tweetAuthorImage.CGImage;
    [self displayProfileImages];
    //self.drawedImage = nil;
    //[self setNeedsDisplayInRect:_layout.tweetAuthorProfileImageRect];
}

- (void)processRetweetAuthorImageData:(NSData *)imageData {
    self.retweetAuthorImage = [self processImageData:imageData rect:_layout.retweetAuthorProfileImageRect];
    //_retweetAuthorProfileImageLayer.contents = (id)self.retweetAuthorImage.CGImage;
    [self displayProfileImages];
    //self.drawedImage = nil;
    //[self setNeedsDisplayInRect:_layout.retweetAuthorProfileImageRect];
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

- (void)drawOnImage {
    if (!_isDrawing) {
        _isDrawing = YES;
        UIImage *image = nil;
        CGRect bounds = self.bounds;
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self drawContentInContext:context];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.drawedImage = image;
        [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
        _isDrawing = NO;
        [self displayProfileImages];
    }
}

- (void)drawContentInContext:(CGContextRef)context {
    [[Images tweetOuterBackgroundImage]drawInRect:self.bounds];
    if (_layout.status.retweetedStatus) {
        [[Images tweetInnerBackgroundImage] drawInRect:_layout.retweetRect];
    }
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    [_layout.tweetDocument drawTextInRect:self.bounds textRect:_layout.tweetTextRect context:context];
    [_layout.tweetAuthorDocument drawTextInRect:self.bounds textRect:_layout.tweetAuthorTextRect context:context];
    if (_layout.status.retweetedStatus) {
        [_layout.retweetDocument drawTextInRect:self.bounds textRect:_layout.retweetTextRect context:context];
        [_layout.retweetAuthorDocument drawTextInRect:self.bounds textRect:_layout.retweetAuthorTextRect context:context];
    }
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetRGBFillColor(context, 187/255.f, 187/255.f, 187/255.f, 1.f);
    
    NSString *timeText = [NSString stringWithFormat:@"%@・%@", [_layout.status statusTimeString], [_layout.status source]];
    [timeText drawInRect:_layout.tweetTimeTextRect withFont:[Fonts statusTimeFont]];
    //UIImage *profileImage = self.tweetAuthorImage ? self.tweetAuthorImage : [self profileHolderImage];
    //[profileImage drawInRect:_layout.tweetAuthorProfileImageRect];
    if (_layout.status.retweetedStatus) {
        timeText = [NSString stringWithFormat:@"%@・%@", [_layout.status.retweetedStatus statusTimeString], [_layout.status.retweetedStatus source]];
        [timeText drawInRect:_layout.retweetTimeTextRect withFont:[Fonts statusTimeFont]];
        //profileImage = self.retweetAuthorImage ? self.retweetAuthorImage : [self profileHolderImage];
        //[profileImage drawInRect:_layout.retweetAuthorProfileImageRect];
    }
    CGContextRestoreGState(context);
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawContentInContext:context];
    /*
    [[Images tweetOuterBackgroundImage]drawInRect:self.bounds];
    if (self.drawedImage) {
        [self.drawedImage drawInRect:self.bounds];
    }
    else {
        [self performSelectorInBackground:@selector(drawOnImage) withObject:nil];
    }
     */
}


@end
