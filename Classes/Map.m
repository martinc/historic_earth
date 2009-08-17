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


@end
