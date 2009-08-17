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
	
	[super viewWillAppear:animated];
	
	
	if( !dataLoaded ){

		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oldmapapp.com/test/sample.json"]
										  cachePolicy:NSURLRequestUseProtocolCachePolicy
									  timeoutInterval:15.0]];
	}
}
@end
