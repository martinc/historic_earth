//
//  SearchController.h
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractMapListController.h"



@interface SearchController : AbstractMapListController <UISearchBarDelegate> {
	
	NSString *REQUEST_URL;
	
	//UISearchDisplayController *theSearchController;
	
	UISearchBar *searchBar;
	
	
	
	BOOL searching, letUserSelectRow;

}

- (void) cancelSearching;
- (void) doneSearching;
- (void) searchTableView;


@end
