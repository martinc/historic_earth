//
//  HistoryViewController.h
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

#import "CustomButton.h"
#import "LocateMapsSource.h"
#import "MapViewController.h"

@interface SearchResultsController : TTTableViewController {
	MapViewController *mapController;
	NSMutableArray *listOfItems;
}

//- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;


@end

