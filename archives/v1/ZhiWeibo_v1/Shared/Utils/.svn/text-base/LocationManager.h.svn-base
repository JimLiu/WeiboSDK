//
//  LocationManager.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-24.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager*  locationManager;
    CLLocation*         location;
    NSTimer*            timer;
	id                  delegate;	
	BOOL				isUpdating;
}

@property (nonatomic, assign) BOOL isUpdating;

- (id)initWithDelegate:(id)delegate;
- (void)getCurrentLocation;
- (void)stopUpdateLocation;

@end
