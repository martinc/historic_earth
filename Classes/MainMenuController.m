//
//  MainMenuController.m
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"
#import "Locator.h"


@implementation MainMenuController


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
		
		contentEnabled = YES;
		

		UIImage* searchIcon = [UIImage imageNamed:@"06-magnifying-glass.png"];
		UIImage* unlockIcon = [UIImage imageNamed:@"24-gift.png"];
		UIImage* settingsIcon = [UIImage imageNamed:@"20-gear2.png"];
		UIImage* featuredIcon = [UIImage imageNamed:@"28-star.png"];
		UIImage* locationIcon = [UIImage imageNamed:@"74-location.png"];
		UIImage* aboutIcon = [UIImage imageNamed:@"14-tag.png"];
		UIImage* coverageIcon = [UIImage imageNamed:@"73-radar.png"];
		UIImage* helpIcon = [UIImage imageNamed:@"question-mark.png"];



		
		searchData =  [[NSMutableDictionary alloc] initWithObjectsAndKeys:
						  @"Search", @"name",
						  @"searchController", @"controller",
						  searchIcon, @"image",
					   nil];

		additionContentData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					 @"Additional Content", @"name",
					 @"unlockController", @"controller",
					 unlockIcon, @"image",
					 nil];
		
		mainMenuData = [[NSMutableArray alloc] initWithObjects:
						[NSMutableArray arrayWithObjects:
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Map My Location", @"name",
						  @"locationController", @"controller",
						  locationIcon, @"image",
						  nil],
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Featured & Favorites", @"name",
						  @"ffSwitcherController", @"controller",
						  featuredIcon, @"image",
						  nil],
						/* [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Favorites", @"name",
						  @"favoritesController", @"controller",
						  featuredIcon, @"image",
						  nil], */
						 nil],
						[NSMutableArray arrayWithObjects:
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Coverage Area", @"name",
						  @"coverageController", @"controller",
						  coverageIcon, @"image",
						  nil],
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Help", @"name",
						  @"helpController", @"controller",
						  helpIcon, @"image",
						  nil],
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"Settings", @"name",
						  @"settingsController", @"controller",
						  settingsIcon, @"image",
						  nil],
						 [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  @"About", @"name",
						  @"aboutController", @"controller",
						  aboutIcon, @"image",
						  nil],
						 nil],
						nil];
		//Enable search always for development
		//if([[NSUserDefaults standardUserDefaults] boolForKey:@"searchEnabled"])
		if([[NSUserDefaults standardUserDefaults] boolForKey:kSEARCH_ENABLED])
		{
		
			searchVisible = YES;
			[[mainMenuData objectAtIndex:0] insertObject: searchData
												 atIndex:[[mainMenuData objectAtIndex:0] count] ];
		}
		else{
			searchVisible = NO;

		}
		
		//Set enabled/disabled buttons
		
		for(NSArray* sectionArray in mainMenuData){
			for(NSMutableDictionary* theCell in sectionArray){
				[theCell setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
			}
		}
		
		//If location services are disabled, disable Map My Location
		
		CLLocationManager* testLocManager = [Locator sharedLocationManager];
		if(testLocManager.locationServicesEnabled == NO)
		{
			[[[mainMenuData objectAtIndex:0] objectAtIndex:0] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
			
			UIAlertView* locationDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
																			message:@"Map My Location is disabled because Location Services are disabled for all applications on this device. Location Services can be enabled in the Settings app, under the General section."
																		   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			
			[locationDisabledAlert show];	
			[locationDisabledAlert release];
			
			
		}
		//[testLocManager release];
		


    }
    return self;
}


- (void) locationController
{
	[self.navigationController pushViewController: [[[LocationController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]
										 animated:YES];
}
- (void) unlockController
{
//	[self.navigationController pushViewController: [[[UnlockController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]
//										 animated:YES];


	[self.navigationController pushViewController:
	 [[[PurchaseController alloc] initWithProduct:product] autorelease]
										 animated: YES];
	

}
- (void) ffSwitcherController
{
	[self.navigationController pushViewController: [[[FFSwitcherController alloc] init] autorelease]
										 animated:YES];	
}
- (void) featuredController
{
	[self.navigationController pushViewController: [[[FeaturedController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]
										 animated:YES];	
}
- (void) favoritesController
{
	[self.navigationController pushViewController: [[[FavoritesController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]
										 animated:YES];	
}

- (void) settingsController
{
	[self.navigationController pushViewController: [[[SettingsController alloc] initHaveNetwork:contentEnabled] autorelease]
										 animated:YES];

}
- (void) searchController
{
	[self.navigationController pushViewController: [[[SearchController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]
										 animated:YES];	
}
- (void) aboutController
{
	[self.navigationController pushViewController: [[[AboutController alloc] initWithNibName:@"AboutController" bundle:nil] autorelease]
										 animated:YES];	
}
- (void) helpController
{
	[self.navigationController pushViewController: [[[HelpController alloc] init] autorelease]
										 animated:YES];	
}
- (void) coverageController
{
	/*
	[self.navigationController pushViewController: [[[CoverageController alloc] init] autorelease]
										 animated:YES];	
	 */

	NSManagedObjectContext* theContext = [(HistoryAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	Map* coverageMap = [NSEntityDescription insertNewObjectForEntityForName:@"Map" inManagedObjectContext:theContext];
	
	//[theContext assignObject:coverageMap toPersistentStore:
	 //[((HistoryAppDelegate *)[[UIApplication sharedApplication] delegate]) inMemoryStore]];
	

	//Map* coverageMap = [[Map alloc] init];
	coverageMap.layerID = kCOVERAGE_LAYER_ID;
	coverageMap.atlasName = @"Coverage Area";
	coverageMap.name = @"Coverage";
	coverageMap.year = 2009;
	CLLocationCoordinate2D center;
	//center.latitude = 41.866;
	//center.longitude = -72.936;
	
	//US Center with minZoom 2
	//center.latitude = 37.603;
	//center.longitude = -96.028;
	
	//international center with minZoom 0
	
		

			
	center.latitude = 40.869575;
	center.longitude = -21.496751;
	coverageMap.mapCenter = center;
	//coverageMap.minZoom = 4;
	coverageMap.minZoom = 0;
			
		
		

	coverageMap.initialOpacity = 0.6;
	
	NSMutableArray* coverageMaps = [NSMutableArray arrayWithObject:coverageMap];
	//[coverageMap release];
	
	MapViewController* mapview = [[MapViewController alloc] initWithMaps:coverageMaps allowCompass:NO];
	[mapview loadMapAtIndex:0];

	mapview.title = @"Coverage";
	
	[self.navigationController pushViewController: mapview animated:YES];
	
	[mapview release];
	
	 
}



- (void)viewDidLoad {
    [super viewDidLoad];
	

	
	
	self.title = @"Menu";
	
	self.view.backgroundColor = [UIColor clearColor];
	
	self.hidesBottomBarWhenPushed = YES;
	
	
	/*
	UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	headerLabel.text = @"Historic Earth";
	headerLabel.font = [UIFont fontWithName:@"Georgia" size:28];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textAlignment = UITextAlignmentCenter;
	self.tableView.tableHeaderView = headerLabel;
	[headerLabel release];
	 */
	
	UIImage* headerImage = [UIImage imageNamed:@"he_mainmenu_2.png"];
	UIImageView* headerImageView = [[UIImageView alloc] initWithImage:headerImage];
	
	headerImageView.frame = CGRectMake(0, 0, 320, 130);
	headerImageView.contentMode = UIViewContentModeBottom;
	headerImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
	self.tableView.tableHeaderView = headerImageView;
	
	[headerImageView release];
	
	//self.tableView.backgroundColor = [UIColor blueColor];


    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	

}


- (void) makeSearchAppear
{

	
	if(!searchVisible)
	{
		[self.tableView beginUpdates];
		
		//Insert search at end of first section
		
			NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:[[mainMenuData objectAtIndex:0] count] inSection:0];
			[[mainMenuData objectAtIndex:0] insertObject:searchData atIndex:newIndexPath.row];		
			[self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: newIndexPath] withRowAnimation:UITableViewRowAnimationTop];

		//If store is present remove it from end of second section -- count HARD CODED
		
			if([[mainMenuData objectAtIndex:1] count] == 5)
			{
				NSIndexPath* additionContentIndex = [NSIndexPath indexPathForRow:[[mainMenuData objectAtIndex:1] count]-1 inSection:1];
				[[mainMenuData objectAtIndex:1] removeObject:additionContentData];
				[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: additionContentIndex] withRowAnimation:UITableViewRowAnimationFade];
			}

		[self.tableView endUpdates];


	}
}

-(void) addStoreWithProduct: (SKProduct *) theProduct
{
	
	product = [theProduct retain];
	NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:[[mainMenuData objectAtIndex:1] count] inSection:1];

	[[mainMenuData objectAtIndex:1] insertObject: additionContentData
										 atIndex: newIndexPath.row ];
	
	[self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
	
	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated: animated];
	[self.navigationController setToolbarHidden:YES animated: animated];

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return YES;
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
	//NSLog(@"setting up cell %d, %d", indexPath.section, indexPath.row);
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
	
	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:15.0];
	cell.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	//cell.indentationWidth = 20.0;
	//cell.indentationLevel = 1;
	
	cell.textLabel.textAlignment = UITextAlignmentLeft;
	
	UIImage* theIcon = [[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"];

	//NSLog(@"the icon size is %f,%f", theIcon.size.width, theIcon.size.height);
	
	cell.imageView.image = 	theIcon;
	
	
	BOOL amIenabled = [[[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"enabled"] boolValue];

	if(!amIenabled){
		cell.textLabel.textColor = [UIColor grayColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	id theController = [[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"controller"];
	if(theController != [NSNull null]){
		[self performSelector:NSSelectorFromString(theController)];
	}
	
	
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	id theController = [[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"controller"];
	if(theController != [NSNull null]){
		[self performSelector:NSSelectorFromString(theController)];
	}
	
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//if(contentEnabled)
	//	return indexPath;
	
	
	if([[[[mainMenuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"enabled"] boolValue])
	{
		return indexPath;
	}
	//Allow settings and about and help to go through without network connection
	//if( indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) )
	//	return indexPath;

	
	return nil;
	
}

-(void) enableContent
{
	contentEnabled = YES;
	
	for(NSArray* sectionArray in mainMenuData){
		for(NSMutableDictionary* theCell in sectionArray){
			[theCell setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
		}
	}
	
	[self.tableView reloadData];

	
}
-(void) disableContent
{
	contentEnabled = NO;
	
	for(NSArray* sectionArray in mainMenuData){
		for(NSMutableDictionary* theCell in sectionArray){
			NSString* theController = [theCell objectForKey:@"controller"];
			
			if([theController isEqualToString:@"helpController"] ||
			   [theController isEqualToString:@"settingsController"] ||
			   [theController isEqualToString:@"aboutController"])
			{
				[theCell setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
			}
			else{
				[theCell setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
				
			}
		}
	}
	
	[self.tableView reloadData];
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
	
	[searchData release];
	[additionContentData release];
	[mainMenuData release];
	
	if(product)
		[product release];
	
}


@end

