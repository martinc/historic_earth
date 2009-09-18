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

@synthesize remoteHostStatus;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	[application setStatusBarHidden:YES animated:NO];

	
	if(
	   getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")
	   ) {
		NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}

	
	//Store Kit
	
	observer = [[StoreObserver alloc] initWithAppDelegate:self];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
	
	
	//Network Reachability
	
	shownNetworkError = NO;
	haveBeenConnected = NO;
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

	
	//internetReach = [[Reachability reachabilityForInternetConnection] retain];
	hostReach = [[Reachability reachabilityWithHostName: kHOST_DOMAIN_NAME] retain];
	
	//[internetReach startNotifer];
	[hostReach startNotifer];
	
	[self initStatus];

	
	//View Controllers

	//Always give full access now
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSEARCH_ENABLED];
	

/*
#ifdef BETA
	//Give beta testers full access
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSEARCH_ENABLED];
#endif
 */
/*
#ifdef DEBUG
#endif
 
#ifdef RELEASE
#endif
*/	
	
	
	//Fix to see Search in simulator as StoreKit doesn't work
	//#if TARGET_IPHONE_SIMULATOR
	//	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSEARCH_ENABLED];
	//#endif
	


	
	main = [[MainMenuController alloc] initWithStyle:UITableViewStyleGrouped];
	navController = [[UINavigationController alloc] initWithRootViewController: main];
	navController.toolbar.barStyle = navController.navigationBar.barStyle = UIBarStyleBlack;
	navController.toolbar.translucent = navController.navigationBar.translucent = YES;
	//navController.toolbar.tintColor = navController.navigationBar.tintColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.1 alpha:1];
	//viewController.title = @"Historic Earth";
	
	

    // Override point for customization after app launch  
	
	UIImage *bgImage = [UIImage imageNamed:@"paperbackground.png"];
// 	UIImage *bgImage = [UIImage imageNamed:@"vintage-paper.png"];

	UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
	[window	addSubview:bg];
	[bg release];
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
	
	
	/*
	if( ! [[NSUserDefaults standardUserDefaults] boolForKey:kSEARCH_ENABLED] )
	{
		[self requestProductData];
	}
	 */
	
	
	//Server heartbeat
	
	[NSThread detachNewThreadSelector: @selector(serverHeartbeat:) toTarget:self withObject:nil];	

}

- (void) purchasedSearch
{
	if(![[NSUserDefaults standardUserDefaults] boolForKey:kSEARCH_ENABLED]){
	
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSEARCH_ENABLED];
		[navController popToRootViewControllerAnimated:YES];
		[self performSelector:@selector(insertSearch) withObject:nil afterDelay:0.50];
		
	}
}

- (void) insertSearch
{

	[main makeSearchAppear];

	
}

- (void) requestProductData
{
	productsRequest= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: kSEARCH_PRODUCT_ID]];
	productsRequest.delegate = self;
	[productsRequest start];
}


//***************************************
// PRAGMA_MARK: Delegate Methods
//***************************************
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	//NSLog(@"received storekit response");
	
	for(NSString* invalidID in response.invalidProductIdentifiers){
		NSLog(@"Invalid id: %@", invalidID);
	}
	
	
	//NSArray *myProduct = response.products;
	if(products) [products release];
	products = [response.products retain];
	
	
	if([products count] == 1)
	{
		SKProduct* theProduct = [products objectAtIndex:0];
		if([theProduct.productIdentifier isEqualToString:kSEARCH_PRODUCT_ID])
		{
	
			[main addStoreWithProduct: theProduct];
			
			
		}
	}
	
	
	
	//for(SKProduct* validProduct in response.products){
	//	NSLog(@"Valid id: %@", validProduct.productIdentifier);
	//}
	
	
	//[self.tableView reloadData];
	
	[productsRequest release];
	// populate UI
	/*
	 for(int i=0;i<[myProduct count];i++)
	 {
	 SKProduct *product = [myProduct objectAtIndex:i];
	 NSLog(@”Name: %@ - Price: %f”,[product localizedTitle],[[product price] doubleValue]);
	 NSLog(@”Product identifier: %@”, [product productIdentifier]);
	 }
	 */
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
			

		[self showAlertWithText: alertText];
		
		shownNetworkError = YES;
		
		[main disableContent];
		

    }
	else if(shownNetworkError &&  (remoteHostStatus != NotReachable))
	{
		NSString* alertText = @"A network connection has been established.";
	
		[self showAlertWithText: alertText];
	
		shownNetworkError = NO;
		
		[main enableContent];
	}
		
}

- (void) showAlertWithText: (NSString*) thetext
{
	if(!alert){
		alert = [[UIAlertView alloc] initWithTitle:@"Network Status"
										   message:thetext delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	}
	else{
		if(alert.visible){
			[alert dismissWithClickedButtonIndex:0 animated:YES];
		}		
		alert.message = thetext;
	}
	
	[alert show];
	
	
}

#pragma mark AlertView delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alert dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


- (void)dealloc {
	[main release];
    [window release];
	
	[navController release];
	[observer release];
	[hostReach release];
	
	if(alert)
		[alert release];
	if(products)
		[products release];
	if(productsRequest)
		[productsRequest release];
	
    [super dealloc];
}


- (void)serverHeartbeat:(NSString *)poststring
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	heartBeat = [[NSThread currentThread] retain];
	BOOL allGood = YES;
	NSTimer *heartTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(pingServer) userInfo:nil repeats:YES]; 
	
	
	
#ifdef DEBUG
	NSLog(@"starting thread");
#endif
	
	BOOL firstCheck = YES;
	NSDate* lastChecked = [NSDate date];
		
	while(![heartBeat isCancelled] && allGood)
	{
		if(firstCheck || [lastChecked timeIntervalSinceNow] < -60)
		{
#ifdef DEBUG
			NSLog(@"checking server status");
#endif
			
			NSString *serverStatus = [NSString stringWithContentsOfURL:[NSURL URLWithString:kSERVER_STATUS_URL] encoding:NSUTF8StringEncoding error:NULL];
			if(serverStatus != nil)
			{
				if( [serverStatus isEqualToString:@"0"] )
				{
#ifdef DEBUG
					NSLog(@"server not ok");
#endif
					
					
					[self performSelectorOnMainThread:@selector(serverDown)
										   withObject:nil waitUntilDone:NO];
					allGood = NO;
				}
				else{
					
#ifdef DEBUG
					NSLog(@"server ok");
#endif
				}
			}
			
			lastChecked = [NSDate date];
			firstCheck = NO;
		}
		
		if(allGood)
			[NSThread sleepForTimeInterval: 0.25];
		
		
	}
	
	[heartTimer invalidate];
	[pool drain];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
	[heartBeat cancel];
}


- (void) serverDown
{
	
	if(alert)
		[alert release];
	

	
	alert = [[UIAlertView alloc] initWithTitle:@"Adding Maps"
								message:kSERVER_DOWN_TEXT delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	
	[alert show];
	
}


@end
