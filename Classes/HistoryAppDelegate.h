//
//  HistoryAppDelegate.h
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <StoreKit/StoreKit.h>
#import "MainMenuController.h"
#import "StoreObserver.h"
#import "Reachability.h"
#import "TargetConditionals.h"
#import "Appirater.h"

@class StoreObserver;

@interface HistoryAppDelegate : NSObject <UIApplicationDelegate, SKProductsRequestDelegate> {
    UIWindow *window;
	UINavigationController* navController;
	MainMenuController* main;
	StoreObserver *observer;
	
	
	Reachability* hostReach;
 //   Reachability* internetReach;
	
	
//	NetworkStatus internetConnectionStatus;
	NetworkStatus remoteHostStatus;
	
	BOOL haveBeenConnected;
	BOOL shownNetworkError;
	
	
	UIAlertView *alert;
	
	
	NSArray *products;
	SKProductsRequest *productsRequest;
	
	NSThread *heartBeat;
	
	BOOL serverRunning;
	
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	//NSPersistentStore *inMemoryStore;
	NSPersistentStore *diskStore;

	
}

@property NetworkStatus remoteHostStatus;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//@property (nonatomic,  readonly) NSPersistentStore *inMemoryStore;
@property (nonatomic,  readonly) NSPersistentStore *diskStore;


- (void)initStatus;
- (void) updateStatus;
- (void) reachabilityChanged: (NSNotification* )note;

- (void) purchasedSearch;

- (void) showAlertWithText: (NSString*) thetext;

- (void) requestProductData;

- (NSString *)applicationDocumentsDirectory;



@end

