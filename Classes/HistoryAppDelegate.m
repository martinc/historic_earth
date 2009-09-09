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
	


#ifdef BETA
	//Give beta testers full access
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSEARCH_ENABLED];
#endif
/*
#ifdef DEBUG
#endif
 
#ifdef RELEASE
#endif
*/	
	
	
	//Fix to see Search in simulator as StoreKit doesn't work
	#if TARGET_IPHONE_SIMULATOR
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSEARCH_ENABLED];
	#endif
	


	
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
	
	
	if( ! [[NSUserDefaults standardUserDefaults] boolForKey:kSEARCH_ENABLED] )
	{
		[self requestProductData];
	}

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

    }
	else if(shownNetworkError &&  (remoteHostStatus != NotReachable))
	{
		NSString* alertText = @"A network connection has been established.";
	
		[self showAlertWithText: alertText];
	
		shownNetworkError = NO;
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
    [super dealloc];
}




@end
