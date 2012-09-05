//
//  RefreshTableHeaderView.h
//  Weibo
//
//  Created by junmin liu on 10-10-11.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;

@interface RefreshTableHeaderView : UIView {
	
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
	PullRefreshState _state;
	
}

@property(nonatomic,assign) PullRefreshState state;

- (void)setCurrentDate;
- (void)setState:(PullRefreshState)aState;

@end
