//
//  MapViewController.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-1.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "Status.h"
#import "StatusAnnotation.h"

@interface MapViewController : UIViewController<MKReverseGeocoderDelegate> {
	MKMapView *mapView;
	MKReverseGeocoder *geoCoder;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (void)centerMapOn:(CLLocation *)location;

- (void)showMap:(double)latitude longitude:(double)longitude;

- (void)showStatus:(Status *)status;

@end
