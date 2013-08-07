//
//  TweetViewCellLayout.m
//  TweetViewDemo
//
//  Created by junmin liu on 12-10-6.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "TweetViewCellLayout.h"

@interface TweetViewCellLayout()

@end

@implementation TweetViewCellLayout
@synthesize status = _status;
@synthesize size = _size;

@synthesize tweetDocument = _tweetDocument;
@synthesize tweetAuthorDocument = _tweetAuthorDocument;
@synthesize retweetDocument = _retweetDocument;
@synthesize retweetAuthorDocument = _retweetAuthorDocument;

@synthesize tweetAuthorProfileImageRect = _tweetAuthorProfileImageRect;
@synthesize retweetAuthorProfileImageRect = _retweetAuthorProfileImageRect;
@synthesize tweetAuthorTextRect = _tweetAuthorTextRect;
@synthesize retweetAuthorTextRect = _retweetAuthorTextRect;
@synthesize tweetTimeTextRect = _tweetTimeTextRect;
@synthesize retweetTimeTextRect = _retweetTimeTextRect;
@synthesize tweetTextRect = _tweetTextRect;
@synthesize retweetTextRect = _retweetTextRect;
@synthesize tweetRect = _tweetRect;
@synthesize retweetRect = _retweetRect;

- (void)dealloc {
    [_status release];
    
    [_tweetDocument release];
    [_tweetAuthorDocument release];
    [_retweetAuthorDocument release];
    [_retweetDocument release];
    [super dealloc];
}


- (void)setStatus:(Status *)status {
    if (_status != status) {
        
        [_tweetDocument release];
        _tweetDocument = nil;
        [_tweetAuthorDocument release];
        _tweetAuthorDocument = nil;
        [_retweetAuthorDocument release];
        _retweetAuthorDocument = nil;
        [_retweetDocument release];
        _retweetDocument = nil;
        _size = CGSizeZero;
        
        [_status release];
        _status = [status retain];
        
        if (_status) {
            _tweetDocument = [[TweetDocument documentWithTweet:_status.text] retain];
            
            NSString *screenName;
            if (_status.retweetedStatus) {
                
                _retweetDocument = [[TweetDocument documentWithTweet:_status.retweetedStatus.text] retain];
                screenName = _status.retweetedStatus.user.screenName;
                _retweetAuthorDocument = [[TweetDocument documentWithTweet:screenName] retain];
                [_retweetAuthorDocument addTweetLink:[TweetLink tweetLinkWithUrl:screenName withText:screenName withLinkType:TweetLinkTypeUser withRange:NSMakeRange(0, screenName.length)]];
                
                NSString *screenName1 = _status.user.screenName;
                NSString *authInfo = [NSString stringWithFormat:@"%@", screenName1];
                _tweetAuthorDocument = [[TweetDocument documentWithTweet:authInfo] retain];
                [_tweetAuthorDocument addTweetLink:[TweetLink tweetLinkWithUrl:screenName1 withText:screenName1 withLinkType:TweetLinkTypeUser withRange:NSMakeRange(0, screenName1.length)]];
                
            }
            else {
                screenName = _status.user.screenName;
                _tweetAuthorDocument = [[TweetDocument documentWithTweet:screenName] retain];
                [_tweetAuthorDocument addTweetLink:[TweetLink tweetLinkWithUrl:screenName withText:screenName withLinkType:TweetLinkTypeUser withRange:NSMakeRange(0, screenName.length)]];
            }
        }
        _tweetDocument.font = [Fonts defaultFont];
        _tweetAuthorDocument.font = [Fonts defaultFont];
        _retweetDocument.font = [Fonts defaultFont];
        _retweetAuthorDocument.font = [Fonts defaultFont];
        [_tweetDocument setNeedsFramesetter];
        [_tweetAuthorDocument setNeedsFramesetter];
        [_retweetDocument setNeedsFramesetter];
        [_retweetAuthorDocument setNeedsFramesetter];
    }
}


- (void)layoutForWidth:(CGFloat)width {
    CGFloat height = 0;
    CGFloat top = 7;
    _tweetRect = CGRectMake(10, top, width - 20, 0);
    top += 10;
    _tweetAuthorProfileImageRect = CGRectMake(20, top, 34, 34);
    CGFloat authorTextWidth = width - 10 * 2 - 10 * 2 - 34 - 10;
    CGFloat authorTextHeight = [self.tweetAuthorDocument textSizeForWidth:authorTextWidth].height;
    CGFloat authorTextLeft = 20 + 34 + 10;
    _tweetAuthorTextRect = CGRectMake(authorTextLeft, top + 2, authorTextWidth, authorTextHeight + 4);
    _tweetTimeTextRect = CGRectMake(authorTextLeft, top + authorTextHeight + 5, authorTextWidth, 14);
    if (2 + authorTextHeight + 12 < 34)
        top += 34;
    else
        top += 2 + authorTextHeight + 12;
    top += 10;
    CGFloat tweetTextWidth = width - 10 * 2 - 10 * 2;
    CGFloat tweetTextHeight = [self.tweetDocument textSizeForWidth:tweetTextWidth].height;
    _tweetTextRect = CGRectMake(20, top, tweetTextWidth, tweetTextHeight + 4);
    
    top += tweetTextHeight;
    
    if (_status.retweetedStatus) {
        top += 10;
        _retweetRect = CGRectMake(20, top, width - 40, 0);
        top += 10;
        _retweetAuthorProfileImageRect = CGRectMake(30, top, 34, 34);
        CGFloat retweetAuthorTextWidth = authorTextWidth - 20;
        CGFloat retweetAuthorTextHeight = [self.retweetAuthorDocument textSizeForWidth:retweetAuthorTextWidth].height;
        _retweetAuthorTextRect = CGRectMake(authorTextLeft + 10, top + 2, retweetAuthorTextWidth, retweetAuthorTextHeight + 4);
        _retweetTimeTextRect = CGRectMake(authorTextLeft + 10, top + retweetAuthorTextHeight + 5, retweetAuthorTextWidth, 14);
        if (2 + retweetAuthorTextHeight + 12 < 34)
            top += 34;
        else
            top += 2 + retweetAuthorTextHeight + 12;
        top += 10;
        CGFloat retweetTextWidth = tweetTextWidth - 20;
        CGFloat retweetTextHeight = [self.retweetDocument textSizeForWidth:retweetTextWidth].height;
        _retweetTextRect = CGRectMake(30, top, retweetTextWidth, retweetTextHeight + 4);
        top += retweetTextHeight;
        top += 10;
        _retweetRect.size.height = top - _retweetRect.origin.y;
    }
    top += 10;
    _tweetRect.size.height = top - _tweetRect.origin.y;
    height = top + 7;
    _size = CGSizeMake(width, height);
}

@end
