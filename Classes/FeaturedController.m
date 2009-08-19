//
//  FeaturedController.m
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FeaturedController.h"

#define kFeaturedLocationService @"http://www.historicmapworks.com/iPhone/featured_list.php"

@implementation FeaturedController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	
	loadingResults = NO;
	
	self.title = @"Featured";
	self.hidesBottomBarWhenPushed = YES;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = [UIColor brownColor];


	
	
	loadingSpinner = [[UIActivityIndicatorView alloc]
					  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	loadingSpinner.hidesWhenStopped = YES;
	loadingSpinner.center = CGPointMake(320/2, 480/2);
	
	[self.view addSubview:loadingSpinner];
	

	
	
	locations = [[NSMutableArray alloc] init];
	featuredLocationController = [[FeaturedLocationController alloc] init];
	
	
	
	theConnection=[[NSURLConnection alloc] initWithRequest:
				   [NSURLRequest requestWithURL:
					[NSURL URLWithString:kFeaturedLocationService]]
												  delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		[loadingSpinner startAnimating];
		receivedData=[[NSMutableData data] retain];
		loadingResults = YES;
		
		
	} else {
		// inform the user that the download could not be made
	}



    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


# pragma mark Loading JSON Data

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [theConnection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received featured collections list",[receivedData length]);
	
	NSString* dataString =  [[NSString alloc]
							 initWithData: receivedData
							 encoding: NSUTF8StringEncoding];
	
	NSDictionary* jsonData = [dataString JSONValue];
	[dataString release];
	
	if(jsonData){
		
		//NSLog(@"json object is : %@",jsonData);
		

		NSArray* theKeys = [jsonData allKeys];
		NSArray* sortedKeys = [theKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		

		
		for(NSString* theKey in sortedKeys){
			
			NSString *theName = [jsonData objectForKey:theKey];
			
			NSLog(@"logged key %@ with value %@", theKey, theName);
				
			if(theKey && theName){
					
					
				Location* theLocation = [[Location alloc] initWithName:theName andID:[theKey intValue]];
					
				[locations addObject:theLocation];
				[theLocation release];
				NSLog(@"added location");
			}
			else{
				NSLog(@"didn't get all required values for map");
			}
		
		}//end for loop
		
	}
	else{
		NSLog(@"error parsing json file");
		
	}
	
	
	loadingResults = NO;
	
	[loadingSpinner stopAnimating];
	
	self.tableView.scrollEnabled = [locations count] > 0;
	[self.tableView reloadData];	
	
    // release the connection, and the data object
    [theConnection release];
    [receivedData release];
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
	return [locations count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	Location* theLoc = [locations objectAtIndex:indexPath.row];
	
	cell.textLabel.text = theLoc.name;
	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:14.0];
	cell.textLabel.textColor = [UIColor blackColor];
	
	cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];

	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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
    [super dealloc];
}


@end

