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
#import "LenientUISlider.h"



@interface MapViewController : UIViewController <CLLocationManagerDelegate> {
	
	RMMapView *oldMapView, *modernMapView, *fadingOutView;
	
	NSMutableArray *maps;
	int currentMapIndex;
	NSMutableArray *mapViews;
	
	LenientUISlider* slider;
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
	
	CLLocationManager *locationManager;
	
	BOOL compassRunning;
	
	UIImageView *compassIndicator;
	
	
//	double targetRotation;
	double currentRotation;
//	double rotationVelocity
//	double rotationAcceleration;
	
	
}

- (id) initWithMaps: (NSMutableArray *) theMaps;

- (void) loadMapAtIndex: (int) theIndex;
- (void) loadMapAtIndex: (int) theIndex withMarkerLocation: (CLLocationCoordinate2D) loc;

- (void) updateArrows;

-(void) updateSettings: (NSNotification *)notification;

- (void) rotateToHeading:(double)inputHeading animated:(BOOL)isAnimated;

- (void) hideChrome;
- (void) showChrome;



-(void) stopCompass;
-(void) startCompass;

@end
