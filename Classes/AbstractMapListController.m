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
#import "LocationController.h"

@implementation AbstractMapListController

@synthesize statusLabel, currentMapList;

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
	[self.navigationController setToolbarHidden:NO animated:YES];

/*	
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	UIDeviceOrientation controllerOrientation = self.interfaceOrientation;
	
	if( (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight)
	   && (controllerOrientation == UIDeviceOrientationPortrait || controllerOrientation == UIDeviceOrientationPortraitUpsideDown))
	{
		[[UIDevice currentDevice] setOrientation: deviceOrientation];
	}
*/

}
/*
- (id) initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];	
	return self;
	
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataLoaded = NO;
	loadingResults = NO;
	haveLocation = NO;
	
	receivedData = [[NSMutableData data] retain];

	
	
	self.title = @"Results";
	self.hidesBottomBarWhenPushed = NO;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = [UIColor brownColor];

	
	//self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	
	loadingSpinner = [[UIActivityIndicatorView alloc]
					  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

	loadingSpinner.hidesWhenStopped = YES;
	loadingSpinner.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2); 
	loadingSpinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	[self.view addSubview:loadingSpinner];
	
	
	
	maps = [[NSMutableArray alloc] init];
	
	smallMaps = [[NSMutableArray alloc] init];
	mediumMaps = [[NSMutableArray alloc] init];
	largeMaps = [[NSMutableArray alloc] init];
	
	currentMapList = maps;
	
	
	mapController = [[MapViewController alloc] initWithMaps: maps];
	//mapController = [[MapViewController alloc] initWithMaps: maps allowCompass: YES locationManager: locationManager];
	
	[loadingSpinner startAnimating];

	
	statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, self.view.frame.size.width-80, 100)];
	statusLabel.backgroundColor = [UIColor clearColor];
	statusLabel.hidden = YES;
	statusLabel.textAlignment = UITextAlignmentCenter;
	statusLabel.font = [UIFont boldSystemFontOfSize:16.0];
	statusLabel.lineBreakMode = UILineBreakModeWordWrap;
	statusLabel.numberOfLines = 4;
	statusLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	
	[self.view addSubview:statusLabel];
	
	
	
	// Add Map Size Filter to lower toolbar
	
	mapFilter = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"All",@"Small",@"Medium",@"Large",nil]] autorelease];
	mapFilter.segmentedControlStyle = UISegmentedControlStyleBar;
	mapFilter.selectedSegmentIndex = 0;
	mapFilter.tintColor = [UIColor darkGrayColor];
	
	[mapFilter setEnabled:NO forSegmentAtIndex:1];
	[mapFilter setEnabled:NO forSegmentAtIndex:2];
	[mapFilter setEnabled:NO forSegmentAtIndex:3];
	
	
	[mapFilter setWidth:45.0 forSegmentAtIndex:0];
	[mapFilter setWidth:75.0 forSegmentAtIndex:1];
	[mapFilter setWidth:75.0 forSegmentAtIndex:2];
	[mapFilter setWidth:75.0 forSegmentAtIndex:3];


	
	
	[mapFilter addTarget:self action:@selector(mapFilterChanged) forControlEvents:UIControlEventValueChanged];
	
	
	UIBarButtonItem* bbitem = [[[UIBarButtonItem alloc] initWithCustomView: mapFilter] autorelease];

	UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];

	
	self.toolbarItems = [NSArray arrayWithObjects:spacer,bbitem,spacer,nil];
	

	
}


- (void) mapFilterChanged
{	
	switch (mapFilter.selectedSegmentIndex) {
		case 1:
			currentMapList = smallMaps;
			break;
		case 2:
			currentMapList = mediumMaps;
			break;
		case 3:
			currentMapList = largeMaps;
			break;
		default:
			currentMapList = maps;
			break;
	}
	
	[mapController loadingNewMaps];
	mapController.maps = currentMapList; 
	
	[self.tableView reloadData];
	
}

- (void) loadDataWithRequest: (NSURLRequest *) theRequest searchLocation: (CLLocationCoordinate2D) loc
{
	searchLocation = loc;
	haveLocation = YES;
	
	[self loadDataWithRequest: theRequest];

}

- (void) loadDataWithRequest: (NSURLRequest *) theRequest
{
	
	if([maps count] > 0){
		[mapController loadingNewMaps];
	}
		 
	
	[maps removeAllObjects];
	[self.tableView reloadData];
	
	if( ! [self isKindOfClass:[LocationController class]])
		statusLabel.hidden = YES;
	
	// create the connection with the request
	// and start loading the data
	//if(theConnection) [theConnection release];
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		[loadingSpinner startAnimating];
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
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	[theConnection release];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString* dataString =  [[NSString alloc]
						  initWithData: receivedData
						  encoding: NSUTF8StringEncoding];
	
#ifdef DEBUG
	NSLog(@"response is : %@",dataString);
#endif
	
	NSDictionary* jsonData = [dataString JSONValue];
	[dataString release];
	
	if(jsonData){
		
		//Test status
		
		NSNumber *status = [jsonData objectForKey:@"status"];



		if([status intValue] == -1)
		{
			// Error case for invalid search
			
			statusLabel.text = @"Invalid search terms.";
			statusLabel.hidden = NO;

		}
		else if([status intValue] == 0)
		{
			//Error case for no matches found
			
			if([self isKindOfClass:[LocationController class]]){
				statusLabel.text = @"Sorry, we don't have maps for your location.";
			}
			else{
			   statusLabel.text = @"No maps were found for that location.";

			}
			statusLabel.hidden = NO;
			
		}
		else{
		
			//Success
			
			
			
			NSNumber *searchLat = [jsonData objectForKey:@"lat"];
			NSNumber *searchLong = [jsonData objectForKey:@"long"];
			
			if(searchLat && searchLong)
			{
				searchLocation.latitude = [searchLat doubleValue];
				searchLocation.longitude = [searchLong doubleValue];
				haveLocation = YES;
			}
			
			
			
			id theRawMaps = [jsonData objectForKey:@"Maps"];
			
			if(theRawMaps && theRawMaps != [NSNull null] ){
				
				NSArray* theMaps = theRawMaps;

				
				[maps removeAllObjects];

			
				for(NSDictionary* mapData in theMaps){
				
					if(mapData){
						
						
						
						NSString* theAtlasName = [mapData objectForKey:kMAP_ATLAS_NAME]; 
						NSString* theBL = [mapData objectForKey:kMAP_BL];
						NSString* theTR = [mapData objectForKey:kMAP_TR];
						NSString* theLayer = [mapData objectForKey:kMAP_LAYER];
						NSString* theName = [mapData objectForKey:kMAP_NAME];
						
						NSNumber* theYear = [mapData objectForKey:kMAP_YEAR];
						NSNumber* theMinZoom = [mapData objectForKey:kMAP_MIN_ZOOM];
						
						
						if(theAtlasName && theBL && theTR && theLayer && theName && theYear && theMinZoom){
							
							//BOOL hasLocation = YES;
							
							Map* theMap = [[Map alloc] init];
							
							theMap.layerID = theLayer;
							theMap.atlasName = theAtlasName;
							theMap.name = theName;
							theMap.year = [theYear intValue];
							theMap.minZoom = [theMinZoom intValue];
							if(theMap.minZoom == 0){
								theMap.minZoom = kDEFAULT_MIN_ZOOM;
								#ifdef DEBUG
									NSLog(@"setting map minZoom to %d", theMap.minZoom);
								#endif
							}
							
							//debug test for africa continent map 1633 topp:OL31
							/*
							#ifdef DEBUG
								NSLog(@"debug setting minZoom to 2");
								if([theMap.layerID isEqualToString:@"topp:OL31"]){
										theMap.minZoom = 2;
								}
							#endif
							*/
							
								
							
							NSArray* southWestStrings = [theBL componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
							NSArray* northEastStrings = [theTR componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
							
							
							if([southWestStrings count] == 2 && [northEastStrings count] == 2)
							{
								
								RMSphericalTrapezium mapBounds;
								mapBounds.southwest.longitude = [[southWestStrings objectAtIndex:0] doubleValue];
								mapBounds.southwest.latitude = [[southWestStrings objectAtIndex:1] doubleValue];
								mapBounds.northeast.longitude = [[northEastStrings objectAtIndex:0] doubleValue];
								mapBounds.northeast.latitude = [[northEastStrings objectAtIndex:1] doubleValue];
								
								
								theMap.mapBounds = mapBounds;

								
								if(mapBounds.southwest.latitude == 0 ||
								   mapBounds.southwest.longitude == 0 ||
								   mapBounds.northeast.latitude == 0 ||
								   mapBounds.northeast.longitude == 0)
								{
									//hasLocation = NO;
									
									theMap.mapCenter = searchLocation;
								//	NSLog(@"defaulting to search location");
									
								}
#ifdef DEBUG

								NSLog(@"set corners to %f,%f %f,%f", mapBounds.southwest.latitude, mapBounds.southwest.longitude, mapBounds.northeast.latitude, mapBounds.northeast.longitude);
#endif
	
							}
							else{
								NSLog(@"error parsing latlong bounds");
							}
							
							[maps addObject:theMap];
							[theMap release];
							//NSLog(@"added map");
						}
						else{
							NSLog(@"didn't get all required values for map");
						}
						
						
						
						
						
					} // end if(mapData)
					else {
						NSLog(@"error reading map object");
					}
						
				} // end for
				
			} // end if (theMaps)
			else{
				NSLog(@"error parsing json file");
				
			}
			
		} // end else
		
		
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
	
	if([maps count] == 0)
	{
		statusLabel.text = @"No maps were found for that location.";
		statusLabel.hidden = NO;
	}
	
	// Now, let's sort the maps by date
	
	[maps sortUsingSelector:@selector(mapOrder:)];
	
	
	// Grouping
	
#if(0)
	
	
	NSMutableDictionary *atlasNames = [NSMutableDictionary dictionaryWithCapacity:5];
	
	for(Map* aMap in maps)
	{
		[atlasNames setObject:[NSNumber numberWithBool:YES] forKey: aMap.atlasName];
	}
	
	//NSLog(@"%d maps, %d atlases", [maps count], [atlasNames count]);
	
	NSMutableArray *atlases = [[NSMutableArray alloc] initWithCapacity:[atlasNames count]];

	
	for(NSString* atlasName in [atlasNames allKeys])
	{
		NSMutableArray* componentMaps = [NSMutableArray arrayWithCapacity:5];
		for(Map* searchingMap in maps)
		{
			if([atlasName isEqualToString:searchingMap.atlasName])
			{
				//Found a map
				[componentMaps addObject:searchingMap];
			}
		}
		
		if([componentMaps count] > 0)
		{
			Map* exampleMap = [componentMaps objectAtIndex:0];
			
			 
			Map* theAtlas = [[Map alloc] init];
			theAtlas.atlasName = exampleMap.atlasName;
			theAtlas.year = exampleMap.year;
			theAtlas.minZoom = exampleMap.minZoom;
			theAtlas.mapBounds = exampleMap.mapBounds;
			
			CLLocationCoordinate2D averageCenter = {0, 0};
			
			NSMutableArray* layerIDS = [NSMutableArray arrayWithCapacity:[componentMaps count]];
			for(Map* component in componentMaps)
			{
				averageCenter.longitude += component.mapCenter.longitude;
				averageCenter.latitude += component.mapCenter.latitude;
				//[layerIDS addObject:component.layerID];
				[layerIDS insertObject:component.layerID atIndex:0];
				
				[theAtlas.plates addObject:component];
			}
			
			averageCenter.longitude /= [componentMaps count];
			averageCenter.latitude /= [componentMaps count];
			
			theAtlas.mapCenter = averageCenter;
			
			theAtlas.layerID = [layerIDS componentsJoinedByString:@","];
			
#ifdef DEBUG
			NSLog(@"setting new atlas layer ID to %@", theAtlas.layerID);
#endif
			//theAtlas.name = [NSString stringWithFormat:@"%d Plate%@", [componentMaps count], [componentMaps count] > 1 ? @"s" : @"" ];
			theAtlas.name = @"";
			
			[atlases addObject:theAtlas];
			
			[theAtlas release];
	
		}
	}
	
		

//	[atlases sortUsingSelector:@selector(mapOrder:)];
//	[maps removeAllObjects];
//	[maps addObjectsFromArray:atlases];
	
	[atlases release];
	
	
#endif
	
	
	// Divide maps into bins
	
	[smallMaps removeAllObjects];
	[mediumMaps removeAllObjects];
	[largeMaps removeAllObjects];
	
	BOOL smallMapsEmpty = YES;
	BOOL mediumMapsEmpty = YES;
	BOOL largeMapsEmpty = YES;

	
	for(Map* m in maps)
	{
		int theZoom = m.initialZoom;
		if (theZoom == -1) theZoom = m.minZoom;
		
		if(theZoom < 6)
		{
			[largeMaps addObject: m];
			largeMapsEmpty = NO;
		}
		else if(theZoom < 12)
		{
			[mediumMaps addObject: m];
			mediumMapsEmpty = NO;
		}
		else {
			[smallMaps addObject: m];
			smallMapsEmpty = NO;
		}
	}
	
	/*
	if([maps count] == 0)
		[mapFilter setTitle:@"All" forSegmentAtIndex:0];
	else
		[mapFilter setTitle:[NSString stringWithFormat:@"All (%d)",[maps count]] forSegmentAtIndex:0];	
*/
	 
	if(smallMapsEmpty)
		[mapFilter setTitle:@"Small" forSegmentAtIndex:1];
	else
		[mapFilter setTitle:[NSString stringWithFormat:@"Small (%d)",[smallMaps count]] forSegmentAtIndex:1];

	if(mediumMapsEmpty)
		[mapFilter setTitle:@"Medium" forSegmentAtIndex:2];
	else
		[mapFilter setTitle:[NSString stringWithFormat:@"Medium (%d)",[mediumMaps count]] forSegmentAtIndex:2];

	if(largeMapsEmpty)
		[mapFilter setTitle:@"Large" forSegmentAtIndex:3];
	else
		[mapFilter setTitle:[NSString stringWithFormat:@"Large (%d)",[largeMaps count]] forSegmentAtIndex:3];
	
	
	[mapFilter setEnabled: (!smallMapsEmpty) forSegmentAtIndex:1];
	[mapFilter setEnabled:!mediumMapsEmpty forSegmentAtIndex:2];
	[mapFilter setEnabled:!largeMapsEmpty forSegmentAtIndex:3];
	
	
	//if only one section is represented, disable all
	
	if( ( !smallMapsEmpty ) &&  (mediumMapsEmpty && largeMapsEmpty))
	{
		mapFilter.selectedSegmentIndex = 1;
		[mapFilter setEnabled:NO forSegmentAtIndex:0];
	}
	else if( (!mediumMapsEmpty) && (smallMapsEmpty && largeMapsEmpty))
	{
		mapFilter.selectedSegmentIndex = 2;
		[mapFilter setEnabled:NO forSegmentAtIndex:0];
	}
	else if( (!largeMapsEmpty) && (mediumMapsEmpty && smallMapsEmpty))
	{
		mapFilter.selectedSegmentIndex = 3;
		[mapFilter setEnabled:NO forSegmentAtIndex:0];
	}
	else
	{
		[mapFilter setEnabled:YES forSegmentAtIndex:0];
		mapFilter.selectedSegmentIndex = 0;
	}

	

	
	loadingResults = NO;
	dataLoaded = YES;

	[loadingSpinner stopAnimating];
	
	self.tableView.scrollEnabled = [maps count] > 0;
	[self.tableView reloadData];	
	
    // release the connection, and the data object
    [theConnection release];
  //  [receivedData release];
}

- (void) refreshWithLocation: (CLLocationCoordinate2D) theLocation
{
	
	 NSString* request_url = [NSString stringWithFormat: @"%@lat=%f&long=%f", kLAT_LONG_SEARCH,
					theLocation.latitude, theLocation.longitude];
	 
	 
	 [self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:request_url]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:15.0]
				searchLocation: theLocation ];
	 
	
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
	
#ifdef DEBUG 
	
	NSLog(@"AbstractMapListController dealloc.");
	
#endif
	
	[receivedData release];
	
	
	[mapController release];
	[maps release];
	
	[loadingSpinner release];
	[statusLabel release];
	
	[super dealloc];

	
	
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	

		return [currentMapList count];


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
	
	Map* theMap = [currentMapList objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%d",theMap.year];
	//cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",theMap.atlasName,theMap.name];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",theMap.atlasName];
	//cell.detailTextLabel.text = theMap.atlasName;

	cell.textLabel.textColor = [UIColor brownColor];

	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:26.0];
	cell.detailTextLabel.textColor = [UIColor grayColor];

	cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:12.0];

	
	
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
	return 85.0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	
	NSUInteger row = [maps indexOfObject:[currentMapList objectAtIndex: indexPath.row]];
	
    if (row != NSNotFound) {
		BOOL fromGeoSearch = NO;
		if([self isKindOfClass:[LocationController class]])
			if (((LocationController *)self).fromGeographicSearch)
				fromGeoSearch = YES;
		
		if(haveLocation && !fromGeoSearch)
		{
			BOOL shouldUpdateMarker = [self isKindOfClass:[LocationController class]];
			[mapController loadMapAtIndex: indexPath.row withMarkerLocation: searchLocation shouldUpdate: shouldUpdateMarker];
		}
		else
		{
			[mapController loadMapAtIndex: indexPath.row];
		}
		
        [[self navigationController] pushViewController:mapController animated:YES];
		
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		
    }
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}



/*

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
*/


@end
