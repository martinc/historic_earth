//
//  Locator.m
//  History
//
//  Created by Martin Ceperley on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Locator.h"


@implementation Locator

@synthesize locationManager;

static Locator *sharedLocator = nil;

- (id) init 
{
	self = [super init];
	
	if(self != nil) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = kCLDistanceFilterNone;
		
#ifdef DEBUG 
		NSLog(@"initted location manager, it is class %@", [self.locationManager class]);
#endif
		
	}
	
	
	return self;
}


+ (Locator *) sharedLocator {
    @synchronized(self) {
        if (sharedLocator == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedLocator;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedLocator == nil) {
            sharedLocator = [super allocWithZone:zone];
            return sharedLocator;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}





+ (CLLocationManager *) sharedLocationManager {
	
#ifdef DEBUG 
	NSLog(@"sharedLocationManager, it is class %@", [[Locator sharedLocator].locationManager class]);
#endif
	
    return [Locator sharedLocator].locationManager;

}

+(CLLocationManager *) locationManagerWithDelegate: (id <CLLocationManagerDelegate>) del
{
	CLLocationManager* newLocationManager;
	
	if(sharedLocator == nil){
		newLocationManager = [Locator sharedLocationManager];
	}
	else {
		[sharedLocator.locationManager release];
		newLocationManager = [[CLLocationManager alloc] init];
	}
	
	newLocationManager.delegate = del;
	newLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
	newLocationManager.distanceFilter = kCLDistanceFilterNone;

	sharedLocator.locationManager = newLocationManager;
	
	
	return newLocationManager;
	
}


- (void) dealloc
{
	//[locationManager release];
	[super dealloc];
}


@end