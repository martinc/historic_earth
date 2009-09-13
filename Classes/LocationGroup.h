//
//  LocationGroup.h
//  History
//
//  Created by Martin Ceperley on 8/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"


@interface LocationGroup : NSObject {
	
	NSString* name;
	NSMutableArray* locations;

}

@property (nonatomic, copy) NSString* name;
@property (nonatomic, readonly) NSMutableArray* locations;


- (id) initWithDictionary: (NSDictionary *) jsonData;


@end
