//
//  HistoryViewController.h
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomButton.h"
#import "MapViewController.h"
#import "Three20/Three20.h"
#import "Map.h"

@interface AbstractMapListController : UITableViewController <TTURLRequestDelegate> {
	MapViewController *mapController;
	UIActivityIndicatorView *loadingSpinner;  
	
	NSMutableArray *maps;
	
	NSMutableArray* smallMaps;
	NSMutableArray* mediumMaps;
	NSMutableArray* largeMaps;
	
	NSMutableArray* currentMapList;

	
	NSMutableData *receivedData;
	
	BOOL loadingResults;
	BOOL dataLoaded;
	BOOL haveLocation;
	
	CLLocationCoordinate2D searchLocation;
	
	NSURLConnection *theConnection;
	
	UILabel *statusLabel;
	
	UISegmentedControl* mapFilter;
	

}

@property (nonatomic,readonly) UILabel* statusLabel;

@property (nonatomic, readonly) NSMutableArray* currentMapList;

- (void) refreshWithLocation: (CLLocationCoordinate2D) theLocation;

- (void) loadDataWithRequest: (NSURLRequest *) theRequest;
- (void) loadDataWithRequest: (NSURLRequest *) theRequest searchLocation: (CLLocationCoordinate2D) loc;

//- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;


@end

