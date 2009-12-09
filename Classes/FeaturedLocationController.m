//
//  FeaturedLocationController.m
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FeaturedLocationController.h"


@implementation FeaturedLocationController



- (id)initWithLocations: (NSMutableArray *) locs atIndex: (int) theIndex withNavController: (UINavigationController *) theNavController
{

	self = [super initWithStyle:UITableViewStyleGrouped];
	
	navController = theNavController;
	locations = [locs retain];
	currentLocationIndex = theIndex;
	
	[self loadData];
	
	return self;
}


- (void)loadData
{
	
	NSString* REQUEST_URL = [NSString stringWithFormat: @"%@p=%d", kFEATURED_DETAILS,
					((Location *)[locations objectAtIndex:currentLocationIndex]).locationID];
	
	
	[self loadDataWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:REQUEST_URL]
												cachePolicy:NSURLRequestUseProtocolCachePolicy
											timeoutInterval:15.0]];
	
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	[mapController loadMapAtIndex: indexPath.row];

	[navController pushViewController:mapController animated:YES];
}

-(void)dealloc
{
	[locations release];
	[super dealloc];
	
}

@end
