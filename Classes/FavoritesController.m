//
//  FavoritesController.m
//  History
//
//  Created by Martin Ceperley on 12/6/09.
//  Copyright 2009 Emergence Studios. All rights reserved.
//

#import "FavoritesController.h"
#import "HistoryAppDelegate.h"
#import "MapViewController.h"


@implementation FavoritesController


- (id)initWithNavController: (UINavigationController *) theNavController {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		
		
		instructions = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60, 280.0, 60.0)];
		instructions.numberOfLines = 6;
		instructions.font = [UIFont fontWithName:@"Georgia" size:16.0];
		instructions.textAlignment = UITextAlignmentCenter;
		instructions.backgroundColor = [UIColor clearColor];
		instructions.text = @"While browsing, tap the star on the lower right to save the map and location you're looking at.";
		instructions.tag = 66;
		
		favorites = [[NSMutableArray alloc] initWithCapacity:5];

		maps = [[NSMutableArray alloc] initWithCapacity:5];
		
		navController = theNavController;
		
		
		context = [(HistoryAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		
		[self fetchData];
		



		/*
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:context];
		[request setEntity:entity];
		
		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		[sortDescriptor release];
		*/
		/*
		
		NSError *error;
		NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
		if (mutableFetchResults == nil) {
			// Handle the error.
		}
		
		
		
		NSLog(@"found %d favorites", [favorites count]);
		*/
		//[request release];
		
		
    }
    return self;
}

- (void) fetchData
{
	
	NSFetchRequest* fetchRequest = [[NSManagedObjectModel mergedModelFromBundles:nil] fetchRequestTemplateForName:@"allFavoritesRequest"];

	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	
		NSError *error;
		NSMutableArray *mutableFetchResults = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
		if (mutableFetchResults == nil) {
			// Handle the error.
			NSLog(@"error fetching allFavoritesRequest");
		}
		
		
	NSLog(@"total of %d favorites", [mutableFetchResults count]);
	
	/*
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	*/
	
	favorites = mutableFetchResults;
	
	[maps removeAllObjects];
	
	for(NSManagedObject* fav in favorites)
	{
		[maps addObject:[fav valueForKey:@"map"]];
		NSLog(@"fav order is %f", [[fav valueForKey:@"order"] doubleValue]);
	}
	
	[self.tableView reloadData];
		  
		  
		  //find out how many maps
		  
		fetchRequest = [[NSManagedObjectModel mergedModelFromBundles:nil] fetchRequestTemplateForName:@"allMapsRequest"];

	int mapCount = [context countForFetchRequest:fetchRequest error:NULL];
	
		 NSLog(@"map count: %d", mapCount);
	
	
	
	NSLog(@"favorites count is %d", [favorites count]);
	
	if ([favorites count] > 0) {
		NSLog(@"turning edit button on");
		navController.topViewController.navigationItem.rightBarButtonItem = self.editButtonItem;
		
		UILabel* instructs = (UILabel *)[self.view viewWithTag:66];
		
		if(instructs){
			[instructs removeFromSuperview];
			
			self.tableView.scrollEnabled = YES;
		}
	}
	else {
		NSLog(@"turning edit button off");
		navController.topViewController.navigationItem.rightBarButtonItem = nil;

		
		self.tableView.scrollEnabled = NO;
		
		[self.view addSubview:instructions];
	}
		

	
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Favorites";
	
	self.tableView.backgroundColor = [UIColor clearColor];
	
	//UIBarButtonItem* editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
	//																				target:self
	//																				action:@selector(startEditing)];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	

	
	
}

/*
DOESN'T GET CALLED

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated: YES];
	[self.navigationController setToolbarHidden:YES animated:YES];
	

	
	


}
 */

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [favorites count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];

	
	NSManagedObject* theFavorite = [favorites objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [[theFavorite valueForKey:@"map"] valueForKey:@"atlasName"];
	cell.detailTextLabel.text = [[theFavorite valueForKey:@"map"] valueForKey:@"name"];
	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:14.0];
	
	cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:12.0];
	cell.detailTextLabel.textColor = [UIColor brownColor];
	

	cell.showsReorderControl = YES;
	
	/*
	cell.textLabel.textColor = [UIColor brownColor];
	
	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:26.0];
	cell.detailTextLabel.textColor = [UIColor grayColor];
	
	cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:12.0];
	*/
	

	
    return cell;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;	
}
 
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	
	int sourceRow = fromIndexPath.row;
	int destRow = toIndexPath.row;
	
	NSLog(@"move row from %d to %d", sourceRow, destRow);
	
	BOOL isFirst = destRow <= 0;
	BOOL isLast = destRow >= [favorites count] - 1;
	
	NSManagedObject* theFavorite = [favorites objectAtIndex:sourceRow];
	
	NSManagedObject* favBefore = nil;
	NSManagedObject* favAfter = nil;
	
	double theOrder = [[theFavorite valueForKey:@"order"] doubleValue];
	
	if (!isFirst) {
		favBefore = [favorites objectAtIndex:destRow - 1];
	}
	if (!isLast) {
		favAfter = [favorites objectAtIndex:destRow];
	}
	
	if (favBefore && favAfter) {
		double beforeOrder = [[favBefore valueForKey:@"order"] doubleValue];
		double afterOrder = [[favAfter valueForKey:@"order"] doubleValue];
		
		theOrder = (beforeOrder + afterOrder)/2.0;
	}
	else if (favBefore && !favAfter) {
		double order = [[favBefore valueForKey:@"order"] doubleValue];
		theOrder = order - 1.0;
	}
	else if (!favBefore && favAfter) {
		double order = [[favAfter valueForKey:@"order"] doubleValue];
		theOrder = order + 1.0;
	}
	
	[theFavorite setValue:[NSNumber numberWithDouble:theOrder] forKey:@"order"];
	
	
	[context save:NULL];

	NSLog(@"saved new value to %f", theOrder);

	
	/*
	
	if(destRow > sourceRow)
	{
		[favorites insertObject:[favorites objectAtIndex:sourceRow] atIndex:destRow];
		[favorites removeObjectAtIndex:sourceRow];
		[maps insertObject:[maps objectAtIndex:sourceRow] atIndex:destRow];
		[maps removeObjectAtIndex:sourceRow];

	}
	else
	{
		NSManagedObject *sourceFav = [favorites objectAtIndex:sourceRow];
		[favorites removeObjectAtIndex:sourceRow];
		[favorites insertObject:sourceFav atIndex:destRow];
		
		Map *sourceMap = [maps objectAtIndex:sourceRow];
		[maps removeObjectAtIndex:sourceRow];
		[maps insertObject:sourceMap atIndex:destRow];
		
	}
	 
	 */
}
 

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
        NSManagedObject *favoriteToDelete = [favorites objectAtIndex:indexPath.row];
        [context deleteObject:favoriteToDelete];
		
        // Update the array and table view.
        [favorites removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
        // Commit the change.
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"error saving deletion");
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSUInteger row = indexPath.row;
	
    if (row != NSNotFound) {
		
		
		MapViewController* mapview = [[[MapViewController alloc] initWithMaps:maps] autorelease];
		
		[mapview loadMapAtIndex:row];
		
		NSManagedObject* theFavorite = [favorites objectAtIndex:row];
		
		

		NSString* viewportString = [theFavorite valueForKey:@"viewportBoundsString"];
		
		CGRect newMapBoundsRect = CGRectFromString(viewportString);
		
		RMProjectedRect newMapBounds;

		
		newMapBounds.origin.easting = newMapBoundsRect.origin.x;
		newMapBounds.origin.northing = newMapBoundsRect.origin.y;
		newMapBounds.size.width = newMapBoundsRect.size.width;
		newMapBounds.size.height = newMapBoundsRect.size.height;
		
		
		[mapview setProjectedBounds: newMapBounds];

		
		
       [navController pushViewController:mapview animated:YES];
		
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		
    }
	
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

