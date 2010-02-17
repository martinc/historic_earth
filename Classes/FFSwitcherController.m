//
//  FFSwitcherController.m
//  History
//
//  Created by Martin Ceperley on 12/8/09.
//  Copyright 2009 Emergence Studios. All rights reserved.
//

#import "FFSwitcherController.h"


@implementation FFSwitcherController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	currentController = nil;
	
	switcher = [[UISegmentedControl alloc] initWithItems:
									[NSArray arrayWithObjects: @"Featured", @"Favorites",/* @"Popular",*/ nil]];
		
	switcher.segmentedControlStyle = UISegmentedControlStyleBar;
	switcher.tintColor = [UIColor darkGrayColor];

	
	initialSegment = [[NSUserDefaults standardUserDefaults] integerForKey:@"featuredFavoritesState"];
	
	if(initialSegment < 0 || initialSegment > 1)
	{
		initialSegment = 0;
	}
	
	switcher.selectedSegmentIndex = initialSegment;
	
	
	[switcher setWidth:120.0 forSegmentAtIndex:0];
	//[switcher setWidth:120.0 forSegmentAtIndex:1];
	[switcher setWidth:120.0 forSegmentAtIndex:1];

	
	[switcher addTarget:self action:@selector(updateView) forControlEvents:UIControlEventValueChanged];
	
	//self.navigationItem.titleView = switcher;
	
	UIBarButtonItem* spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];
	UIBarButtonItem* switcherItem = [[[UIBarButtonItem alloc] initWithCustomView:switcher] autorelease];
	
	self.toolbarItems = [NSArray arrayWithObjects:spacer,switcherItem,spacer,nil];
	
	featured = [[FeaturedController alloc] initWithNavController:self.navigationController];
	favorites = [[FavoritesController alloc] initWithNavController:self.navigationController];
	
	firstLoad = YES;
	
	//self.view.frame = [self correctedRect];

	
	
}

-(CGRect) correctedRect 
{
	float navBarHeight = self.navigationController.navigationBar.frame.size.height;
	
	float toolbarHeight = self.navigationController.toolbar.frame.size.height;

	
	CGRect windowFrame = self.view.window.frame;
	
	CGRect theRect = CGRectMake(0, navBarHeight, windowFrame.size.width, windowFrame.size.height - navBarHeight - toolbarHeight);
	
//	NSLog(@"windowFrame: %@ correctedRect: %@",
//		  NSStringFromCGRect(windowFrame), NSStringFromCGRect(theRect));

	
	return theRect;
	
}

-(void) updateView
{
	
	
	if (switcher.selectedSegmentIndex == 0)
	{
		if(currentController == favorites)
			[favorites.view removeFromSuperview];
		

		[self.view addSubview: featured.view];
		currentController = featured;
		featured.view.frame = [self correctedRect];


		self.navigationItem.rightBarButtonItem = nil;
		
		self.title = @"Featured";

	}
	else
	{
		if(currentController == featured)
			[featured.view removeFromSuperview];

		[self.view addSubview: favorites.view];
		currentController = favorites;
		favorites.view.frame = [self correctedRect];
		[favorites fetchData];

		
		self.title = @"Favorites";


	}
	
	firstLoad = NO;
	
	[[NSUserDefaults standardUserDefaults] setInteger: switcher.selectedSegmentIndex forKey:@"featuredFavoritesState"];

}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController setToolbarHidden:NO animated:YES];

	if (currentController == favorites) {
		[favorites fetchData];
	}
	

}

 
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self updateView];


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


@end
