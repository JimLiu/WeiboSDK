//
//  PostAnnotation.h
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-1.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface StatusAnnotation : NSObject<MKAnnotation> {
	NSString *title;
	NSString *subtitle;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
