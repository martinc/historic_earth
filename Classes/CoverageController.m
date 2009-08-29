//
//  CoverageController.m
//  History
//
//  Created by Martin Ceperley on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoverageController.h"

@implementation CoverageController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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

- (void) refresh
{
	for(RMPath* aPath in paths)
	{
		[aPath removeFromSuperlayer];
	}
	
	[paths removeAllObjects];
	
	
	//Dummy points that we know we have data
	
	/*
	RMLatLong pointOne, pointTwo;
	pointOne.longitude = -71.156215667721;
	pointOne.latitude = 42.346352644152;
	
	pointTwo.longitude = -70.972881317143;
	pointTwo.latitude = 42.377099036244;
	
	 */
	
	
	RMSphericalTrapezium theRect = [mapView.contents latitudeLongitudeBoundingBoxForScreen];
	

	
	 
	
	//Want to see bounding box for debugging
	
	/*
	 RMPath* debuggingBox = [[RMPath alloc] initForMap:mapView];
	 debuggingBox.fillColor = [UIColor blueColor];
	 
	 RMLatLong cornerOne = { pointOne.latitude, pointTwo.longitude };
	 RMLatLong cornerTwo = { pointTwo.latitude, pointOne.longitude };
	 
	 
	 [debuggingBox addLineToLatLong: pointOne];
	 [debuggingBox addLineToLatLong: cornerOne];
	 
	 [debuggingBox addLineToLatLong: pointTwo];
	 [debuggingBox addLineToLatLong: cornerTwo];
	 
	 [debuggingBox closePath];
	 
	 [mapView.contents.overlay addSublayer:debuggingBox];
	 */
	
	NSString *requestURL = [[NSString stringWithFormat:
							 @"http://www.historicmapworks.com/iPhone/request.php?typename=topp:GIS_Coverage&SERVICE=WFS&VERSION=1.0.0&REQUEST=GetFeature&SRS=EPSG:4326&BBOX=%f,%f,%f,%f",
							 theRect.southwest.longitude, theRect.southwest.latitude, theRect.northeast.longitude, theRect.northeast.latitude]
							stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
	
	NSLog(@"request URL is: \"%@\"", requestURL);
	
	
	
	theConnection=[[NSURLConnection alloc] initWithRequest:
				   [NSURLRequest requestWithURL:
					[NSURL URLWithString:requestURL]]
												  delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		[loadingSpinner startAnimating];
		receivedData=[[NSMutableData data] retain];
		loadingResults = YES;
		[self setRefreshButtonHidden:YES];
		
		
		
	} else {
		// inform the user that the download could not be made
	}
	
	
	
}

- (void) setRefreshButtonHidden: (BOOL) hidden
{
	if(!refreshButton)
		refreshButton = [[ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																	   target:self
																	   action:@selector(refresh)];
	
		
	if(hidden && self.navigationItem.rightBarButtonItem)
		self.navigationItem.rightBarButtonItem = nil;
	else if(!hidden && !self.navigationItem.rightBarButtonItem)
		self.navigationItem.rightBarButtonItem = refreshButton;
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	paths = [[NSMutableArray alloc] initWithCapacity:2];
	
	
	
	
	self.title = @"Coverage Area";
	
	
	mapView = [[RMMapView alloc] initWithFrame:self.view.frame];
	
	CLLocationCoordinate2D center;
	center.latitude = 42.361725840198;
	center.longitude = -71.064548492432;
	
	
	mapView.contents = [[[RMMapContents alloc] initWithView:mapView
													   tilesource:[[[RMOpenStreetMapSource alloc] init] autorelease]
													 centerLatLon:center
														zoomLevel:12.0
													 maxZoomLevel:18.0
													 minZoomLevel:4.0
												  backgroundImage:nil] autorelease];
	
	mapView.backgroundColor = [UIColor clearColor];
	mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	
	[self.view addSubview: mapView];
	
	
	
#pragma mark setting up to load xml 
	
	loadingResults = NO;
	
	loadingSpinner = [[UIActivityIndicatorView alloc]
					  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	loadingSpinner.hidesWhenStopped = YES;
	loadingSpinner.center = CGPointMake(320/2, 480/2);
	
	[self.view addSubview:loadingSpinner];
		
	
	
	[self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}


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


- (void)dealloc {
    [super dealloc];
}


#pragma mark url connection


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
	
	NSMutableString* dataString =  [[NSMutableString alloc]
							 initWithData: receivedData
							 encoding: NSUTF8StringEncoding];
	
	//remove Namespace
	
	//	<gml:coordinates xmlns:gml="http://www.opengis.net/gml" decimal="." cs="," ts=" ">
	
	
	NSRange searchingRange = NSMakeRange(0, [dataString length]);
	int loopCount = 0;
	
	NSRange theRange;
	
	//Loop for both sets of coordinates
	do {
		loopCount++;
			
		 theRange = [dataString rangeOfString:@"<gml:coordinates xmlns:gml=\"http://www.opengis.net/gml\" decimal=\".\" cs=\",\" ts=\" \">"
											 options:0
											   range: searchingRange];
		
		if(theRange.length > 0){
			//NSLog(@"first occurrence at %d %d", theRange.location, theRange.length);
			NSRange searchForEndRange = NSMakeRange( theRange.location+theRange.length, [dataString length] - (theRange.location+theRange.length) );
			
			
			NSRange endingRange = [dataString rangeOfString: @"</gml:coordinates>"
							options: 0 
							  range: searchForEndRange];

			
			NSRange contentRange = NSMakeRange(searchForEndRange.location, endingRange.location - searchForEndRange.location);
			
			NSString *theCoordinateString = [dataString substringWithRange:contentRange];
			
			NSArray* theCoordinateStrings = [theCoordinateString componentsSeparatedByString:@" "];
			
			
			NSMutableArray* coveragePoints = [[NSMutableArray alloc] initWithCapacity:100];
			
			
			RMPath* thePath = [[RMPath alloc] initForMap: mapView];
			
			//thePath.lineColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
			
			if(loopCount == 1)
				thePath.fillColor = [[UIColor redColor] colorWithAlphaComponent: 0.4];
			else
				thePath.fillColor = [[UIColor greenColor] colorWithAlphaComponent: 0.4];

			thePath.lineColor = [thePath.fillColor colorWithAlphaComponent:1.0];

			thePath.lineWidth = 10;

			BOOL firstPoint = YES;
			
			int pointCount = 0;
			CLLocationCoordinate2D averageLocation = { 0 , 0 };
			
			for(NSString *theString in theCoordinateStrings)
			{	

				NSArray* theComponets = [theString componentsSeparatedByString:@","];
				
				NSNumber* longitude = [NSNumber numberWithFloat:[[theComponets objectAtIndex:0] floatValue]];
				NSNumber* latitude = [NSNumber numberWithFloat:[[theComponets objectAtIndex:1] floatValue]];
				
				NSDictionary* theCoordinate = [NSDictionary dictionaryWithObjectsAndKeys: longitude, @"longitude", latitude, @"latitude", nil];
				
				[coveragePoints addObject:theCoordinate];

				RMLatLong thePoint;
				thePoint.longitude = [longitude doubleValue];
				thePoint.latitude = [latitude doubleValue];
				
				[thePath addLineToLatLong: thePoint];
				
				
				if(firstPoint){
					firstPoint = NO;
					[mapView moveToLatLong:thePoint];
				}
				
				//NSLog(@"Point at long: %f lat: %f", longitude, latitude);
				
				
				pointCount++;
				averageLocation.longitude += thePoint.longitude;
				averageLocation.latitude += thePoint.latitude;
			}
			
			[thePath closePath];
			[mapView.contents.overlay addSublayer:thePath];
			
			NSLog(@"path has length %d", pointCount);
			
			averageLocation.longitude /= pointCount;
			averageLocation.latitude /= pointCount;
			
			
			
			
			searchingRange.location = contentRange.location + contentRange.length;
			searchingRange.length = [dataString length] - searchingRange.location;
			
			[paths addObject:thePath];
			[thePath release];
			
			
			//Marker
			
			RMMarker* aMarker = [[RMMarker alloc] initWithUIImage: [UIImage imageNamed:@"marker-blue.png"] anchorPoint: CGPointMake(0.5, 1.0)];
			
			[mapView.markerManager addMarker:aMarker AtLatLong: averageLocation];
			

		}// end if therange.length > 0
		
		
	} while (theRange.length > 0);
		
		

	loadingResults = NO;
	[loadingSpinner stopAnimating];
	
	[self setRefreshButtonHidden:NO];

	

	[dataString release];
	[theConnection release];
	[receivedData release];
}


@end
