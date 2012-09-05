//
//  CPopoverManager.h
//  PageCapture
//
//  Created by junmin liu on 10-7-4.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKIt.h>

@interface CPopoverManager : NSObject {
	UIPopoverController *currentPopoverController;
	UIActionSheet *currentActionSheet;
}

+ (CPopoverManager *)instance;

@property (readwrite, nonatomic, retain) UIPopoverController *currentPopoverController;
@property (readwrite, nonatomic, retain) UIActionSheet *currentActionSheet;

- (void)hidePopover;

@end