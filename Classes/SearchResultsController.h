//
//  HistoryViewController.h
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "MapViewController.h"
#import "Three20/Three20.h"

@interface SearchResultsController : UITableViewController <TTURLRequestDelegate> {
	MapViewController *mapController;
	NSMutableArray *listOfItems;
	NSMutableArray *listOfImages;
	UIActivityIndicatorView *loadingSpinner;  
	
	NSMutableData *receivedData;
	
	BOOL loadingResults;
}

- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;


@end

