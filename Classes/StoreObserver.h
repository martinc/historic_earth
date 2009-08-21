//
//  StoreObserver.h
//  History
//
//  Created by Martin Ceperley on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "NSDataBase64.h"
#import "HistoryAppDelegate.h"

@class HistoryAppDelegate;

@interface StoreObserver : NSObject<SKPaymentTransactionObserver> {
	
	NSMutableData *receivedData;
	
	NSURLConnection *theConnection;
	
	HistoryAppDelegate *app;
}

- (id) initWithAppDelegate: (HistoryAppDelegate *) del;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;

- (void) validateReceipt: (NSData *) theReceipt;

@end
