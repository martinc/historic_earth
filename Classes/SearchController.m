//
//  SearchController.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchController.h"




@implementation SearchController




- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	REQUEST_URL = kSEARCH_BY_ADDRESS_URL;

	
	
	searching = NO;
	letUserSelectRow = YES;
	
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
	searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	searchBar.delegate = self;
	
	searchBar.barStyle = self.navigationController.navigationBar.barStyle;
	//searchBar.tintColor = self.navigationController.navigationBar.tintColor;
	searchBar.translucent = self.navigationController.navigationBar.translucent;
	
	searchBar.placeholder = @"Street, City, State";
	


	
	//searchBar.prompt = @"Address";
	
	//[searchBar setShowsCancelButton:YES animated:NO];
	

	
	self.tableView.tableHeaderView = searchBar;
	
	//self.tableView.bounds = CGRectMake(0, 100, 320, 380);
	
	self.tableView.scrollEnabled = NO;
	
	
	[loadingSpinner stopAnimating];
	
	
	NSString *lastSearchText = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSearchText"];
	if(lastSearchText != nil)
	{
		searchBar.text = lastSearchText;
		[self searchTableView];
	}
	
	
	
	/* toolbar - wrong approach
	UIBarButtonItem* toolbarItem = [[UIBarButtonItem alloc] initWithCustomView: searchBar];
	[self setToolbarItems:[NSArray arrayWithObject:toolbarItem] animated:YES];
	[self.navigationController setToolbarHidden:NO animated:YES];
	 */
	
	//[self setToolbar

	/*
	
	theSearchController = [[UISearchDisplayController alloc]
						initWithSearchBar:searchBar contentsController:self];
	theSearchController.searchResultsDataSource = self;
	theSearchController.searchResultsDelegate = self;
	*/
	
	
}

- (void) searchTableView
{
	
	NSString *searchText = searchBar.text;
	
	
	
	NSArray *searchComponents = [searchText componentsSeparatedByString:@","];

	
	//NSLog(@"search components are %@", searchComponents);

	if([searchComponents count] == 3)
	{
	
			NSString *addressString = [[searchComponents objectAtIndex:0] stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *cityString = [[searchComponents objectAtIndex:1] stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *stateString = [[searchComponents objectAtIndex:2] stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];

			
			

		
		NSString *requestURL = [[NSString stringWithFormat:@"%@a=\"%@\"&c=\"%@\"&s=\"%@\"",
								kSEARCH_BY_ADDRESS_URL,
								addressString,
								cityString,
								stateString] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
		
		//NSLog(@"search request url is \"%@\"", requestURL);

		
		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]
													cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:15.0]];
		
		[[NSUserDefaults standardUserDefaults] setObject:searchText forKey:@"lastSearchText"];

	}
	else{
		/*
		NSString *requestURL = [[NSString stringWithFormat:@"%@a=\"%@\"",
								 kSEARCH_BY_ADDRESS_URL,
								 searchText]
								stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
		
		[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]
													cachePolicy:NSURLRequestUseProtocolCachePolicy
												timeoutInterval:15.0]];
		
		[[NSUserDefaults standardUserDefaults] setObject:searchText forKey:@"lastSearchText"];
		*/
		
		
		UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Search"
										   message:@"Please enter your address using two commas in the form Street, City, State." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];

		[alert show];
		
		
	}
	
	[self doneSearching];
	
	
}

- (void) cancelSearching
{
	searchBar.text = @"";
	[self doneSearching];
	
}

- (void) doneSearching 
{

	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	
	self.tableView.scrollEnabled = [maps count] > 0;
	
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
											   target:self action:@selector(cancelSearching)] autorelease];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {


	if([searchBar.text length] > 0) {
		
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
		[self cancelSearching];
	}
	
}


- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

- (void) dealloc
{

	[REQUEST_URL release];
	[searchBar release];
	[super dealloc];
	
}

@end
