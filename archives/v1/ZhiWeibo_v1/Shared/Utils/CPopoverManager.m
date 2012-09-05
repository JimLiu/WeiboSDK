//
//  CPopoverManager.m
//  PageCapture
//
//  Created by junmin liu on 10-7-4.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "CPopoverManager.h"

static CPopoverManager *gInstance = NULL;

@implementation CPopoverManager
@synthesize currentActionSheet;

+ (id)instance
{
	@synchronized(self)
	{
		if (gInstance == NULL)
		{
			gInstance = [[self alloc] init];
		}
	}
	return(gInstance);
}

- (UIPopoverController *)currentPopoverController
{
	return(currentPopoverController);
}

- (void)setCurrentActionSheet:(UIActionSheet *)newActionSheet {
	if (currentActionSheet != newActionSheet)
	{
		if (currentActionSheet != NULL)
		{
			[currentActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
			[currentActionSheet release];
			currentActionSheet = NULL;	
		}
		if (newActionSheet)
		{
			currentActionSheet = [newActionSheet retain];
		}
	}
}

- (void)setCurrentPopoverController:(UIPopoverController *)inCurrentPopoverController
{
	@synchronized(@"currentPopoverController")
	{
		if (currentPopoverController != inCurrentPopoverController)
		{
			if (currentPopoverController != NULL)
			{
				[currentPopoverController dismissPopoverAnimated:YES];
				[currentPopoverController release];
				currentPopoverController = NULL;	
			}
			if (inCurrentPopoverController)
			{
				currentPopoverController = [inCurrentPopoverController retain];
			}
		}
	}
}

- (void)hidePopover {
	if (currentPopoverController) {
		[currentPopoverController dismissPopoverAnimated:YES];
	}
	if (currentActionSheet != NULL && [currentActionSheet isVisible])
	{
		[currentActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
	}
}

@end
