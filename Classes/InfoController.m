//
//  InfoController.m
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "InfoController.h"
#import "MapViewController.h"
#import "Map.h"


@implementation InfoController

@synthesize lockSwitch, lockLabel, lockImage;
@synthesize compassSwitch, compassLabel, compassImage;
@synthesize yearLabel, atlasLabel, plateLabel, longLabel, latLabel;

- (IBAction) closeWindow
{

	[self dismissModalViewControllerAnimated:YES];
	
}

- (id)initWithMapView:(MapViewController *) theMapViewController {
    if (self = [super initWithNibName:@"InfoView" bundle:nil]) {
		
		self.hidesBottomBarWhenPushed = NO;

		mapViewController = theMapViewController;
		

		
    }
    return self;
}

- (IBAction) switchesChanged
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setBool:lockSwitch.on forKey:kLOCK_ENABLED];
	[defaults setBool:compassSwitch.on forKey:kCOMPASS_ENABLED];

	
	//NSLog(@"lockSwitchIs %d", lockSwitch.on);
	//NSLog(@"compassSwitch %d", compassSwitch.on);

	
	[defaults synchronize];
	
	//NSLog(@"set switches");
	
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	
	Map* theMap = [mapViewController.maps objectAtIndex:mapViewController.currentMapIndex];
	
	yearLabel.text = [NSString stringWithFormat:@"%d", theMap.year];
	atlasLabel.text = theMap.atlasName;
	plateLabel.text = theMap.name;
	
	CLLocationCoordinate2D theCenter = mapViewController.oldMapView.contents.mapCenter;
	
	longLabel.text = [NSString stringWithFormat:@"%0.3f°", theCenter.longitude];
	latLabel.text = [NSString stringWithFormat:@"%0.3f°", theCenter.latitude];


	
	lockSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey: kLOCK_ENABLED];
	
	CLLocationManager* testLocationManager = [[CLLocationManager alloc] init];
	if(testLocationManager.headingAvailable){
		compassSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey: kCOMPASS_ENABLED];
	}
	else{
		compassSwitch.on = NO;
		compassSwitch.enabled = NO;
		compassLabel.enabled = NO;
		compassImage.alpha = 0.5;
	}

	[testLocationManager release];
	
}
 


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


- (void)dealloc {
    [super dealloc];
}


@end
