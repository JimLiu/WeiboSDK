//
//  ApplicationHelper.m
//  ZhiWeibo2
//
//  Created by junmin liu on 11-2-5.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "ApplicationHelper.h"


static int NetworkActivityIndicatorCounter = 0;


@implementation ApplicationHelper


+ (void) increaseNetworkActivityIndicator
{
	if (NetworkActivityIndicatorCounter < 0) {
		NetworkActivityIndicatorCounter = 0;
	}
	NetworkActivityIndicatorCounter++;
	BOOL preVisible = [UIApplication sharedApplication].networkActivityIndicatorVisible;
	if (!preVisible) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NetworkActivityIndicatorCounter > 0;
	}
}

+ (void) decreaseNetworkActivityIndicator
{
	if (NetworkActivityIndicatorCounter > 0) {
		NetworkActivityIndicatorCounter--;
	}
	BOOL preVisible = [UIApplication sharedApplication].networkActivityIndicatorVisible;
	if (preVisible && NetworkActivityIndicatorCounter <= 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NetworkActivityIndicatorCounter > 0;
	}
}


@end
