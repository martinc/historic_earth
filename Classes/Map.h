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
	
	float initialOpacity;
	
	RMSphericalTrapezium mapBounds;
	
	CLLocationCoordinate2D mapCenter;
	
	NSMutableArray *plates;
	
}


- (NSComparisonResult) mapOrder: (Map *) anotherMap;

- (void) shufflePlateOrder;

- (int) plateCount;



@property (nonatomic, readonly) NSMutableArray *plates;


@property (nonatomic, copy) NSString *layerID;
@property (nonatomic, copy) NSString *atlasName;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int year;
@property (nonatomic, assign) int minZoom;
@property (nonatomic, assign) RMSphericalTrapezium mapBounds;
@property (nonatomic, readwrite) CLLocationCoordinate2D mapCenter;

@property (nonatomic, assign) float initialOpacity;


@end
