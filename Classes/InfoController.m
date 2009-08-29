//
//  InfoController.m
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoController.h"


@implementation InfoController

@synthesize lockSwitch, compassSwitch;

- (IBAction) closeWindow
{

	[self dismissModalViewControllerAnimated:YES];
	
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.hidesBottomBarWhenPushed = NO;


		
    }
    return self;
}

- (IBAction) switchesChanged
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setBool:lockSwitch.on forKey:kLOCK_ENABLED];
	[defaults setBool:compassSwitch.on forKey:kCOMPASS_ENABLED];

	
	NSLog(@"lockSwitchIs %d", lockSwitch.on);
	NSLog(@"compassSwitch %d", compassSwitch.on);

	
	[defaults synchronize];
	
	NSLog(@"set switches");
	
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];

	
	
	lockSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey: kLOCK_ENABLED];
	
	CLLocationManager* testLocationManager = [[CLLocationManager alloc] init];
	if(testLocationManager.headingAvailable){
		compassSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey: kCOMPASS_ENABLED];
	}
	else{
		compassSwitch.on = NO;
		compassSwitch.enabled = NO;
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
