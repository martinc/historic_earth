//
//  LocationController.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"





@implementation LocationController




- (void) viewWillAppear:(BOOL)animated {
	
	CLLocationCoordinate2D gpsLocation = { 39.95249714905981, -75.16377925872803};
	
	REQUEST_URL = [[NSString alloc] initWithFormat: @"http://www.historicmapworks.com/iPhone/?lat=%f&long=%f", gpsLocation.latitude, gpsLocation.longitude];

	[super viewWillAppear:animated];
	
	
	if( !dataLoaded ){

		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:REQUEST_URL]
										  cachePolicy:NSURLRequestUseProtocolCachePolicy
									  timeoutInterval:15.0]
				   searchLocation: gpsLocation ];
	}
	
//	self.mapController 

}


@end
