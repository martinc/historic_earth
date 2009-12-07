//
//  MainMenuController.h
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "LocationController.h"
#import "SearchController.h"
#import "UnlockController.h"
#import "FeaturedController.h"
#import "SettingsController.h"
#import "AboutController.h"
#import "CoverageController.h"
#import "PurchaseController.h"
#import "HelpController.h"
#import "FavoritesController.h"


@interface MainMenuController : UITableViewController {
	
	BOOL contentEnabled;
	
	NSMutableArray* mainMenuData;
	NSMutableDictionary* searchData;
	NSMutableDictionary* additionContentData;
	
	BOOL searchVisible;
	
	SKProduct* product;
}

-(void) makeSearchAppear;

-(void) addStoreWithProduct: (SKProduct *) theProduct;

-(void) enableContent;

-(void) disableContent;



@end
