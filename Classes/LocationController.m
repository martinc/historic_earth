//
//  LocationController.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"
#import "TargetConditionals.h"
#import "Locator.h"






@implementation LocationController

@synthesize fromGeographicSearch;

- (id) initWithLocation:(CLLocationCoordinate2D) theLoc
{
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	
	locationManager = [Locator sharedLocationManager];
	[locationManager stopUpdatingLocation];
	
	currentLocation = theLoc;
	haveLoadedLocation = YES;
	fromGeographicSearch = YES;
	
	[self refreshData];
	
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	
	locationManager = [Locator sharedLocationManager];

	
	fromGeographicSearch = NO;
	haveLoadedLocation = NO;
	[self startUpdates];
	
	
	return self;
	
}

- (void)viewDidLoad {

	[super viewDidLoad];
	
	
	if(fromGeographicSearch)
	{
		self.title = @"Location";
		self.statusLabel.text = @"Looking for maps...";
		self.statusLabel.hidden = NO;

	}
	else
	{
		self.title = @"My Location";
		self.statusLabel.text = @"Determining your location...";
		self.statusLabel.hidden = NO;
	}


}


- (void) dealloc
{
	[REQUEST_URL release];
	
	[locationManager stopUpdatingLocation];
	
	if(startedUpdatingTime != nil)
		[startedUpdatingTime release];
	
	if(bestLocation != nil)
		[bestLocation release];

	
	[super dealloc];
}

- (void)startUpdates
{

	locationManager.delegate = self;
	
	startedUpdatingTime = [[NSDate alloc] init];
	[locationManager stopUpdatingLocation];
	[locationManager startUpdatingLocation];
	
	
	[self performSelector:@selector(determineLocation) withObject:nil afterDelay: 4.0 ];
	
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
	
	self.statusLabel.text = @"Looking for maps...";
	self.statusLabel.hidden = NO;
	
	[statusLabel setNeedsDisplay];

	
	if(!fromGeographicSearch){		
		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:REQUEST_URL]
													cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:15.0]
				   searchLocation: currentLocation ];
	}
	else{
		
		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:REQUEST_URL]
													cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:15.0] ];

	}
	
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
	
#ifdef DEBUG
	NSLog(@"received location that is %f seconds old, %f seconds since request, %f circle of accuracy",
		  [newLocation.timestamp timeIntervalSinceNow], [startedUpdatingTime timeIntervalSinceNow], newLocation.horizontalAccuracy);
#endif
	
	if(bestLocation == nil)
	{
		bestLocation = [newLocation retain];
	}
	
	BOOL accuracyIsBetter = newLocation.horizontalAccuracy < bestLocation.horizontalAccuracy;
	BOOL accuracyIsBetterOrEqual = newLocation.horizontalAccuracy <= bestLocation.horizontalAccuracy;
	BOOL isNotAncient = fabs([bestLocation.timestamp timeIntervalSinceNow]) < 5.0;
	BOOL newLocIsReallyNewer = fabs([newLocation.timestamp timeIntervalSinceNow]) < fabs([bestLocation.timestamp timeIntervalSinceNow]);

#ifdef DEBUG
	NSLog(@"accuracyIsBetter? %d accuracyIsBetterOrEqual? %d isNotAncient? %d newLocIsReallyNewer? %d", accuracyIsBetter, accuracyIsBetterOrEqual, isNotAncient, newLocIsReallyNewer);
#endif
	
	
		if( !haveLoadedLocation || 
		   isNotAncient &&
		   (accuracyIsBetter ||
		   (accuracyIsBetterOrEqual && newLocIsReallyNewer) ) )
		{
	#ifdef DEBUG
			NSLog(@"setting location");
	#endif
			
			haveLoadedLocation = YES;
			[bestLocation release];
			bestLocation = [newLocation retain];
			currentLocation = newLocation.coordinate;
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

- (void) determineLocation
{
	
	if(haveLoadedLocation)
	{
		[locationManager stopUpdatingLocation];
		[self refreshData];
	}
	else
	{
		if(fabs([startedUpdatingTime timeIntervalSinceNow]) > 30.0)
		{
			statusLabel.hidden = NO;
			statusLabel.text = @"Could not determine location.";
			[loadingSpinner stopAnimating];
		}
		else
		{
			[self performSelector:@selector(determineLocation) withObject:nil afterDelay: 4.0];
		}

	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	statusLabel.hidden = YES;
	
	[super connectionDidFinishLoading:connection];
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	
	//can ignore kCLErrorLocationUnknown
	
	if([error code] == kCLErrorDenied)
	{
		
		[locationManager stopUpdatingLocation];
		
		UIAlertView* locationDeniedAlert = [[UIAlertView alloc] initWithTitle:@"Location Required"
																		message:@"In order to use the Map My Location feature, Historic Earth needs to be allowed to access your location."
																	   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		
		[locationDeniedAlert show];	
		[locationDeniedAlert release];
		
				
	}
	
	//kCLErrorDenied 
	
	//kCLErrorHeadingFailure
	
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//send back to main menu after location denied
	
	
	[self.navigationController popToRootViewControllerAnimated: YES];
	
	
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
