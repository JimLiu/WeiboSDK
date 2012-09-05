//
//  PostAnnotation.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-1.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "StatusAnnotation.h"

@implementation StatusAnnotation
@synthesize title, subtitle, coordinate;

-(id)init {
	self = [super init];
    if (self != nil)
    {
		// etc
    }
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate = c;
	return self;
}

-(void)dealloc {
	[title release];
	[subtitle release];
	[super dealloc];
}

@end
