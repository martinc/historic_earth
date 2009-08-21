//
//  PurchaseController.m
//  History
//
//  Created by Martin Ceperley on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PurchaseController.h"


@implementation PurchaseController

@synthesize product;


- (id) initWithProduct: (SKProduct *) theProduct {
	self = [super init];
	
	product = [theProduct retain];


	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth);
    view.backgroundColor = [UIColor clearColor];
	
	
	nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
	priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
	descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 200, 280, 100)];
	
    nameLabel.backgroundColor = [UIColor clearColor];
	priceLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.backgroundColor = [UIColor clearColor];
	
	nameLabel.textAlignment = UITextAlignmentCenter;
	priceLabel.textAlignment = UITextAlignmentCenter;
	descriptionLabel.textAlignment = UITextAlignmentLeft;

	
	nameLabel.font = [UIFont fontWithName:@"Georgia" size:24.0];
	priceLabel.font = [UIFont boldSystemFontOfSize:18.0];
	descriptionLabel.font = [UIFont fontWithName:@"Georgia" size:16.0];
	
	buyButton = [[CustomButton alloc] initWithFrame:CGRectMake(50, 380, 220, 50)];
	
	
	[buyButton setTitle:@"Buy Content" forState:UIControlStateNormal];
	buyButton.titleLabel.textColor = [UIColor blackColor];
	
	[buyButton addTarget:self action:@selector(buyProduct) forControlEvents:UIControlEventTouchUpInside];
	
	
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:product.priceLocale];
	
	priceLabel.text = [numberFormatter stringFromNumber:product.price];
	
	[numberFormatter release];
	
	
	nameLabel.text = product.localizedTitle;
	descriptionLabel.text = product.localizedDescription;
	descriptionLabel.numberOfLines = 0;
	
	
	
	
	
	
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:kSEARCH_ENABLED] && [product.productIdentifier isEqualToString:kSEARCH_PRODUCT_ID])
	{
		
		buyButton.enabled = NO;
		[buyButton setTitle:@"Already Purchased" forState:UIControlStateNormal];
		
		
	}
	else if(![SKPaymentQueue canMakePayments])
	{
		buyButton.enabled = NO;
		[buyButton setTitle:@"Purchases Disabled" forState:UIControlStateNormal];
	}
	
	
	
	[view addSubview: nameLabel];
	[view addSubview: priceLabel];
	[view addSubview: descriptionLabel];
	[view addSubview: buyButton];
	
    self.view = view;
    [view release];
	
	
	

	
}

- (void) buyProduct {
	
	buyButton.enabled = NO;
	
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:product.productIdentifier];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[nameLabel release];
	[descriptionLabel release];
	[priceLabel release];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
