//
//  Map.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


@implementation Map

@synthesize layerID, atlasName, name, year, minZoom, mapBounds, mapCenter, initialOpacity, plates;

- (id) init
{
	self = [super init];
	initialOpacity = 1.0;
	
	plates = [[NSMutableArray alloc] initWithCapacity:1];
	
	return self;
}
- (void) setMapBounds:(RMSphericalTrapezium) newMapBounds
{
	
	mapBounds = newMapBounds;
	
	mapCenter.longitude = (mapBounds.northeast.longitude + mapBounds.southwest.longitude) / 2.0;
	mapCenter.latitude = (mapBounds.northeast.latitude + mapBounds.southwest.latitude) / 2.0;
	
}

- (NSComparisonResult) mapOrder: (Map *) anotherMap
{
	if(year < anotherMap.year)
	{
		return NSOrderedAscending;
	}
	else if(year > anotherMap.year)
	{
		return NSOrderedDescending;
	}
	
	return [name caseInsensitiveCompare:anotherMap.name];
	
}

- (void) shufflePlateOrder
{
	NSMutableArray* components = [NSMutableArray arrayWithArray:[self.layerID componentsSeparatedByString:@","]];
	
	if([components count] > 1)
	{
		NSString* topLayer = [[components objectAtIndex:0] retain];
		[components removeObjectAtIndex:0];
		[components addObject:topLayer];
		[topLayer release];
		
		self.layerID = [components componentsJoinedByString:@","];
	}
	
	
}

- (int) plateCount
{
	return [[self.layerID componentsSeparatedByString:@","] count];
}


- (void)dealloc {
	
	[plates release];
	
	if(atlasName)
		[atlasName release];
	if(name)
		[name release];
	if(layerID)
		[layerID release];
	
    [super dealloc];
}

@end
