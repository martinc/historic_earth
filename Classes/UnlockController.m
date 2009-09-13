//
//  UnlockController.m
//  History
//
//  Created by Martin Ceperley on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UnlockController.h"


@implementation UnlockController


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
	
	loadingResults = NO;
	
	loadingSpinner = [[UIActivityIndicatorView alloc]
					  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	loadingSpinner.hidesWhenStopped = YES;
	loadingSpinner.center = CGPointMake(320/2, 480/2);
	
	
	
	products = [[NSArray array] retain];
	
	self.title = @"Unlock Content";
	
	self.tableView.backgroundColor = [UIColor clearColor];
	//self.tableView.rowHeight = 200;
	
	//[self requestProductData];
	
		
    return self;
}






- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	
	[self.view addSubview:loadingSpinner];
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated: YES];

}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [products count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	SKProduct *product = [products objectAtIndex:indexPath.row];
//	NSLog(@”Name: %@ - Price: %f”,[product localizedTitle],[[product price] doubleValue]);
//	NSLog(@”Product identifier: %@”, [product productIdentifier]);
	
	
	/*
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:product.priceLocale];
	NSString *formattedString = [numberFormatter stringFromNumber:product.price];
	
	
	[numberFormatter release];
	 
	 
	 */
	
	cell.textLabel.text = product.localizedTitle;
	//cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", product.localizedTitle, formattedString];
	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:18.0];
	//cell.detailTextLabel.text = product.localizedDescription;
	//cell.detailTextLabel.numberOfLines = 4; //No limit on label lines
	//cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	[self.navigationController pushViewController:
										[[[PurchaseController alloc] initWithProduct:[products objectAtIndex:indexPath.row]] autorelease]
										 animated: YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	
	[products release];
	[loadingSpinner release];
	
    [super dealloc];
}


@end

