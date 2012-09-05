//
//  TrendNowCellView.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotStatusesDataSource.h"


@interface TrendNowCellView : UITableViewCell {
	UIScrollView *scrollView;
	HotStatusesDataSource *hotStatusesDataSource;
}

- (void)loadHotStatues;

@end
