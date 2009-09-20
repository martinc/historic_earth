//
//  LocationController.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"
#import "TargetConditionals.h"






@implementation LocationController


- (id) initWithLocation:(CLLocationCoordinate2D) theLoc
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	currentLocation = theLoc;
	
	haveLoadedLocation = YES;
	
	fromGeographicSearch = YES;
	
	[self refreshData];
	
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	
	fromGeographicSearch = NO;
	haveLoadedLocation = NO;
	[self startUpdates];
	
	
	return self;
	
}


- (void) dealloc
{
	[REQUEST_URL release];
	
	[locationManager stopUpdatingLocation];
	
	[locationManager release];

	
	[super dealloc];
}

- (void)startUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
	
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
    // Set a movement threshold for new events
    locationManager.distanceFilter = kCLDistanceFilterNone;
	
	
	
	[locationManager startUpdatingLocation];

	/*
	if (locationManager.headingAvailable)
	{
		locationManager.headingFilter = 5;
		[locationManager startUpdatingHeading];
	}
	 */
	
}

- (void)refreshData
{
	
#if TARGET_IPHONE_SIMULATOR
	//Sample Data
	if(! fromGeographicSearch)
	{
		currentLocation.longitude = -74.013;
		currentLocation.latitude =  40.705;
	}
#endif
	
	REQUEST_URL = [[NSString alloc] initWithFormat: @"%@lat=%f&long=%f", kLAT_LONG_SEARCH,
				   currentLocation.latitude, currentLocation.longitude];
	
#ifdef DEBUG
	NSLog(REQUEST_URL);
#endif
			
		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:REQUEST_URL]
													cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:15.0]
				   searchLocation: currentLocation ];
	
}

- (void) refreshWithLocation: (CLLocationCoordinate2D) theLocation
{
//Override to stop location manager updates
	
	[super refreshWithLocation: theLocation];
	
	[locationManager stopUpdatingLocation];
	
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	
	currentLocation = newLocation.coordinate;
	
	if(!haveLoadedLocation){
		haveLoadedLocation = YES;
		[self refreshData];		
	}
    // If it's a relatively recent event, turn off updates to save power
 /*   NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0)
    {
        [manager stopUpdatingLocation];
		
        printf("latitude %+.6f, longitude %+.6f\n",
			   newLocation.coordinate.latitude,
			   newLocation.coordinate.longitude);
    }
  */
    // else skip the event and process the next one.
}





- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading
{
	// If the accuracy is valid, go ahead and process the event.
	if (newHeading.headingAccuracy > 0)
	{
		//CLLocationDirection theHeading = newHeading.magneticHeading;
		
		// Do something with the event data.
	}
}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger row = indexPath.row;
    if (row != NSNotFound) {
		
		[mapController loadMapAtIndex: indexPath.row withLocationManager: locMan];
		
        [[self navigationController] pushViewController:mapController animated:YES];
		
    }
	
}
 */



@end
