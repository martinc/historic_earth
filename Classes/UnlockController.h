//
//  UnlockController.h
//  History
//
//  Created by Martin Ceperley on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "PurchaseController.h"
#import "TargetConditionals.h"


@interface UnlockController : UITableViewController <SKProductsRequestDelegate> {
	
	NSArray *products;
		
	SKProductsRequest *productsRequest;
	
	
	UIActivityIndicatorView *loadingSpinner;  
	BOOL loadingResults;


}


- (void) requestProductData;


@end
