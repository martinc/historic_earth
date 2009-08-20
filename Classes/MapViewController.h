//
//  MapViewController.h
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"
#import "RMCloudMadeMapSource.h"
#import "RMOpenStreetMapSource.h"
#import "RMGenericMercatorWMSSource.h"
#import "Map.h"
#import "RMMarkerManager.h"
#import "InfoController.h"



@interface MapViewController : UIViewController {
	
	RMMapView *oldMapView, *modernMapView;
	
	float currentRoation;
	NSMutableArray *maps;
	int currentMapIndex;
	NSMutableArray *mapViews;
	
	UISlider* slider;
	UIActivityIndicatorView *spinner;
	UIBarButtonItem* backForward;
	UIBarButtonItem* barSpinner;
	UISegmentedControl* segmented;
	
	BOOL hasTouchMoved;
	
	BOOL showingMarker;
	CLLocationCoordinate2D markerLocation;
	
	RMMarker* theMarker;
	
	UIButton* infoButton;
	
	InfoController* infoController;
	
	BOOL locked;
	BOOL compassEnabled;
}

- (id) initWithMaps: (NSMutableArray *) theMaps;

- (void) loadMapAtIndex: (int) theIndex;
- (void) loadMapAtIndex: (int) theIndex withMarkerLocation: (CLLocationCoordinate2D) loc;

- (void) updateArrows;

-(void) updateSettings: (NSNotification *)notification;


@end
