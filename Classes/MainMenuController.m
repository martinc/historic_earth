//
//  MainMenuController.m
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"


@implementation MainMenuController


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
		//self.tableView.frame = CGRectMake(40, 0, 240, 480);
		
		locationController = [[LocationController alloc] initWithStyle:UITableViewStyleGrouped];
		searchController = [[SearchController alloc] initWithStyle:UITableViewStyleGrouped];
		unlockController = [[UnlockController alloc] initWithStyle:UITableViewStyleGrouped];
		
		NSString* locationIconPath = [[NSBundle mainBundle] pathForResource:@"74-location" ofType:@"png" inDirectory:@"Images"];
		UIImage* locationIcon = [[UIImage alloc] initWithContentsOfFile:locationIconPath];
		
		NSString* featuredIconPath = [[NSBundle mainBundle] pathForResource:@"28-star" ofType:@"png" inDirectory:@"Images"];
		UIImage* featuredIcon = [[UIImage alloc] initWithContentsOfFile:featuredIconPath];
		
		NSString* settingsIconPath = [[NSBundle mainBundle] pathForResource:@"20-gear2" ofType:@"png" inDirectory:@"Images"];
		UIImage* settingsIcon = [[UIImage alloc] initWithContentsOfFile:settingsIconPath];

		NSString* unlockIconPath = [[NSBundle mainBundle] pathForResource:@"54-lock" ofType:@"png" inDirectory:@"Images"];
		UIImage* unlockIcon = [[UIImage alloc] initWithContentsOfFile: unlockIconPath];

		NSString* searchIconPath = [[NSBundle mainBundle] pathForResource:@"06-magnifying-glass" ofType:@"png" inDirectory:@"Images"];
		UIImage* searchIcon = [[UIImage alloc] initWithContentsOfFile: searchIconPath];

		
		if(locationIcon!=nil) NSLog(@"no error loading image");

		
		mainMenuData = [[NSMutableArray alloc] initWithObjects:
						[NSMutableArray arrayWithObjects:
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Map Your Location", @"name",
						  locationController, @"controller",
						  locationIcon, @"image",
						  nil],
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Featured Collections", @"name",
						  [NSNull null], @"controller",
						  featuredIcon, @"image",
						  nil],
						 nil],
						[NSMutableArray arrayWithObjects:
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Settings", @"name",
						  [NSNull null], @"controller",
						  settingsIcon, @"image",
						  nil],
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Additional Content", @"name",
						  unlockController, @"controller",
						  unlockIcon, @"image",
						  nil],
						 nil],
						nil];
		//Enable search always for development
		//if([[NSUserDefaults standardUserDefaults] boolForKey:@"searchEnabled"])
		if(1)
		{
		
			[[mainMenuData objectAtIndex:0] insertObject:
												 [NSMutableDictionary dictionaryWithObjectsAndKeys:
												  @"Search by Address", @"name",
												  searchController, @"controller",
												  searchIcon, @"image",
												  nil]
												 atIndex:2];
		}

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	

	
	
	self.title = @"Historic Earth";
	
	self.view.backgroundColor = [UIColor clearColor];
	
	self.hidesBottomBarWhenPushed = YES;
	
	
	
	UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	headerLabel.text = @"Historic Earth";
	headerLabel.font = [UIFont fontWithName:@"Georgia" size:28];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textAlignment = UITextAlignmentCenter;
	self.tableView.tableHeaderView = headerLabel;
	[headerLabel release];
	
	//self.tableView.backgroundColor = [UIColor blueColor];


    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated: animated];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mainMenuData count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[mainMenuData objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSLog(@"setting up cell %d, %d", indexPath.section, indexPath.row);
	cell.textLabel.text = [[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];

	
//	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//	cell.backgroundColor = [UIColor clearColor];
//	cell.contentView.backgroundColor = [UIColor clearColor];
//	cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
//	cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground.png"]];
//	cell.contentView.backgroundColor = [UIColor redColor];
	cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	//cell.backgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];

	cell.textLabel.textColor = [UIColor blackColor];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:16.0];
	
	
	UIImage* theIcon = [[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"];

	NSLog(@"the icon size is %f,%f", theIcon.size.width, theIcon.size.height);
	
	cell.imageView.image = 	theIcon;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//if(indexPath.section == 0 && indexPath.row == 0){
		
	//	[self.navigationController pushViewController:locationController animated:YES];
		
		id theController = [[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"controller"];
		
		if(theController != [NSNull null]){
			[self.navigationController pushViewController:(UIViewController *)theController animated:YES];
		}

		
	//}
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

