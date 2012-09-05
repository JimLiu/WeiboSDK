//
//  StatusLayout.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-21.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"

@interface StatusLayout : NSObject {
	CGRect profileImageBounds;
	CGRect textBounds;
	CGRect screenNameBounds;
	CGRect timestampBounds;
	CGRect sourceBounds;
	CGRect commentsBounds;
	CGRect photoImageBounds;
	
	CGRect retweetBackgroundBounds;
	CGRect retweetTextBounds;
	CGRect retweetCommentsBounds;
	
	CGFloat height;
}

@property (nonatomic, assign) CGRect profileImageBounds;
@property (nonatomic, assign) CGRect photoImageBounds;
@property (nonatomic, assign) CGRect textBounds;
@property (nonatomic, assign) CGRect screenNameBounds;
@property (nonatomic, assign) CGRect timestampBounds;
@property (nonatomic, assign) CGRect sourceBounds;
@property (nonatomic, assign) CGRect commentsBounds;

@property (nonatomic, assign) CGRect retweetBackgroundBounds;
@property (nonatomic, assign) CGRect retweetTextBounds;
@property (nonatomic, assign) CGRect retweetCommentsBounds;

@property (nonatomic, assign) CGFloat height;


- (void)calculateSize:(Status *)status forWidth:(CGFloat)width;

+ (StatusLayout*) layoutWithStatus:(Status*)status width:(CGFloat)width;

@end
