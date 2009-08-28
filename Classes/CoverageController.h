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


@interface CoverageController : UIViewController {

	
	UIActivityIndicatorView *loadingSpinner;  
	BOOL loadingResults;
	NSMutableData *receivedData;
	NSURLConnection *theConnection;
	
}

@end
