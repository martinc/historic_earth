//
//  Map.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map.h"
#import "HistoryAppDelegate.h"


@implementation Map

@synthesize layerID, atlasName, name, year, minZoom, mapBounds, mapCenter, initialOpacity, plates, diagonal, initialZoom;

- (id) init
{
	
	NSManagedObjectContext* theContext = [(HistoryAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

	self = [NSEntityDescription insertNewObjectForEntityForName:@"Map" inManagedObjectContext:theContext];
	initialOpacity = 1.0;
	initialZoom = -1;
	
	plates = [[NSMutableArray alloc] initWithCapacity:1];
	
	return self;
}



float initialResolution = 2 * M_PI * 6378137 / 256;
float originShift = 2 * M_PI * 6378137 / 2.0;


 
 // Converts given lat/lon in WGS84 Datum to XY in Spherical Mercator EPSG:3857 
 -(CGPoint) LatLonToMeters: (CLLocationCoordinate2D) latlon 
 { 
	 CGPoint meters; 
	 meters.x = latlon.longitude * originShift / 180.0; 
	 meters.y = (log( tan((90.0 + latlon.latitude) * M_PI / 360.0 )) / (M_PI / 180.0)) * originShift / 180.0; 
	 return meters; 
 }


-(int) bestZoomForDiagonal: (float) d
{
	
	/*
	 16 = d < 3000
	 15 = d < 6000
	 14 = d < 10,000
	 13 = d < 30,000
	 12 = d < 60,000
	 11 = d < 100,000
	 10 = d < 150,000
	 9 = d < 200,000
	 8 = d < 600,000
	 7 = d < 1,000,000
	 6 = d < 3,000,000
	 5 = d < 6,000,000
	 4 = d < 10,000,000
	 3 = d < 30,000,000
	 2 = d < 60,000,000
	 1 = d >= 60,000,000
	 */
	
	
	int theZoom;

	
	if(d < 3000)
		theZoom = 16;
	else if(d < 6000)
		theZoom = 15;
	else if(d < 10000)
		theZoom = 14;
	else if(d < 30000)
		theZoom = 13;
	else if(d < 60000)
		theZoom = 12;
	else if(d < 100000)
		theZoom = 11;
	else if(d < 150000)
		theZoom = 10;
	else if(d < 200000)
		theZoom = 9;
	else if(d < 600000)
		theZoom = 8;
	else if(d < 1000000)
		theZoom = 7;
	else if(d < 3000000)
		theZoom = 6;
	else if(d < 6000000)
		theZoom = 5;
	else if(d < 10000000)
		theZoom = 4;
	else if(d < 30000000)
		theZoom = 3;
	else if(d < 60000000)
		theZoom = 2;
	else
		theZoom = 1;
	
	return theZoom;

	
}


- (void) setMapBounds:(RMSphericalTrapezium) newMapBounds
{
	[self willChangeValueForKey:@"mapBounds"];
	mapBounds = newMapBounds;
	[self didChangeValueForKey:@"mapBounds"];

	[self willChangeValueForKey:@"mapCenter"];
	mapCenter.longitude = (mapBounds.northeast.longitude + mapBounds.southwest.longitude) / 2.0;
	mapCenter.latitude = (mapBounds.northeast.latitude + mapBounds.southwest.latitude) / 2.0;
	[self didChangeValueForKey:@"mapCenter"];


	
	CGPoint neXY = [self LatLonToMeters:mapBounds.northeast];
	CGPoint swXY = [self LatLonToMeters:mapBounds.southwest];
	
	float sumDistanceSquared = ((neXY.x-swXY.x)*(neXY.x-swXY.x)
								+(neXY.y-swXY.y)*(neXY.y-swXY.y));
	
	float metersDiagonal = sqrt(sumDistanceSquared);
	
	
	initialZoom = [self bestZoomForDiagonal: metersDiagonal];

	
	
	diagonal = metersDiagonal;
	

	
#ifdef DEBUG
	NSLog(@"map diagonal is %f, current minZoom is %d, calculated zoom is %d", metersDiagonal, minZoom, initialZoom);
#endif
	
	
	
	
	NSManagedObjectContext* theContext = [(HistoryAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		
	
	NSManagedObject *theMapOrigin = [NSEntityDescription insertNewObjectForEntityForName:@"Vector" inManagedObjectContext:theContext];
	NSManagedObject *theMapSize = [NSEntityDescription insertNewObjectForEntityForName:@"Vector" inManagedObjectContext:theContext];

	[theMapOrigin setValue:[NSNumber numberWithDouble: mapBounds.northeast.longitude] forKey:@"x"];
	[theMapOrigin setValue:[NSNumber numberWithDouble:mapBounds.northeast.latitude] forKey:@"y"];
	[theMapSize setValue:[NSNumber numberWithDouble:mapBounds.southwest.longitude] forKey:@"x"];
	[theMapSize setValue:[NSNumber numberWithDouble:mapBounds.southwest.latitude] forKey:@"y"];
	
	NSManagedObject *theMapRect = [NSEntityDescription insertNewObjectForEntityForName:@"Rectangle" inManagedObjectContext:theContext];
	
	[theMapRect setValue:theMapOrigin forKey:@"origin"];
	[theMapRect setValue:theMapSize forKey:@"size"];
	
	[self setValue:theMapRect forKey:@"mapBoundsRect"];
	
	
	NSManagedObject *theMapCenter = [NSEntityDescription insertNewObjectForEntityForName:@"Vector" inManagedObjectContext:theContext];
	[theMapCenter setValue:[NSNumber numberWithDouble:mapCenter.longitude] forKey:@"x"];
	[theMapCenter setValue:[NSNumber numberWithDouble:mapCenter.latitude] forKey:@"y"];

	
	[self setValue:theMapCenter forKey:@"mapCenterVector"];

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

- (void)setNilValueForKey:(NSString *)theKey
{
    if ([theKey isEqualToString:@"mapBounds"]) {
		mapBounds.northeast.latitude = 0.0;
		mapBounds.northeast.longitude = 0.0;
		mapBounds.southwest.latitude = 0.0;
		mapBounds.southwest.longitude = 0.0;
    }
    else if ([theKey isEqualToString:@"mapCenter"]) {
		mapCenter.longitude = 0.0;
		mapCenter.latitude = 0.0;
    }
	else
        [super setNilValueForKey:theKey];
}
 

/*
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
 */

@end
