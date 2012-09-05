//
//  LocationManager.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-11-24.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "LocationManager.h"
#import "ZhiWeiboAppDelegate.h"

@interface NSObject (LocationManagerDelegate)
- (void)locationManagerDidUpdateLocation:(LocationManager*)manager location:(CLLocation*)location;
- (void)locationManagerDidReceiveLocation:(LocationManager*)manager location:(CLLocation*)location;
- (void)locationManagerDidFail:(LocationManager*)manager;
@end

#define GPS_TIMEOUT_TIME        40.0
#define GPS_ACCURACY_THRESHOLD  300.0

@implementation LocationManager
@synthesize isUpdating;

- (id)initWithDelegate:(id)aDelegate
{
    [super init];
    delegate = aDelegate;
    location = nil;
	
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
	//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    return self;
}

- (void)dealloc
{
    if (timer)    [timer invalidate];
    if (location) [location release];
    [locationManager release];
    [super dealloc];
}

- (void)getCurrentLocation
{
    [locationManager startUpdatingLocation];
	isUpdating = YES;
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
    timer = [NSTimer scheduledTimerWithTimeInterval:GPS_TIMEOUT_TIME 
                                             target:self 
                                           selector:@selector(locationManagerDidTimeout:userInfo:) 
                                           userInfo:nil 
                                            repeats:false];
}

- (void)stopUpdateLocation {
	[locationManager stopUpdatingLocation];
	[timer invalidate];
	timer = nil;
	[location release];
	location = nil;
	isUpdating = NO;
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    NSLog(@"%@ (%lf)", [newLocation description], howRecent);
    
    if ([delegate respondsToSelector:@selector(locationManagerDidUpdateLocation:location:)]) {
        [delegate locationManagerDidUpdateLocation:self location:newLocation];
    }
    
    if (location) [location release];
    location = [newLocation retain];
	
    if (abs(howRecent) < 10.0 && [newLocation horizontalAccuracy] < GPS_ACCURACY_THRESHOLD) {
        [timer invalidate];
        timer = nil;
        [manager stopUpdatingLocation];
        
        [delegate locationManagerDidReceiveLocation:self location:newLocation];
		isUpdating = NO;
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)locationManagerDidTimeout:(NSTimer*)aTimer userInfo:(id)userInfo
{
    timer = nil;
    [locationManager stopUpdatingLocation];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (location) {
        NSDate* eventDate = location.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
		
        if ([location horizontalAccuracy] < 10000 && abs(howRecent) < GPS_TIMEOUT_TIME + 5.0) {
            [delegate locationManagerDidReceiveLocation:self location:location];
            [location release];
            location = nil;
            return;
        }
        [location release];
        location = nil;
    }
    [[ZhiWeiboAppDelegate getAppDelegate] alert:@"获取位置失败" message:@"获取位置操作超时！"];
    [delegate locationManagerDidFail:self];
    isUpdating = NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    
    if (!([error code] == kCLErrorDenied && [[error domain] isEqualToString:kCLErrorDomain])) {
        [[ZhiWeiboAppDelegate getAppDelegate] alert:@"获取位置失败" message:[error localizedDescription]];
    }
    else if ([error code] == kCLErrorLocationUnknown) {
        // Ignore this error and keep tracking
        return;
    }
	
    [timer invalidate];
    timer = nil;
    [location release];
    location = nil;
    [delegate locationManagerDidFail:self];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isUpdating = NO;
}

@end