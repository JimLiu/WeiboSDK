//
//  MapViewController.m
//  ZhiWeibo
//
//  Created by junmin liu on 10-12-1.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController
@synthesize mapView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
}

#pragma mark -
#pragma mark MKMapView Methods

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)centerMapOn:(CLLocation *)location {
	
	if(mapView != nil)
	{
		MKCoordinateSpan span = {latitudeDelta: 0.00500, longitudeDelta: 0.00500};
		MKCoordinateRegion region = {location.coordinate, span};
		[self.mapView setRegion:region];
	}
	 
}

- (void)showMap:(double)latitude longitude:(double)longitude {
	
	CLLocation *location = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
	[self centerMapOn:location];
	
}

- (void)showStatus:(Status *)status {
	CLLocation *location = [[[CLLocation alloc] initWithLatitude:status.latitude longitude:status.longitude] autorelease];
	[self centerMapOn:location];
	
	
	StatusAnnotation *pin = [[StatusAnnotation alloc] initWithCoordinate:location.coordinate];
	pin.title = status.text;
	pin.subtitle = [NSString stringWithFormat:@"@%@", status.user.screenName];
	[self.mapView addAnnotation:pin];
	[pin release];
	 
	[geoCoder release];
	geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
	geoCoder.delegate=self;
	[geoCoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	NSLog(@"Reverse Geocoder Errored");
	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"Reverse Geocoder completed");
	[mapView addAnnotation:placemark];
}

- (void)dealloc {
	[geoCoder release];
    [super dealloc];
}


@end
