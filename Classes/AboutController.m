//
//  AboutController.m
//  History
//
//  Created by Martin Ceperley on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutController.h"



@implementation AboutController

@synthesize webView;


- (void) viewWillAppear:(BOOL)animated
{
	self.title = @"About";
	
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	NSMutableString* htmlBody = [[NSMutableString alloc] initWithCapacity:256];
	
	[htmlBody appendString:@"<head></head><body>"];
	[htmlBody appendString:@"Developed by <a href=\"http://emergencestudios.com\">emergence studios</a>"];
	[htmlBody appendString:@"</body>"];
*/
	
	
	 

	NSString* htmlBody = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]
							  encoding:NSUTF8StringEncoding
								 error:NULL];
	 

	
	
	
	[webView loadHTMLString:htmlBody baseURL:nil];
	
	webView.backgroundColor = [UIColor clearColor];
	
	id scrollView = [webView.subviews objectAtIndex:0];
	if( [scrollView respondsToSelector:@selector(setAllowsRubberBanding:)] )
	{
		[scrollView performSelector:@selector(setAllowsRubberBanding:) withObject:NO];
	}
	
//	webView.scrollEnabled = NO;
	
	

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	return YES;
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
