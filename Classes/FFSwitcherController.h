//
//  FFSwitcherController.h
//  History
//
//  Created by Martin Ceperley on 12/8/09.
//  Copyright 2009 Emergence Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedController.h"
#import "FavoritesController.h"


@interface FFSwitcherController : UIViewController {
	
	FeaturedController* featured;
	FavoritesController* favorites;
	
	UISegmentedControl* switcher;
	
	int initialSegment;
	
	BOOL firstLoad;
	
	UIViewController* currentController;
}

-(CGRect) correctedRect;

-(void) updateView;


@end
