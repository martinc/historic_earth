//
//  FeaturedLocationController.h
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractMapListController.h"
#import "Location.h"


@interface FeaturedLocationController : AbstractMapListController {

	NSMutableArray* locations;
	int currentLocationIndex;
	
	UINavigationController* navController;
	
}

- (void) loadData;

- (id)initWithLocations: (NSMutableArray *) locs atIndex: (int) theIndex withNavController: (UINavigationController *) theNavController;

@end
