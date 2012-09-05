//
//  DummyGapCell.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-10-26.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DummyGapStatus.h"

@interface DummyGapCell : UITableViewCell {
	DummyGapStatus *dummyGapStatus;
    UIActivityIndicatorView*    spinner;
	UIView* backgroundView;
	UIView* selectedBackgroundView;
}

- (void)drawContentView:(CGRect)rect highlighted:(BOOL)highlighted; // subclasses should implement

@property(nonatomic, retain) DummyGapStatus *dummyGapStatus;
@property(nonatomic, readonly) UIActivityIndicatorView* spinner;

@end
