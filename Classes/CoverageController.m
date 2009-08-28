//
//  CoverageController.m
//  History
//
//  Created by Martin Ceperley on 8/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoverageController.h"
#import "TouchXML.h"

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
	
	
	
	self.title = @"Coverage Area";
	
	
	RMMapView* mapView = [[RMMapView alloc] initWithFrame:self.view.frame];
	
	CLLocationCoordinate2D center;
	center.latitude = 39.943436;
	center.longitude = -75.344238;
	
	
	mapView.contents = [[[RMMapContents alloc] initWithView:mapView
													   tilesource:[[[RMOpenStreetMapSource alloc] init] autorelease]
													 centerLatLon:center
														zoomLevel:10.0
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
	
	
	NSString *requestURL = 
	@"http://www.historicmapworks.com/iPhone/request.php?typename=topp%3AGIS_Coverage&SERVICE=WFS&VERSION=1.0.0&REQUEST=GetFeature&SRS=EPSG%3A4326&BBOX=-71.156215667721,42.346352644152,-70.972881317143,42.377099036244";
	
	
	
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
		
		
	} else {
		// inform the user that the download could not be made
	}
	
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
	
	NSString* dataString =  [[NSString alloc]
							 initWithData: receivedData
							 encoding: NSUTF8StringEncoding];
	
	NSLog(@"coverage results: %@", dataString);
	
	loadingResults = NO;
	[loadingSpinner stopAnimating];
	

	[dataString release];
	[theConnection release];
	[receivedData release];
}


@end
