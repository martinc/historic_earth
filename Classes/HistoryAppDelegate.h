//
//  HistoryAppDelegate.h
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuController.h"


@interface HistoryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController* navController;
	MainMenuController* menu;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

