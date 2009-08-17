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
#import "Map.h"

@interface AbstractMapListController : UITableViewController <TTURLRequestDelegate> {
	MapViewController *mapController;
	UIActivityIndicatorView *loadingSpinner;  
	
	NSMutableArray *maps;
	
	NSMutableData *receivedData;
	
	BOOL loadingResults;
	BOOL dataLoaded;
}


- (void) loadDataWithRequest: (NSURLRequest *) theRequest;

- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;


@end

