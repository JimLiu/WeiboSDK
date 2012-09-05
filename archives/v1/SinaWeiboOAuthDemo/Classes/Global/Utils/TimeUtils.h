//
//  TimeUtils.h
//  TwitterFon
//
//  Created by kaz on 8/26/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DebugUtils.h"
#import <sys/time.h>

@interface Stopwatch : NSObject {
    struct timeval tv1, tv2;
}

+ (Stopwatch*) stopwatch;
- (void) lap:(NSString*)message;

@end

#ifndef DISTRIBUTION
#  define INIT_STOPWATCH(s) Stopwatch *s = [Stopwatch stopwatch]
#  define LAP(s, msg) [s lap:msg]
#else
#  define INIT_STOPWATCH(s) ;
#  define LAP(s, msg) ;
#endif