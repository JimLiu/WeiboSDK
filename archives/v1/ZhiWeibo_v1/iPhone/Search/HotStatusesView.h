//
//  HotStatusesView.h
//  ZhiWeibo
//
//  Created by Zhang Jason on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@class ImageDownloader;
@class ImageDownloadReceiver;
@interface HotStatusesView : UIView {
	Status *status;
	UIImage *profileImage;
	CGRect profileImageRect;
	CGRect textRect;
	ImageDownloader *downloader;
    ImageDownloadReceiver*     _receiver;
	UIImage *defaultProfileImage;
	
	UIFont *textFont;
}

- (void)setStatus:(Status *)_status;

@end
