//
//  HelpController.m
//  History
//
//  Created by Martin Ceperley on 9/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpController.h"


@implementation HelpController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
	
	self.title = @"Help";	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	NSString* helpImageFilename;
	if([[NSUserDefaults standardUserDefaults] boolForKey:kSEARCH_ENABLED]){
		helpImageFilename = @"help-full.png";
	}
	else {
		helpImageFilename = @"help-light.png";
	}
	
	UIImageView* helpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:helpImageFilename]];
	helpImage.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
	[self.view addSubview:helpImage];	
	[helpImage release];
	
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
