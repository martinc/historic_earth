//
//  HistoryViewController.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AbstractMapListController.h"
#import "JSON.h"
#import "Three20/Three20.h"
#import "UIKit/UITableView.h"

@implementation AbstractMapListController


NSString * const kMAP_ATLAS_NAME = @"Atlas Name";
NSString * const kMAP_BL = @"BL";
NSString * const kMAP_TR = @"TR";
NSString * const kMAP_LAYER = @"Layer";
NSString * const kMAP_NAME = @"Name";
NSString * const kMAP_YEAR = @"Year";
NSString * const kMAP_MIN_ZOOM = @"MinZoom";



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
	
	dataLoaded = NO;
	loadingResults = NO;
	haveLocation = NO;

	
	
	self.title = @"Results";
	
	self.tableView.backgroundColor = [UIColor clearColor];
	
	//self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	
	loadingSpinner = [[UIActivityIndicatorView alloc]
					  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

	loadingSpinner.hidesWhenStopped = YES;
	loadingSpinner.center = CGPointMake(320/2, 480/2);
	//loadingSpinner.transform = CGAffineTransformMakeScale(4.0, 4.0);

	
	[self.view addSubview:loadingSpinner];
	
	maps = [[NSMutableArray alloc] init];
	mapController = [[MapViewController alloc] initWithMaps: maps];


	self.hidesBottomBarWhenPushed = YES;
	


	
	self.tableView.separatorColor = [UIColor brownColor];

	
}

- (void) loadDataWithRequest: (NSURLRequest *) theRequest searchLocation: (CLLocationCoordinate2D) loc
{
	searchLocation = loc;
	haveLocation = YES;
	
	[self loadDataWithRequest: theRequest];

}

- (void) loadDataWithRequest: (NSURLRequest *) theRequest
{
	
	
	// create the connection with the request
	// and start loading the data
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
		loadingResults = YES;
		[loadingSpinner startAnimating];

		
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
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString* dataString =  [[NSString alloc]
						  initWithData: receivedData
						  encoding: NSUTF8StringEncoding];
	
	NSArray* jsonData = [dataString JSONValue];
	[dataString release];
	
	if(jsonData){
	
	//NSLog(@"json object is : %@",jsonData);
	
		for(NSDictionary* mapDataShell in jsonData){
			NSDictionary* mapData = [mapDataShell objectForKey:@"Map"];
			if(mapData){
				

				
				NSString* theAtlasName = [mapData objectForKey:kMAP_ATLAS_NAME]; 
				NSString* theBL = [mapData objectForKey:kMAP_BL];
				NSString* theTR = [mapData objectForKey:kMAP_TR];
				NSString* theLayer = [mapData objectForKey:kMAP_LAYER];
				NSString* theName = [mapData objectForKey:kMAP_NAME];
				
				NSNumber* theYear = [mapData objectForKey:kMAP_YEAR];
				NSNumber* theMinZoom = [mapData objectForKey:kMAP_MIN_ZOOM];
										
						
				if(theAtlasName && theBL && theTR && theLayer && theName && theYear && theMinZoom){
				
					
					Map* theMap = [[Map alloc] init];
					
					theMap.layerID = theLayer;
					theMap.atlasName = theAtlasName;
					theMap.name = theName;
					theMap.year = [theYear intValue];
					theMap.minZoom = [theMinZoom intValue];
					
					
					NSArray* southWestStrings = [theBL componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					NSArray* northEastStrings = [theTR componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					

					if([southWestStrings count] == 2 && [northEastStrings count] == 2)
					{
						
						RMSphericalTrapezium mapBounds;
						mapBounds.southwest.longitude = [[southWestStrings objectAtIndex:0] doubleValue];
						mapBounds.southwest.latitude = [[southWestStrings objectAtIndex:1] doubleValue];
						mapBounds.northeast.longitude = [[northEastStrings objectAtIndex:0] doubleValue];
						mapBounds.northeast.latitude = [[northEastStrings objectAtIndex:1] doubleValue];
						NSLog(@"set corners to %f,%f %f,%f", mapBounds.southwest.latitude, mapBounds.southwest.longitude, mapBounds.northeast.latitude, mapBounds.northeast.longitude);
						theMap.mapBounds = mapBounds;
						
					}
					else{
						NSLog(@"error parsing latlong bounds");
					}

					[maps addObject:theMap];
					[theMap release];
					NSLog(@"added map");
				}
				else{
					NSLog(@"didn't get all required values for map");
				}
			}
			else {
				NSLog(@"error reading map object");
			}
			
		}//end for loop
		
	}
	else{
		NSLog(@"error parsing json file");
		
	}
	
	
	
		//let's not do images now
		/*
		 
		 NSString* theimage = [mapData objectForKey:@"image"];
		 //		NSLog(theimage);
		 
		TTURLRequest* request = [TTURLRequest requestWithURL:theimage delegate:self];
		request.userInfo = [NSNumber numberWithInt:[listOfItems count]-1];
		request.response = [[[TTURLImageResponse alloc] init] autorelease];
		[[TTURLRequestQueue mainQueue]  sendRequest: request];
		 */
		
	
	loadingResults = NO;
	dataLoaded = YES;

	[loadingSpinner stopAnimating];
	
	self.tableView.scrollEnabled = [maps count] > 0;
	[self.tableView reloadData];	
	
    // release the connection, and the data object
    [theConnection release];
    [receivedData release];
}

#pragma mark Loaded Image

	/*
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
	 */



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
	

		return [maps count];


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
	
	//let's not do images now
	/*
	if( indexPath.row < [listOfImages count] &&
	   [listOfImages objectAtIndex:indexPath.row] != [NSNull null])
	{
	
		cell.imageView.image = [self scaleImage:  (UIImage *)[listOfImages objectAtIndex:indexPath.row]
									   maxWidth: 100
									  maxHeight: 120];
		
	}
	 
	 */
	
	Map* theMap = [maps objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%d",theMap.year];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@",theMap.name,theMap.layerID];
	
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
	return 100.0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	
	NSUInteger row = indexPath.row;
    if (row != NSNotFound) {
		
		if(haveLocation)
		{
			[mapController loadMapAtIndex: indexPath.row withMarkerLocation: searchLocation];
		}
		else
		{
			[mapController loadMapAtIndex: indexPath.row];
		}
		
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
