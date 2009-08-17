//
//  MapViewController.m
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

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
	[super loadView];
	
	
	mapView = [[RMMapView alloc] initWithFrame:self.view.frame];
	
	
	
	mapView.contents = [[RMMapContents alloc] initForView:mapView];
	mapView.contents.tileSource = [[RMCloudMadeMapSource alloc]
								   initWithAccessKey:@"0155d705a5a05e6988534761f6fd2ca5"
								   styleNumber:5260];

	
	mapView.backgroundColor = [UIColor clearColor];
	mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	
	[self.view addSubview: mapView];
	
	
	self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
	self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
	self.navigationController.toolbar.translucent = self.navigationController.navigationBar.translucent;
	
	
	NSString *backarrow = @"◀";
	NSString *forwardarrow = @"▶";
	NSArray *itemArray = [NSArray arrayWithObjects: backarrow, forwardarrow, nil];
	
	UISegmentedControl* segmented = [[UISegmentedControl alloc] initWithItems:itemArray];
	//segmented.segmentedControlStyle = UISegmentedControlStylePlain;
	//segmented.segmentedControlStyle = UISegmentedControlStyleBordered;
	segmented.segmentedControlStyle = UISegmentedControlStyleBar;

	UIBarButtonItem* backForward = [[UIBarButtonItem alloc] initWithCustomView:segmented];
	
	 //self.navigationItem.rightBarButtonItem = backForward;

	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	
	spinner.hidesWhenStopped = NO;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: spinner];
	
	
	//UISlider* slider = [[UISlider alloc] init];
	UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(0,0,170,20)];
	
	slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	//UIView* sliderView = [[UIView alloc] initWithFrame:slider.frame];
	//[sliderView addSubview:slider];
	//UISlider* slider = [[UISlider alloc] init];
	
	UIBarButtonItem* past = [[UIBarButtonItem alloc] initWithTitle:@"1776" style:UIBarButtonItemStylePlain target:nil action:NULL];

	//get current year for toolbar
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components: NSYearCalendarUnit fromDate:today];
	NSInteger year = [weekdayComponents year];
	
	
	UIBarButtonItem* present = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d",year] style:UIBarButtonItemStylePlain target:nil action:NULL];
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView: slider];
	
	//item.customView.bounds = CGRectMake(0, 0, 100, 100);
	//item.width = 170;
	

	UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
							  
	
	NSArray* items = [[NSArray alloc] initWithObjects: past, space, item, space, present, nil ];
	
	[space release];
	[item release];
	[past release];
	[present release];
	[slider release];
	
	[self setToolbarItems:items animated: NO ];
	
	[items release];
	self.hidesBottomBarWhenPushed = NO;
	
	
	/*
	currentRoation = 0;	
	[NSTimer scheduledTimerWithTimeInterval:1/30.0  target:self selector:@selector(rotate) userInfo:nil repeats:YES];
	 */
	
//	[self.navigationController setToolbarHidden:NO animated: YES];
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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


- (void)viewWillAppear:(BOOL)animated {
	
	[self.navigationController setToolbarHidden:NO animated: animated];

	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[self.navigationController setToolbarHidden:YES animated: animated];

	
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void)rotate
{
	currentRoation += .01;
	mapView.transform = CGAffineTransformMakeRotation(currentRoation);	
}


@end
