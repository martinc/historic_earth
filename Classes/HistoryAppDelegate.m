//
//  HistoryAppDelegate.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "HistoryAppDelegate.h"
#import "AbstractMapListController.h"
#import "Locator.h"




@implementation HistoryAppDelegate

@synthesize window;

@synthesize remoteHostStatus;

@synthesize inMemoryStore;
@synthesize diskStore;

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
	
	
	//Core Data
	
	managedObjectContext = [self managedObjectContext];
    if (!managedObjectContext) {
        // Handle the error.
    }
    // Pass the managed object context to the view controller.
    //rootViewController.managedObjectContext = context;
	
	
	
	
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
	
	serverRunning = YES;
	
	[NSThread detachNewThreadSelector: @selector(serverHeartbeat:) toTarget:self withObject:nil];	
	
	
	[Appirater appLaunched];

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
	NSTimer *heartTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(pingServer) userInfo:nil repeats:YES]; 
	
	
	
#ifdef DEBUG
	NSLog(@"starting thread");
#endif
	
	BOOL firstCheck = YES;

	NSDate* lastChecked = [NSDate date];
		
	while(![heartBeat isCancelled])
	{
		if(firstCheck || [lastChecked timeIntervalSinceNow] < -60)
		{
#ifdef DEBUG
			NSLog(@"checking server status");
#endif
			
			NSString *serverStatus = [NSString stringWithContentsOfURL:[NSURL URLWithString:kSERVER_STATUS_URL] encoding:NSUTF8StringEncoding error:NULL];
			if(serverStatus != nil)
			{
				if( serverRunning == YES && [[serverStatus stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  hasPrefix:@"0"] )
				{
#ifdef DEBUG
					NSLog(@"server not ok");
#endif
					
					serverRunning = NO;


					[self performSelectorOnMainThread:@selector(serverDown)
										   withObject:nil waitUntilDone:NO];
				}
				else if( serverRunning == NO && [[serverStatus stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  hasPrefix:@"1"] )
				{
					serverRunning = YES;
					
					[self performSelectorOnMainThread:@selector(serverUp)
										   withObject:nil waitUntilDone:NO];

					
				}
				/*
				else{
					
#ifdef DEBUG
					NSLog(@"server ok");
#endif
				}
				 */
			}
			
			lastChecked = [NSDate date];
			firstCheck = NO;
		}
		
		//if(valueChanged)
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
	
	[main disableContent];
	[navController popToRootViewControllerAnimated:YES];

	
	if(alert)
		[alert release];
	
	
	alert = [[UIAlertView alloc] initWithTitle:@"Adding Maps"
								message:kSERVER_DOWN_TEXT delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	
	[alert show];
	
}



- (void) serverUp
{
	
	[main enableContent];
	[navController popToRootViewControllerAnimated:YES];
	
	
	if(alert)
		[alert release];
	
	
	alert = [[UIAlertView alloc] initWithTitle:@"Server Back"
									   message:@"Historic Earth server access has been restored." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	
	[alert show];
	
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"HistorcEarthData.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	diskStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
    if (!diskStore) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//abort();
    }
	
	error = nil;
	
	//Ignore that it is called an "NSPersistentStore", it is not persisted
	inMemoryStore = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error];
	
	if (inMemoryStore && !error) {
		//It is setup
	}
	else {
		NSLog(@"Unresolved error with memory store %@, %@", error, [error userInfo]);

	}

	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



@end
