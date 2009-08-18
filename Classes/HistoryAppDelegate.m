//
//  HistoryAppDelegate.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "HistoryAppDelegate.h"
#import "AbstractMapListController.h"


#define kHostName @"www.historicmapworks.com"


@implementation HistoryAppDelegate

@synthesize window;

@synthesize remoteHostStatus;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	[application setStatusBarHidden:YES animated:NO];

	
	if(
	   getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")
	   ) {
		NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}

	
	//Store Kit
	
	observer = [[StoreObserver alloc] init];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
	
	
	//Network Reachability
	
	shownNetworkError = NO;
	haveBeenConnected = NO;
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

	
	//internetReach = [[Reachability reachabilityForInternetConnection] retain];
	hostReach = [[Reachability reachabilityWithHostName: kHostName] retain];
	
	//[internetReach startNotifer];
	[hostReach startNotifer];
	
	[self initStatus];

	
	//View Controllers

	
	main = [[MainMenuController alloc] initWithStyle:UITableViewStyleGrouped];
	navController = [[UINavigationController alloc] initWithRootViewController: main];
	navController.toolbar.barStyle = navController.navigationBar.barStyle = UIBarStyleBlack;
	navController.toolbar.translucent = navController.navigationBar.translucent = YES;
	//navController.toolbar.tintColor = navController.navigationBar.tintColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.1 alpha:1];
	//viewController.title = @"Historic Earth";
	
	

    // Override point for customization after app launch  
	
	UIImage *bgImage = [UIImage imageNamed:@"paperbackground.png"];
	UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
	[window	addSubview:bg];
	[bg release];
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
}


- (void)reachabilityChanged:(NSNotification *)note {
    [self updateStatus];
}


-(void)initStatus {
    remoteHostStatus = [hostReach currentReachabilityStatus];
	if(remoteHostStatus != NotReachable)
		haveBeenConnected = YES;

   // internetConnectionStatus    = [internetReach currentReachabilityStatus];
}

- (void)updateStatus
{
    // Query the SystemConfiguration framework for the state of the device's network connections.
    remoteHostStatus = [hostReach currentReachabilityStatus];
	if(remoteHostStatus != NotReachable)
		haveBeenConnected = YES;

   // internetConnectionStatus    = [internetReach currentReachabilityStatus];
  //  NSLog(@"remote status = %d, internet status = %d", remoteHostStatus, internetConnectionStatus);
    if (remoteHostStatus == NotReachable && !shownNetworkError){

		NSString* alertText;
		if(!haveBeenConnected)
			alertText = @"A network connection, which is required, could not be established.";
		else 
			alertText = @"The network connection has been lost.";
			
			
		alert = [[UIAlertView alloc] initWithTitle:@"Network Status"
														message:alertText delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
		
		shownNetworkError = YES;

    }
	else if(shownNetworkError &&  (remoteHostStatus != NotReachable))
	{
		NSString* alertText = @"A network connection has been established.";
		alert = [[UIAlertView alloc] initWithTitle:@"Network Status"
														message:alertText delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
		
		shownNetworkError = NO;
	}
		
}

#pragma mark AlertView delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alert release];
}


- (void)dealloc {
	[main release];
    [window release];
    [super dealloc];
}




@end
