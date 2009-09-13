//
//  CoverageController.h
//  History
//
//  Created by Martin Ceperley on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMMapView.h"
#import "RMOpenStreetMapSource.h"
#import "RMPath.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"

@interface CoverageController : UIViewController {

	
	BOOL loadingResults;
	NSMutableData *receivedData;
	NSURLConnection *theConnection;
	
	
	UIActivityIndicatorView *loadingSpinner;  
	RMMapView* mapView;
	NSMutableArray* paths;
	UIBarButtonItem* refreshButton;
}


- (void) setRefreshButtonHidden: (BOOL) hidden;

@end
