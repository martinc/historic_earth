//
//  StoreObserver.m
//  History
//
//  Created by Martin Ceperley on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StoreObserver.h"
#import "JSON.h"




@implementation StoreObserver



- (id) initWithAppDelegate:(HistoryAppDelegate *)del
{

	self = [super init];
	app = del;
	
	return self;
	
}

- (void)dealloc {
	[app release];
    [super dealloc];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
		NSLog(@"Failed transaction");
		// Optionally, display an error here.
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
	
	//NSLog(@"Restore transaction");
	
	//NSLog(@"transaction.transactionReceipt: %@",transaction.transactionReceipt);
	//NSLog(@"transaction.originalTransaction.transactionReceipt: %@",transaction.originalTransaction.transactionReceipt);

	
	[self validateReceipt: transaction.transactionReceipt];
	//[self validateReceipt: transaction.originalTransaction.transactionReceipt];


	//If you want to save the transaction
	// [self recordTransaction: transaction];
	
	//Provide the new content
	// [self provideContent: transaction.originalTransaction.payment.productIdentifier];
	
	//Finish the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	
	NSLog(@"Completed transaction");
	
	
	[self validateReceipt: transaction.transactionReceipt];

	//If you want to save the transaction
	// [self recordTransaction: transaction];
	
	//Provide the new content
	//[self provideContent: transaction.payment.productIdentifier];
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
}

- (void) validateReceipt: (NSData *) theReceipt
{


#ifdef RELEASE
	NSURL *storeURL = [NSURL URLWithString: kVERIFY_REAL];
#else
	NSURL *storeURL = [NSURL URLWithString: kVERIFY_SANDBOX];
#endif
	
	
	NSString *jsonOut = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\" }", [theReceipt base64Encoding] ];
	
	//NSLog(@"jsonOut is %@", jsonOut);
	
	// create the request
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:storeURL
											  cachePolicy:NSURLRequestReloadIgnoringCacheData
										  timeoutInterval:15.0];
	
	[theRequest setHTTPMethod: @"POST"];
	[theRequest setHTTPBody: [jsonOut dataUsingEncoding:NSUTF8StringEncoding] ];
	
	// create the connection with the request
	// and start loading the data
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
		
		
	} else {
		NSLog(@"Error opening connection for receipt verification");
		// inform the user that the download could not be made
	}
	
	
}




# pragma mark loading JSON receipt validation from apple

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [theConnection release];
    [receivedData release];
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString* dataString =  [[NSString alloc]
							 initWithData: receivedData
							 encoding: NSUTF8StringEncoding];
	
	NSDictionary* jsonData = [dataString JSONValue];
	
	[dataString release];
	
	//NSLog(@"json receipt validation is : %@",jsonData);
	
	NSNumber* result = [jsonData objectForKey:@"status"];
	
	if(result && [result intValue] == 0){
		//NSLog(@"receipt status successful");
		
		NSString* product_id = [[jsonData objectForKey:@"receipt"] objectForKey:@"product_id"];
		
		if([product_id isEqualToString:kSEARCH_PRODUCT_ID])
		{
		
			[app purchasedSearch];
			
		}

	}
	else NSLog(@"receipt status unsucessfull");
	
		
    // release the connection, and the data object
    [theConnection release];
    [receivedData release];
}



@end