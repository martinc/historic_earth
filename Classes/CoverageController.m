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
	
	
	
	NSString *requestURL = 
	@"http://www.historicmapworks.com/iPhone/request.php?typename=topp%3AGIS_Coverage&SERVICE=WFS&VERSION=1.0.0&REQUEST=GetFeature&SRS=EPSG%3A4326&BBOX=-71.156215667721,42.346352644152,-70.972881317143,42.377099036244";
	
	NSString *results = [NSString stringWithContentsOfURL:[NSURL URLWithString:requestURL]];
	
	NSLog(@"coverage results: %@", results);
	
	
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


@end
