//
//  TweetStyle.h
//  TweetViewDemo
//
//  Created by junmin liu on 10-10-15.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TweetStyle : NSObject {
	
}

+ (TweetStyle *)sharedStyle;

- (id)processWithClassName:(NSString*)className object:(id)sender;

@end
