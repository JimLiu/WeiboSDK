//
//  TweetLink.m
//  TweetViewDemo
//
//  Created by junmin liu on 12-9-23.
//  Copyright (c) 2012年 openlab. All rights reserved.
//

#import "TweetLink.h"

@implementation TweetLink
@synthesize url = _url;
@synthesize text = _text;
@synthesize range = _range;
@synthesize linkType = _linkType;

@synthesize linkAttributes = _linkAttributes;
@synthesize activeLinkAttributes = _activeLinkAttributes;

- (id)init {
    self = [super init];
    if (self) {
        
        UIColor *linkColor = [UIColor colorWithRed:36/255.f green:119/255.f blue:179/255.f alpha:1.0f];
        
        NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
        [mutableLinkAttributes setValue:(id)[linkColor CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        self.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
        
        NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
        //[mutableActiveLinkAttributes setValue:(id)[linkColor CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        
        self.activeLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableActiveLinkAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.url = [coder decodeObjectForKey:@"url"];
        self.text = [coder decodeObjectForKey:@"text"];
        self.linkType = (TweetLinkType)[coder decodeIntForKey:@"linkType"];
        self.range = [[coder decodeObjectForKey:@"range"] rangeValue];
        
        self.linkAttributes = [coder decodeObjectForKey:@"linkAttributes"];
        self.activeLinkAttributes = [coder decodeObjectForKey:@"activeLinkAttributes"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeInt:self.linkType forKey:@"linkType"];
    [coder encodeObject:[NSValue valueWithRange:self.range] forKey:@"range"];
    [coder encodeObject:self.linkAttributes forKey:@"linkAttributes"];
    [coder encodeObject:self.activeLinkAttributes forKey:@"activeLinkAttributes"];
}

- (id)initWithUrl:(NSString *)url withText:(NSString *)text withLinkType:(TweetLinkType)linkType withRange:(NSRange)range {
    self = [self init];
    if (self) {
        self.text = text;
        self.url = url;
        self.linkType = linkType;
        self.range = range;
    }
    return self;
}

+ (TweetLink *)tweetLinkWithUrl:(NSString *)url withText:(NSString *)text withLinkType:(TweetLinkType)linkType withRange:(NSRange)range {
    return [[[TweetLink alloc]initWithUrl:url withText:text withLinkType:linkType withRange:range]autorelease];
}

- (void)dealloc
{
    [_url release];
    [_text release];
    
    [_linkAttributes release];
    [_activeLinkAttributes release];
    
    [super dealloc];
}

@end
