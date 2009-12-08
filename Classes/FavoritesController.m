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


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
		favorites = [[NSMutableArray alloc] initWithCapacity:5];

		maps = [[NSMutableArray alloc] initWithCapacity:5];
		
		
		context = [(HistoryAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		
		
		NSDictionary* fetchRequests = [[NSManagedObjectModel mergedModelFromBundles:nil] fetchRequestTemplatesByName];
		
		for(NSString* k in [fetchRequests allKeys])
		{
			NSFetchRequest* request = [fetchRequests objectForKey:k];
			
			NSError *error;
			NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
			if (mutableFetchResults == nil) {
				// Handle the error.
				NSLog(@"error fetching key %@", k);
			}
			
			
			NSLog(@"fetch request name: %@ count: %d", k, [mutableFetchResults count]);
			
			if ([k isEqualToString:@"allFavoritesRequest"])
			{
				
				NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
				NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
				[request setSortDescriptors:sortDescriptors];
				[sortDescriptors release];
				[sortDescriptor release];
				
				
				favorites = mutableFetchResults;
				
				[maps removeAllObjects];
				
				for(NSManagedObject* fav in favorites)
				{
					[maps addObject:[fav valueForKey:@"map"]];
				}
				
			}
			
		}

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



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated: YES];
	[self.navigationController setToolbarHidden:YES animated:YES];
	
	self.parentViewController.navigationItem.rightBarButtonItem = self.editButtonItem;


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
	

	/*
	cell.textLabel.textColor = [UIColor brownColor];
	
	cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:26.0];
	cell.detailTextLabel.textColor = [UIColor grayColor];
	
	cell.detailTextLabel.font = [UIFont fontWithName:@"Georgia" size:12.0];
	*/
	

	
    return cell;
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
	return 85.0;
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

		
        [[self navigationController] pushViewController:mapview animated:YES];
		
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

