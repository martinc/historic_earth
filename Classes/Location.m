//
//  Location.m
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location

@synthesize locationID, name;


- (id) initWithName: (NSString *) theName andID: (int) theID
{
	self = [super init];
	
	name = [theName copy];
	locationID = theID;
	
	return self;
}

- (void) dealloc
{

	[name release];
	[super dealloc];
	
}	

@end
