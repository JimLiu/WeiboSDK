//
//  DebugUtils.h
//  TwitterFon
//
//  Created by kaz on 7/21/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#  define LOG(...) NSLog(__VA_ARGS__)
#  define LOGRECT(r) NSLog(@"(%.1fx%.1f)-(%.1fx%.1f)", r.origin.x, r.origin.y, r.size.width, r.size.height)
#else
#  define LOG(...) ;
#  define LOGRECT(r) ;
#endif

#define __FUNC_NAME__ NSLog(NSStringFromSelector(_cmd)); 
