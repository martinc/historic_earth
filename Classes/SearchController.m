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
	
	
	searching = NO;
	letUserSelectRow = YES;
	
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	searchBar.delegate = self;
	
	searchBar.tintColor = self.navigationController.navigationBar.tintColor;
	searchBar.translucent = self.navigationController.navigationBar.translucent;
	
	searchBar.placeholder = @"Enter Address Here";
	//searchBar.prompt = @"Address";
	
	//[searchBar setShowsCancelButton:YES animated:NO];
	

	
	self.tableView.tableHeaderView = searchBar;
	
	
	
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
	NSLog(@"performing search for \"%@\"", searchText);
	
	
	[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oldmapapp.com/test/sample.json"]
												cachePolicy:NSURLRequestUseProtocolCachePolicy
											timeoutInterval:15.0]];	
	
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
	self.tableView.scrollEnabled = YES;
	
	
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
	}
	
}


- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

@end
