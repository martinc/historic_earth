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

	
	UIActivityIndicatorView *loadingSpinner;  
	NSMutableArray *groups;
	
	BOOL loadingResults;
	
	NSMutableData *receivedData;
	
	NSURLConnection *theConnection;
	
	
}

@end
