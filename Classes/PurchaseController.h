//
//  PurchaseController.h
//  History
//
//  Created by Martin Ceperley on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CustomButton.h"

@interface PurchaseController : UIViewController {
	
	SKProduct* product;
	
	CustomButton* buyButton;
	
	UILabel* nameLabel;
	UILabel* priceLabel;
	UILabel* descriptionLabel;

}

- (id) initWithProduct: (SKProduct *) theProduct;


@property (nonatomic, retain) SKProduct* product;

@end
