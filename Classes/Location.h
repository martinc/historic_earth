//
//  Location.h
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Location : NSObject {
	
	int locationID;
	NSString* name;

}

- (id) initWithName: (NSString *) theName andID: (int) theID;

@property (nonatomic, assign) int locationID;
@property (nonatomic, retain) NSString* name;

@end
