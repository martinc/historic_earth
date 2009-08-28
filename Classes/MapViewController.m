//
//  MapViewController.m
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id) initWithMaps: (NSMutableArray *) theMaps{
    if (self = [super initWithNibName:nil bundle:nil]) {
        
		maps = [theMaps retain];
		
		currentMapIndex = 0;
		
		infoController = [[InfoController alloc] initWithNibName:@"InfoView" bundle:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateSettings:)
													 name:NSUserDefaultsDidChangeNotification object:nil];
		
		[self updateSettings:nil];
		
		
    }
    return self;
}
-(void) updateSettings: (NSNotification *)notification
{

	//NSLog(@"updateSettings called with notification %@", notification);
	
	locked = [[NSUserDefaults standardUserDefaults] boolForKey:kLOCK_ENABLED];
	compassEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kCOMPASS_ENABLED];

}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
		
	locked = YES;
	
	//NSString *backarrow = @"◀";
	//NSString *forwardarrow = @"▶";
	UIImage *backarrow = [UIImage imageNamed:@"up.png"];
	UIImage *forwardarrow = [UIImage imageNamed:@"down.png"];
	
	NSArray *itemArray = [NSArray arrayWithObjects: backarrow, forwardarrow, nil];
	
	segmented = [[UISegmentedControl alloc] initWithItems:itemArray];
	//segmented.segmentedControlStyle = UISegmentedControlStylePlain;
	//segmented.segmentedControlStyle = UISegmentedControlStyleBordered;
	segmented.segmentedControlStyle = UISegmentedControlStyleBar;
	
	segmented.frame = CGRectMake(0, 0, 90, 30);

	segmented.tintColor = [UIColor darkGrayColor];

	[segmented addTarget:self
						 action:@selector(arrowPressed)
			   forControlEvents:UIControlEventValueChanged];
	

	[self updateArrows];
	

	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	spinner.hidesWhenStopped = YES;
	

	//	spinner.frame = CGRectMake(0, 0, 320, 100);
	
	//[self.view addSubview:spinner];
	//spinner.center = CGPointMake(280, 50);
	//spinner.center = CGPointMake(0, 0);
	
	backForward = [[UIBarButtonItem alloc] initWithCustomView:segmented];
	barSpinner = [[UIBarButtonItem alloc] initWithCustomView: spinner];
	self.navigationItem.rightBarButtonItem = backForward;

	
	//UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
	//UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];

	
	//UISegmentedControl* backSegmented = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Back", @"Back with this location", nil]];
	//backSegmented.segmentedControlStyle = UISegmentedControlStyleBar;
	//UIBarButtonItem* backControls = [[UIBarButtonItem alloc] initWithCustomView:backSegmented];
	//self.navigationItem.leftBarButtonItem = backControls;
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tilesBeganLoading:)
												 name:kTILES_BEGAN_LOADING_NOTIFICATION
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tilesLoaded:)
												 name:kTILES_LOADED_NOTIFICATION
											   object:nil];
	
	
	
	//UISlider* slider = [[UISlider alloc] init];
	slider = [[UISlider alloc] initWithFrame:CGRectMake(0,0,140,20)];
	slider.value = 1.0;
	[slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
	
	slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	//UIView* sliderView = [[UIView alloc] initWithFrame:slider.frame];
	//[sliderView addSubview:slider];
	//UISlider* slider = [[UISlider alloc] init];
	
	NSString *oldYear = [NSString stringWithFormat:@"%d",((Map *)[maps objectAtIndex:currentMapIndex]).year];
	
	UIBarButtonItem* past = [[UIBarButtonItem alloc] initWithTitle:oldYear style:UIBarButtonItemStylePlain target:nil action:NULL];


	//get current year for toolbar
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components: NSYearCalendarUnit fromDate:today];
	NSInteger year = [weekdayComponents year];
	
	[gregorian release];
	
	
	UIBarButtonItem* present = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d",year] style:UIBarButtonItemStylePlain target:nil action:NULL];
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView: slider];
	
	//item.customView.bounds = CGRectMake(0, 0, 100, 100);
	//item.width = 170;
	

	UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
							
	/*
	NSString* lockIconPath = [[NSBundle mainBundle] pathForResource:@"54-lock" ofType:@"png" inDirectory:@"Images"];
	UIImage* lockIcon = [UIImage imageWithContentsOfFile: lockIconPath];
	UIBarButtonItem* theLock = [[UIBarButtonItem alloc] initWithImage:lockIcon style:UIBarButtonItemStyleBordered target:self action:@selector(lockMap)];
	
	NSString* compassIconPath = [[NSBundle mainBundle] pathForResource:@"71-compass" ofType:@"png" inDirectory:@"Images"];
	UIImage* compassIcon = [UIImage imageWithContentsOfFile: compassIconPath];
	UIBarButtonItem* theCompass = [[UIBarButtonItem alloc] initWithImage:compassIcon style:UIBarButtonItemStyleBordered target:self action:@selector(hitCompass)];
	*/
	
	
	infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	infoBarButton.style = UIBarButtonItemStyleBordered;
	//infoBarButton.target = self;
	//infoBarButton.action = @selector(showInfo);

//	[self.navigationController.toolbar addSubview:infoButton];
	
	
	NSArray* items = [[NSArray alloc] initWithObjects: present, space, item, space, past, space , infoBarButton, nil ];
	
	[space release];
	[item release];
	[past release];
	[present release];
	[slider release];
	[infoBarButton release];
	
	self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
	self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
	self.navigationController.toolbar.translucent = self.navigationController.navigationBar.translucent;
	
	[self setToolbarItems:items animated: NO ];

	
	[items release];
	self.hidesBottomBarWhenPushed = NO;
	
	
	
	//Info button
	
	
	//infoButton.center = CGPointMake(300, 440);
	
	
		
	
	/*
	currentRoation = 0;	
	[NSTimer scheduledTimerWithTimeInterval:1/30.0  target:self selector:@selector(rotate) userInfo:nil repeats:YES];
	 */
	
//	[self.navigationController setToolbarHidden:NO animated: YES];
	
}

- (void) showInfo
{

	NSLog(@"showInfo");
	//self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	infoController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:infoController animated:YES];
	
	
}

- (void) updateArrows
{
	[segmented setEnabled:(currentMapIndex != 0) forSegmentAtIndex:0];
	[segmented setEnabled:(currentMapIndex != [maps count]-1) forSegmentAtIndex:1];

	
}

- (void) arrowPressed
{

	//NSLog(@"arrow pressed is %d", segmented.selectedSegmentIndex);
	
	switch (segmented.selectedSegmentIndex) {
		case 0:
			[self loadMapAtIndex: (currentMapIndex-1)%[maps count]];
			break;
		case 1:
			[self loadMapAtIndex: (currentMapIndex+1)%[maps count]];
			break;
	}
	segmented.selectedSegmentIndex = -1;
	[self updateArrows];
	
}

- (void) tilesBeganLoading: (NSNotification *) note
{
	if(spinner){
		self.navigationItem.rightBarButtonItem = barSpinner;
		[spinner startAnimating];
	}
	
}

- (void) tilesLoaded: (NSNotification *) note
{
	if(spinner){
		[spinner stopAnimating];
		self.navigationItem.rightBarButtonItem = backForward;
	}
	
}

- (void) loadMapAtIndex: (int) theIndex withMarkerLocation: (CLLocationCoordinate2D) loc
{
	markerLocation = loc;
	
	[self loadMapAtIndex: theIndex];

	theMarker = [[RMMarker alloc] initWithUIImage: [UIImage imageNamed:@"marker-blue.png"]];

	[oldMapView.markerManager addMarker: theMarker AtLatLong: markerLocation];

	
}



- (void) loadMapAtIndex: (int) theIndex
{
	
	self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
	self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
	self.navigationController.toolbar.translucent = self.navigationController.navigationBar.translucent;
	
	currentMapIndex = theIndex;
	
	Map *theMap = [maps objectAtIndex:currentMapIndex];
	if(!theMap) return;
	
	self.title = [NSString stringWithFormat:@"%d",theMap.year];
	
	
	[self updateArrows];

	
	
	float targetZoom;
	float targetMinZoom;
	CLLocationCoordinate2D targetCenter;
	
	targetCenter = theMap.mapCenter;
	targetMinZoom = theMap.minZoom - 4.0;
	targetZoom = theMap.minZoom;

	if(oldMapView){
		if(locked) {
			targetCenter = oldMapView.contents.mapCenter;
			targetZoom = oldMapView.contents.zoom;
			targetMinZoom = oldMapView.contents.minZoom;

		}
		
		NSLog(@"are animations enabled? %d ", [UIView areAnimationsEnabled]);
		
		
		if(fadingOutView) [fadingOutView release];
		fadingOutView = oldMapView;
		oldMapView = nil;
		
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDuration: kMAP_EXIT_DURATION ];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(oldMapFadedOut)/*@selector(oldMapFadedOut: finished: context:)*/];
		

		//[oldMapView removeFromSuperview];
		fadingOutView.alpha = 0.0;
		
		[UIView commitAnimations];

		
//		[oldMapView release];
	}
	if(modernMapView){
	//	[modernMapView removeFromSuperview];
	//	[modernMapView release];
//		modernMapView.contents.zoom = theMap.minZoom;
		
		if(!locked){
			
			modernMapView.contents.zoom = targetZoom;
			modernMapView.contents.mapCenter = targetCenter;
			modernMapView.contents.minZoom = targetMinZoom;
			
			
			
		}
	}
	else{
		modernMapView = [[RMMapView alloc] initWithFrame:self.view.frame];
		modernMapView.contents = [[[RMMapContents alloc] initWithView:modernMapView
														   tilesource:[[[RMOpenStreetMapSource alloc] init] autorelease]
														 centerLatLon:targetCenter
															zoomLevel:targetZoom
														 maxZoomLevel:18.0
														 minZoomLevel:targetMinZoom
													  backgroundImage:nil] autorelease];
		
		modernMapView.backgroundColor = [UIColor clearColor];
		modernMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		modernMapView.userInteractionEnabled = NO;

		
		[self.view addSubview: modernMapView];



		
	}
	
	
		oldMapView = [[RMMapView alloc] initWithFrame:self.view.frame];
		
		mapViews = [[NSMutableArray alloc] initWithObjects:oldMapView,modernMapView, nil];
		
		
		//WMS Settings
		
		NSDictionary *wmsParameters = [NSDictionary
									   dictionaryWithObjects:[NSArray arrayWithObjects:theMap.layerID,@"TRUE",nil]
									   forKeys:[NSArray arrayWithObjects:@"layers",@"transparent",nil]
									   ];
		id myTilesource = [[[RMGenericMercatorWMSSource alloc]   
							initWithBaseUrl: kWMS_SERVER_URL
							parameters:wmsParameters] autorelease];
		
		
		//id myTilesource = [[[HMWSource alloc] init] autorelease];
		
		oldMapView.contents = [[[RMMapContents alloc] initWithView:oldMapView
													 tilesource:myTilesource
												   centerLatLon:targetCenter
													  zoomLevel:targetZoom
												   maxZoomLevel:18.0
												   minZoomLevel:targetMinZoom
												backgroundImage:nil] autorelease];
		
		
		
		 //modernMapView.contents = [[RMMapContents alloc] initForView:modernMapView];
		 //modernMapView.contents.tileSource = [[RMCloudMadeMapSource alloc]
		 //initWithAccessKey:@"0155d705a5a05e6988534761f6fd2ca5"
		 //styleNumber:5260];
		 
		
//UIView* interactionView = [[UIView alloc] initWithFrame:self.view.frame];

		 
		oldMapView.backgroundColor = [UIColor clearColor];
		//interactionView.backgroundColor = [UIColor clearColor];

		
		oldMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//interactionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		
		oldMapView.userInteractionEnabled = NO;
	
	oldMapView.alpha = 0.0;
	
	[self.view addSubview: oldMapView];

	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:kMAP_ENTRANCE_DURATION];
	
	oldMapView.alpha = 1.0;
	
	[UIView commitAnimations];
		
		
	
	[self.view bringSubviewToFront:infoButton];

	
	
	
}

//- (void) oldMapFadedOut: (NSString *)animationID finished:(NSNumber *)finished context:(void *)context
- (void) oldMapFadedOut
{
	//NSLog(@"oldMapFadedOut");
	[fadingOutView removeFromSuperview];
	[fadingOutView release];
	fadingOutView = nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];

	if([touch tapCount] == 2){
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
	}

	
	hasTouchMoved = NO;
	   
	//NSLog(@"touchesBegan");
	for (RMMapView* mv in mapViews){
		[mv touchesBegan:touches withEvent:event];
	}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	hasTouchMoved = YES;
	
	if(!self.navigationController.toolbar.hidden){
		[self.navigationController setNavigationBarHidden:YES animated:YES]; 
		[self.navigationController setToolbarHidden:YES animated:YES];
	}
	
	for (RMMapView* mv in mapViews){
		[mv touchesMoved:touches withEvent:event];
	}
	/*
	NSLog(@"touched moved, layer position delta: %f zoom delta: %f", 
		  fabs(oldMapView.contents.mapCenter.longitude -modernMapView.contents.mapCenter.longitude) +  fabs(oldMapView.contents.mapCenter.latitude -modernMapView.contents.mapCenter.latitude)
		  ,  fabs(oldMapView.contents.zoom - modernMapView.contents.zoom));

	NSLog(@"zooms: modern: %f Old: %f", modernMapView.contents.zoom, oldMapView.contents.zoom);
*/
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	
	UITouch *touch = [touches anyObject];
	
    if ([touch tapCount] == 1) {
		[self performSelector:@selector(singleTouch:) withObject:[NSValue valueWithNonretainedObject:touch]  afterDelay:kSINGLE_TOUCH_DELAY];
        //CGPoint tapPoint = [theTouch locationInView:self];
    }

	

	//NSLog(@"touchesEnded");
	for (RMMapView* mv in mapViews){
		[mv touchesEnded:touches withEvent:event];
	}
}
- (void) singleTouch: (NSValue *) val
{
	//NSLog(@"single touch called");
	if(!hasTouchMoved){

		//NSLog(@"toolbar is hidden?: %@", self.navigationController.navigationBarHidden ? @"yes" : @"no" );

		BOOL newHiddenStatus = ! (self.navigationController.navigationBarHidden);
		//NSLog(@"setting toolbar to hidden: %@", newHiddenStatus ? @"yes" : @"no" );

		[self.navigationController setNavigationBarHidden:newHiddenStatus animated:YES]; 
		[self.navigationController setToolbarHidden:newHiddenStatus animated:YES];
	}
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touchesCancelled");
	for (RMMapView* mv in mapViews){
		[mv touchesCancelled:touches withEvent:event];
	}
}


- (void) sliderChanged 
{
	
	NSArray* subs = [oldMapView.layer sublayers];
	for(CALayer *sub in subs)
	{
		if([subs indexOfObject:sub] != [subs count] - 1){
			[sub setOpacity:slider.value];
		}
		
	}

}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewWillAppear:(BOOL)animated {
	
	[self.navigationController setToolbarHidden:NO animated: animated];

	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	if(!self.modalViewController)
		[self.navigationController setToolbarHidden:YES animated: animated];

	
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	
	if(theMarker) [theMarker release];
}


- (void)dealloc {
    [super dealloc];
}


- (void)rotate
{
	currentRoation += .01;
	//mapView.transform = CGAffineTransformMakeRotation(currentRoation);	
}


@end
