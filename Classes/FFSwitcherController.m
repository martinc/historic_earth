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

	switcher = [[UISegmentedControl alloc] initWithItems:
									[NSArray arrayWithObjects: @"Featured", @"Favorites", nil]];
		
	switcher.segmentedControlStyle = UISegmentedControlStyleBar;
	
	int index = [[NSUserDefaults standardUserDefaults] integerForKey:@"featuredFavoritesState"];
	
	if(index < 0 || index > 1)
	{
		index = 0;
	}
	
	switcher.selectedSegmentIndex = index;
	
	
	
	[switcher setWidth:80.0 forSegmentAtIndex:0];
	[switcher setWidth:80.0 forSegmentAtIndex:1];
	
	[switcher addTarget:self action:@selector(updateView) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.titleView = switcher;
	
	featured = [[FeaturedController alloc] initWithStyle:UITableViewStyleGrouped];
	favorites = [[FavoritesController alloc] initWithStyle:UITableViewStyleGrouped];
	
	
	[self updateView];

	
}

-(void) updateView
{
	
	if (switcher.selectedSegmentIndex == 0)
	{
		self.view = featured.view;
	}
	else
	{
		self.view = favorites.view;
	}
	
	[[NSUserDefaults standardUserDefaults] setInteger: switcher.selectedSegmentIndex forKey:@"featuredFavoritesState"];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
}

 /*
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

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
