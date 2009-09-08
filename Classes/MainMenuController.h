//
//  MainMenuController.h
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import "SearchController.h"
#import "UnlockController.h"
#import "FeaturedController.h"
#import "SettingsController.h"
#import "AboutController.h"
#import "CoverageController.h"


@interface MainMenuController : UITableViewController {
	
	
	NSMutableArray* mainMenuData;
	NSMutableDictionary* searchData;
	NSMutableDictionary* additionContentData;
	
	BOOL searchVisible;
}

-(void) makeSearchAppear;

@end
