//
//  HistoryAppDelegate.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "HistoryAppDelegate.h"
#import "SearchResultsController.h"

@implementation HistoryAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	[application setStatusBarHidden:YES animated:NO];
	
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];

	
	MainMenuController* main = [[MainMenuController alloc] initWithStyle:UITableViewStyleGrouped];
	
	navController = [[UINavigationController alloc] initWithRootViewController: main];
	
	navController.navigationBar.barStyle = UIBarStyleBlack;
	navController.navigationBar.translucent = YES;
//	navController.navigationBar.alpha = 1.0;
//	navController.navigationBar.tintColor = [UIColor brownColor];
	//0.6, 0.4, 0.2 brown
	navController.navigationBar.tintColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.1 alpha:1];
	//viewController.title = @"Historic Earth";
	
	

    // Override point for customization after app launch  
	
	UIImage *bgImage = [UIImage imageNamed:@"paperbackground.png"];
	UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
	[window	addSubview:bg];
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
   // [viewController release];
    [window release];
    [super dealloc];
}


@end
