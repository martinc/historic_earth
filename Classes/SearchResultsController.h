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

@interface SearchResultsController : UITableViewController {
	MapViewController *mapController;
	NSMutableArray *listOfItems;
}

- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;


@end

