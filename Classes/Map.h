//
//  Map.h
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapView.h"



@interface Map : NSObject {
	
	
	NSString *layerID, *atlasName, *name;
	
	int year, minZoom;
	
	RMSphericalTrapezium mapBounds;
	
	CLLocationCoordinate2D mapCenter;
	
}


- (NSComparisonResult) mapOrder: (Map *) anotherMap;


@property (nonatomic, retain) NSString *layerID;
@property (nonatomic, retain) NSString *atlasName;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, assign) int year;
@property (nonatomic, assign) int minZoom;
@property (nonatomic, assign) RMSphericalTrapezium mapBounds;
@property (nonatomic, readonly) CLLocationCoordinate2D mapCenter;


@end
