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
#import "Location.h"


@interface FeaturedController : UITableViewController {

	
	UIActivityIndicatorView *loadingSpinner;  
	NSMutableArray *locations;
	
	FeaturedLocationController *featuredLocationController;
	
	BOOL loadingResults;
	
	NSMutableData *receivedData;
	
	NSURLConnection *theConnection;
	
	
}

@end
