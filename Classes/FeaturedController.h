//
//  FeaturedController.h
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "FeaturedLocationController.h"
#import "LocationGroup.h"


@interface FeaturedController : UITableViewController {

	
	NSMutableArray *groups;

	
	UIActivityIndicatorView *loadingSpinner;  
	BOOL loadingResults;
	NSMutableData *receivedData;
	NSURLConnection *theConnection;
	
	
}

@end
