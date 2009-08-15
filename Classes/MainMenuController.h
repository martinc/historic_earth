//
//  MainMenuController.h
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultsController.h"
#import "UnlockController.h"


@interface MainMenuController : UITableViewController {
	
	SearchResultsController *searchController;
	UnlockController *unlockController;
	NSMutableArray* mainMenuData;
}

@end
