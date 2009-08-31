//
//  Map.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


@implementation Map

@synthesize layerID, atlasName, name, year, minZoom, mapBounds, mapCenter;

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


@end
