//
//  Locator.h
//  History
//
//  Created by Martin Ceperley on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Locator : NSObject {
	
	CLLocationManager* locationManager;

}

@property (nonatomic, retain) CLLocationManager *locationManager;

+(Locator *) sharedLocator;
+(CLLocationManager *) sharedLocationManager;
+(CLLocationManager *) locationManagerWithDelegate: (id <CLLocationManagerDelegate>) del;


@end