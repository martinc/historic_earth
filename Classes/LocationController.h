//
//  LocationController.h
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractMapListController.h"
#import <CoreLocation/CoreLocation.h>



@interface LocationController : AbstractMapListController <CLLocationManagerDelegate, UIAlertViewDelegate> {

	NSString *REQUEST_URL;
	
	CLLocationManager *locationManager;
	
	CLLocation *bestLocation;
	CLLocationCoordinate2D currentLocation;
	
	BOOL haveLoadedLocation;
	
	BOOL fromGeographicSearch;
	
	NSDate *startedUpdatingTime;

}

- (void)startUpdates;

- (id) initWithLocation:(CLLocationCoordinate2D) theLoc;

- (void)refreshData;

@end
