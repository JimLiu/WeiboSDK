//
//  TweetViewCellLayout.h
//  TweetViewDemo
//
//  Created by junmin liu on 12-10-6.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetDocument.h"
#import "Status.h"
#import "Fonts.h"

@interface TweetViewCellLayout : NSObject {
    TweetDocument *_tweetDocument;
    TweetDocument *_tweetAuthorDocument;
    TweetDocument *_retweetDocument;
    TweetDocument *_retweetAuthorDocument;
    
    CGRect _tweetAuthorProfileImageRect;
    CGRect _retweetAuthorProfileImageRect;
    CGRect _tweetAuthorTextRect;
    CGRect _retweetAuthorTextRect;
    CGRect _tweetTimeTextRect;
    CGRect _retweetTimeTextRect;
    CGRect _tweetTextRect;
    CGRect _retweetTextRect;
    CGRect _tweetRect;
    CGRect _retweetRect;
    
    CGSize _size;

    Status *_status;
}

@property (nonatomic, retain) Status *status;

@property (nonatomic, readonly) CGSize size;

@property (nonatomic, readonly) CGRect tweetAuthorProfileImageRect;
@property (nonatomic, readonly) CGRect retweetAuthorProfileImageRect;
@property (nonatomic, readonly) CGRect tweetAuthorTextRect;
@property (nonatomic, readonly) CGRect retweetAuthorTextRect;
@property (nonatomic, readonly) CGRect tweetTimeTextRect;
@property (nonatomic, readonly) CGRect retweetTimeTextRect;
@property (nonatomic, readonly) CGRect tweetTextRect;
@property (nonatomic, readonly) CGRect retweetTextRect;
@property (nonatomic, readonly) CGRect tweetRect;
@property (nonatomic, readonly) CGRect retweetRect;

@property (nonatomic, readonly) TweetDocument *tweetDocument;
@property (nonatomic, readonly) TweetDocument *tweetAuthorDocument;
@property (nonatomic, readonly) TweetDocument *retweetDocument;
@property (nonatomic, readonly) TweetDocument *retweetAuthorDocument;

- (void)layoutForWidth:(CGFloat)width;



@end
