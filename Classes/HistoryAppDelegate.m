//
//  HistoryAppDelegate.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "HistoryAppDelegate.h"
#import "AbstractMapListController.h"

@implementation HistoryAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	[application setStatusBarHidden:YES animated:NO];

	
	if(
	   getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")
	   ) {
		NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	
	observer = [[StoreObserver alloc] init];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
	
	
	
	
	
	
	main = [[MainMenuController alloc] initWithStyle:UITableViewStyleGrouped];
	
	navController = [[UINavigationController alloc] initWithRootViewController: main];
	
	navController.toolbar.barStyle = navController.navigationBar.barStyle = UIBarStyleBlack;
	navController.toolbar.translucent = navController.navigationBar.translucent = YES;
//	navController.navigationBar.alpha = 1.0;
//	navController.navigationBar.tintColor = [UIColor brownColor];
	//0.6, 0.4, 0.2 brown
	navController.toolbar.tintColor = navController.navigationBar.tintColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.1 alpha:1];
	//viewController.title = @"Historic Earth";
	
	

    // Override point for customization after app launch  
	
	UIImage *bgImage = [UIImage imageNamed:@"paperbackground.png"];
	UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
	[window	addSubview:bg];
	[bg release];
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[main release];
    [window release];
    [super dealloc];
}


@end
