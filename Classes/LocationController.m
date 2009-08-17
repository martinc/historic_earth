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
	
	REQUEST_URL = @"http://www.historicmapworks.com/iPhone/?lat=39.95249714905981&long=-75.16377925872803";

	[super viewWillAppear:animated];
	
	
	if( !dataLoaded ){

		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:REQUEST_URL]
										  cachePolicy:NSURLRequestUseProtocolCachePolicy
									  timeoutInterval:15.0]];
	}
}
@end
