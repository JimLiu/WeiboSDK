//
//  TweetLink.h
//  TweetViewDemo
//
//  Created by junmin liu on 12-9-23.
//  Copyright (c) 2012年 openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

typedef enum {
    TweetLinkTypeURL,
    TweetLinkTypeEmail,
    TweetLinkTypeUser,
    TweetLinkTypeHash,
} TweetLinkType;

@interface TweetLink : NSObject<NSCoding> {
    NSString *_url;
    NSString *_text;
    NSRange _range;
    TweetLinkType _linkType;
    
    NSDictionary *_linkAttributes;
    NSDictionary *_activeLinkAttributes;
}

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) TweetLinkType linkType;

@property (nonatomic, retain) NSDictionary *linkAttributes;
@property (nonatomic, retain) NSDictionary *activeLinkAttributes;

- (id)initWithUrl:(NSString *)url withText:(NSString *)text withLinkType:(TweetLinkType)linkType withRange:(NSRange)range;
+ (TweetLink *)tweetLinkWithUrl:(NSString *)url withText:(NSString *)text withLinkType:(TweetLinkType)linkType withRange:(NSRange)range;

@end
