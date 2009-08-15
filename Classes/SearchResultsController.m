//
//  HistoryViewController.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SearchResultsController.h"
#import "JSON.h"
#import "Three20/Three20.h"
#import "UIKit/UITableView.h"

@implementation SearchResultsController


/*

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		

    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) viewWillAppear:(BOOL)animated {
	
	[self.navigationController setNavigationBarHidden:NO animated: YES];

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.title = @"Results";
	
	self.tableView.backgroundColor = [UIColor clearColor];
	
	//self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	
	loadingSpinner = [[UIActivityIndicatorView alloc]
					  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

	loadingSpinner.hidesWhenStopped = YES;
	loadingSpinner.center = CGPointMake(320/2, 480/2);
	//loadingSpinner.transform = CGAffineTransformMakeScale(4.0, 4.0);

	[loadingSpinner startAnimating];
	
	[self.view addSubview:loadingSpinner];
	
	mapController = [[MapViewController alloc] initWithNibName:nil bundle:nil];


	self.hidesBottomBarWhenPushed = YES;
	
	//Initialize the array.
	listOfItems = [[NSMutableArray alloc] init];
	
	listOfImages = [[NSMutableArray alloc] init];
	
	listOfNames = [[NSMutableArray alloc] init];
	
	//Add items
	/*
	[listOfItems addObject:@"1864"];
	[listOfItems addObject:@"1926"];
	[listOfItems addObject:@"1766"];
	[listOfItems addObject:@"1655"];
	[listOfItems addObject:@"1542"];
	*/
	
	/*
	float tableWidth = 310.0;
	float distanceFromTop = 44.0;
	
	CGRect tableFrame = CGRectMake((320-tableWidth)/2, distanceFromTop, tableWidth, 480.0-distanceFromTop);
	*/
	
	
	
//	UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//UITableView* tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];

	
	self.tableView.separatorColor = [UIColor brownColor];
//	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	
	/*
	CustomButton* thebutton = [[CustomButton alloc]
							   initWithFrame:CGRectMake(0.0, 0.0, 150.0, 80.0)];
	thebutton.titleLabel.textColor = [UIColor blackColor];

	[thebutton setTitle:@"load maps" forState:UIControlStateNormal];
	[thebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

	self.tableView.tableFooterView = thebutton;
	
	*/	
	
	
	
	// create the request
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oldmapapp.com/test/sample.json"]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:15.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
		
		loadingResults = YES;

	} else {
		// inform the user that the download could not be made
	}
	
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
    [connection release];
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
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString* dataString =  [[NSString alloc]
						  initWithData: receivedData
						  encoding: NSUTF8StringEncoding];
	
	NSArray* jsonData = [dataString JSONValue];
	
	[dataString release];
	
	//NSLog(@"json object is : %@",jsonData);
	
	for(NSDictionary* mapData in jsonData){
	
		NSString* theyear = [[mapData objectForKey:@"year"] stringValue];

		NSString* thename = [mapData objectForKey:@"name"];
		[listOfItems addObject:theyear];
		[listOfNames addObject:thename];
		[listOfImages addObject:[NSNull null]];
		
		NSString* theimage = [mapData objectForKey:@"image"];
		
//		NSLog(theimage);
		
		TTURLRequest* request = [TTURLRequest requestWithURL:theimage delegate:self];
		
		request.userInfo = [NSNumber numberWithInt:[listOfItems count]-1];
		request.response = [[[TTURLImageResponse alloc] init] autorelease];

		
		[[TTURLRequestQueue mainQueue]  sendRequest: request];

		
	}
	
	loadingResults = NO;
	[loadingSpinner stopAnimating];
	
	[self.tableView reloadData];	
	
    // release the connection, and the data object
    [connection release];
    [receivedData release];
}

#pragma mark Loaded Image

- (void)requestDidFinishLoad:(TTURLRequest*)request
{
	
	int rowloaded = ((NSNumber*)request.userInfo).intValue;
	NSLog(@"successfully loaded row %d", rowloaded);
	UIImage* imageLoaded = ((TTURLImageResponse *)request.response).image;
	
	
	[listOfImages insertObject:imageLoaded atIndex: rowloaded];
	
	
//	NSIndexPath  *indx =  [NSIndexPath indexPathForRow:rowloaded inSection:0];

//	NSLog(@"index is %@", indx);
	
//	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: indx]
//						  withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView reloadData];

	
	
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	

		return [listOfItems count];


}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	/*
	cell.imageView.image = [self scaleImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", indexPath.row+1]]
								   maxWidth: 100
								  maxHeight: 120];
	*/
	
	if( indexPath.row < [listOfImages count] &&
	   [listOfImages objectAtIndex:indexPath.row] != [NSNull null])
	{
	
		cell.imageView.image = [self scaleImage:  (UIImage *)[listOfImages objectAtIndex:indexPath.row]
									   maxWidth: 100
									  maxHeight: 120];
		
	}
	
	
	NSString *cellValue = [listOfItems objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	//cell.detailTextLabel.text = @"New York State Atlas";
	cell.detailTextLabel.text = [listOfNames objectAtIndex:indexPath.row];
	
	cell.textLabel.textColor = [UIColor brownColor];

	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:26.0];
	cell.detailTextLabel.textColor = [UIColor grayColor];

	cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:14.0];

	
	
	//cell.backgroundView.backgroundColor = [UIColor redColor];
	//cell.backgroundColor = [UIColor redColor];

	
	//white text on dark
	
	/*
	cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.textColor = [UIColor lightGrayColor];
	 */
	
	
	cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	cell.textLabel.textColor = [UIColor blackColor];
	cell.detailTextLabel.textColor = [UIColor blackColor];
	
	
	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];

	


	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	//cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 130.0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	
	NSUInteger row = indexPath.row;
    if (row != NSNotFound) {
		
        mapController.title = [listOfItems objectAtIndex:indexPath.row];
        [[self navigationController] pushViewController:mapController animated:YES];
		
    }
	
}







- (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight
{
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	if (width <= maxWidth && height <= maxHeight)
	{
		return image;
	}
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > maxWidth || height > maxHeight)
	{
		CGFloat ratio = width/height;
		if (ratio > 1)
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else
		{
			bounds.size.height = maxHeight;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextScaleCTM(context, scaleRatio, -scaleRatio);
	CGContextTranslateCTM(context, 0, -height);
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}



@end
