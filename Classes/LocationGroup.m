//
//  LocationGroup.m
//  History
//
//  Created by Martin Ceperley on 8/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationGroup.h"


@implementation LocationGroup

@synthesize name, locations;


- (id) initWithDictionary: (NSDictionary *) jsonData
{
	self = [super init];
	
	locations = [[NSMutableArray alloc] init];
	
	name = [[jsonData objectForKey:@"Group"] retain];
	NSArray* locs = [jsonData objectForKey:@"Locations"];
	
	//NSLog(@"creating group %@", name);
	
	for(NSDictionary* theLoc in locs)
	{
		NSString* theLocName = [theLoc objectForKey:@"Name"];
		int theLocID = [[theLoc objectForKey:@"ID"] intValue];
		
		Location* theLocation = [[Location alloc] initWithName:theLocName andID:theLocID];
		[locations addObject:theLocation];
		
		//NSLog(@"creating location %@", theLocName);

		
		[theLocation release];
	}
	
	return self;
	
	
}

@end
