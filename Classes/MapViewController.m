//
//  MapViewController.m
//  History
//
//  Created by Martin Ceperley on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "AbstractMapListController.h"
#import "LocationController.h"

#import "TargetConditionals.h"

#define kFilteringFactor 0.05

#define degreesToRadians(x) (M_PI * x / 180.0)

#define MAX_ZOOM 18.0

@implementation MapViewController

@synthesize maps, currentMapIndex, oldMapView;

- (id) initWithMaps: (NSMutableArray *) theMaps
{
	return [self initWithMaps: theMaps allowCompass: YES];
	
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id) initWithMaps: (NSMutableArray *) theMaps allowCompass: (BOOL)compassAllowed{
    if (self = [super initWithNibName:nil bundle:nil]) {
		
		compassRunning = NO;
		amAnimating = NO;
		
		locked = [[NSUserDefaults standardUserDefaults] boolForKey:kLOCK_ENABLED];
		compassEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kCOMPASS_ENABLED] && compassAllowed;

        
		maps = [theMaps retain];
		
		currentMapIndex = 0;
		
		
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		//locationManager.headingFilter = 1.0;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateSettings:)
													 name:NSUserDefaultsDidChangeNotification object:nil];
		
		
		
    }
    return self;
}
-(void) startCompass
{

	if(!compassRunning){
		//NSLog(@"starting compass");
		[locationManager startUpdatingHeading];
		compassRunning = YES;
		compassIndicator.hidden = NO;
		[self.view bringSubviewToFront:compassIndicator];
		
		/*
		 NSLog(@"map frame is %f %f %f %f, bounds is %f %f %f %f", oldMapView.frame.origin.x,oldMapView.frame.origin.y,
		 oldMapView.frame.size.width, oldMapView.frame.size.height, 
		 oldMapView.bounds.origin.x, oldMapView.bounds.origin.y, oldMapView.bounds.size.width, oldMapView.bounds.size.height);
		 */
		
		//Resize frame
		
		float squareSize = 640.0;
		
		//masterView.frame = CGRectMake(0, 0, 100, 480);
		masterView.frame = CGRectMake(0.0, 0.0, squareSize, squareSize);

		masterView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
		
		for(RMMapView* themapview in mapViews)
		{
			[themapview.contents.tileLoader reload];
		}
		
		//NSStringFromCGRect()
		
		currentRotation = 0.0;
		targetRotation = 0.0;
		rotationVelocity = 0.0;
		rotationAcceleration = 0.0;
		
		//changing accel:
		
		
		rotationTimer = [NSTimer scheduledTimerWithTimeInterval:(1/30.0) target:self selector:@selector(stepRotation:) userInfo:nil repeats:YES];

	}
	
}

#define kACCEL_FACTOR 0.01

- (void)stepRotation:(NSTimer*)theTimer
{
	
	if(targetRotation != currentRotation)
	{
	   
		double newRotation;
		
		
		//Angle 0 to 90 .. +90
		//Angle 0 to 270 .. -90
		//Angle 270 to 0.. +90
		//Angle 180 to 90.. - 90
		//Angle 180 to 270.. +90
		//point are never more than 180 degrees away
		
		//which direction to go in
		
		
		double startAngle = currentRotation;
		double endAngle = targetRotation;
		
		
		if(endAngle-startAngle > 180)
		{
			startAngle += 360.0;
		}
		else if(endAngle-startAngle < -180)
		{
			endAngle += 360.0;
		}
		
			
		double theAccelForce = endAngle - startAngle;
		
		
		rotationAcceleration = kACCEL_FACTOR * theAccelForce;
		

		rotationVelocity += rotationAcceleration;
		
		//Slow down close
		
		
		if( fabs(theAccelForce) < 40)
		{
			float distanceFactor = fabs(theAccelForce) / 80 + 0.5;
			/*
			if(distanceFactor < 0.1)
			{
				rotationVelocity = targetRotation - currentRotation;
			}
			else{
				rotationVelocity *= distanceFactor;
			}
			 */
			rotationVelocity *= distanceFactor;

		}
		
		if(fabs(rotationVelocity) < 1.0)
			rotationVelocity = 1.0 * ( rotationVelocity >= 0 ? 1 : -1 );
		
		newRotation = currentRotation + rotationVelocity;
		
		if(newRotation < 0)
			newRotation += 360.0;
		
		newRotation = ((int)newRotation % 360) + newRotation-((int)newRotation);
		
		if(fabs(newRotation-targetRotation) < 0.5)
			newRotation = targetRotation;
		
		[self rotateToHeading:newRotation animated:NO];
		
		//NSLog(@"accel %f velcoity %f position %f force %f startAngle %f endAngle %f",
		//	  rotationAcceleration, rotationVelocity, newRotation, theAccelForce, startAngle, endAngle);
		
	}
}

-(void) stopCompass
{
	[rotationTimer invalidate];
	[locationManager stopUpdatingHeading];
	compassRunning = NO;
	compassIndicator.hidden = YES;
	
	masterView.frame = self.view.frame;
	masterView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);	

	
}
-(void) updateSettings: (NSNotification *)notification
{

	//NSLog(@"updateSettings called with notification %@", notification);
	
	locked = [[NSUserDefaults standardUserDefaults] boolForKey:kLOCK_ENABLED];
	compassEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kCOMPASS_ENABLED];
	

}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
	//NSLog(@"received heading %@", newHeading);
	
	
	if(newHeading.headingAccuracy >= 0)
	{
		
		targetRotation = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading;
		//currentRotation = inputHeading * kFilteringFactor + currentRotation * (1.0 - kFilteringFactor);
	//	[self rotateToHeading:inputHeading animated:YES];
		
			
	}
	
	
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
	return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

	markerLocation = newLocation.coordinate;

	if(!theMarker){
		theMarker = [[RMMarker alloc] initWithUIImage: [UIImage imageNamed:@"marker-blue.png"] anchorPoint: CGPointMake(0.5, 1.0)];
	}
	
	if([oldMapView.markerManager managingMarker:theMarker])
	{
		[oldMapView.markerManager moveMarker: theMarker AtLatLon: markerLocation];
	}
	else
	{
		[oldMapView.markerManager addMarker: theMarker AtLatLong: markerLocation];
		
	}
	
}

- (void)viewDidLoad {
	[super viewDidLoad];

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//	[super loadView];
	
	
	masterView = [[UIView alloc] initWithFrame:self.view.frame];
	masterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	masterView.autoresizesSubviews = YES;
	masterView.userInteractionEnabled = NO;
	[self.view addSubview:masterView];
	
		
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
	
	
	
	slider = [[UISlider alloc] init];
	//slider = [[UISlider alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width - 120 ,20)];
//	slider = [[LenientUISlider alloc] init];

	slider.value = 1.0;
	[slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
	
	slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	//UIView* sliderView = [[UIView alloc] initWithFrame:slider.frame];
	//[sliderView addSubview:slider];
	//UISlider* slider = [[UISlider alloc] init];
	
	
	/* Getting rid of year labels
	
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

	 */
	 
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
	
	shuffleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"05-shuffle.png"]
																						   style:UIBarButtonItemStylePlain
																						  target:self
																						  action:@selector(shuffleMaps)
																			  ];
	
	reframeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reframe.png"]
													 style:UIBarButtonItemStylePlain
													target:self
													action:@selector(reframeSearch)
					 ];
	
	NSArray* items;
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	BOOL isLandscape = (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight);
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:kSEARCH_ENABLED])
	{
		slider.frame = CGRectMake(0,0, isLandscape ? 360 : 195 ,20);
		items = [[NSArray alloc] initWithObjects: shuffleButton, reframeButton, item,  infoBarButton, nil ];
	}
	else
	{
		slider.frame = CGRectMake(0,0, isLandscape ? 390 : 225  ,20);
		items = [[NSArray alloc] initWithObjects: shuffleButton, item, infoBarButton, nil ];
	}
	

	
	[shuffleButton release];
	[reframeButton release];
	
	[space release];
	[item release];
	/*[past release];
	[present release];*/
	[slider release];
	[infoBarButton release];
	
	self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
	self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
	self.navigationController.toolbar.translucent = self.navigationController.navigationBar.translucent;
	
	[self setToolbarItems:items animated: NO ];

	
	[items release];
	self.hidesBottomBarWhenPushed = NO;
	
	
	compassIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker-crosshair.png"]];
	compassIndicator.center = CGPointMake(self.view.bounds.size.width - 40.0, self.view.bounds.size.height - 85.0);
	compassIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	
	compassIndicator.hidden = ! compassEnabled;
	[self.view addSubview:compassIndicator];
	

	//Info button
	
	
	//infoButton.center = CGPointMake(300, 440);
	
	
		
	
	/*
	currentRotation = 0;	
	[NSTimer scheduledTimerWithTimeInterval:1/30.0  target:self selector:@selector(rotate) userInfo:nil repeats:YES];
	 */
	
//	[self.navigationController setToolbarHidden:NO animated: YES];
	
}

- (void) reframeSearch
{
	
	UIViewController* mainMenu = [[self.navigationController viewControllers] objectAtIndex:0];
	
	LocationController* newSearch = [[[LocationController alloc] initWithLocation: oldMapView.contents.mapCenter ] autorelease];
	
	[self.navigationController setNavigationBarHidden:YES animated: YES];
	[self.navigationController setToolbarHidden:YES animated: YES];
	
	
	[self.navigationController setViewControllers:[NSArray arrayWithObjects:mainMenu,newSearch,nil] animated:YES];
	 

	
	
}

- (void) shuffleMaps
{
/*	
	AbstractMapListController *controllerAbove = [self.navigationController.viewControllers objectAtIndex:
												  [self.navigationController.viewControllers count]-2];
	
	[controllerAbove refreshWithLocation:oldMapView.contents.mapCenter];
	[self.navigationController popViewControllerAnimated:YES];

*/
 	Map* currentMap = [maps objectAtIndex: currentMapIndex];
	[currentMap shufflePlateOrder];
	
	[self loadMapAtIndex:currentMapIndex];
	
}
- (void) showInfo
{
	
	InfoController* infoController = [[[InfoController alloc] initWithMapView:self] autorelease];
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
	
	//NSLog(@"tileLoaded");
	if(fadingOutView/* && !amAnimating*/)
	{
		//NSLog(@"removing temp view");


		[fadingOutView removeFromSuperview];
		[fadingOutView release];
		fadingOutView = nil;
	}
	
		
	
}


- (void) loadMapAtIndex: (int) theIndex withMarkerLocation: (CLLocationCoordinate2D) loc
{
	
	[self loadMapAtIndex: theIndex];

	
	
	markerLocation = loc;
	theMarker = [[RMMarker alloc] initWithUIImage: [UIImage imageNamed:@"marker-blue.png"] anchorPoint: CGPointMake(0.5, 1.0)];
	[oldMapView.markerManager addMarker: theMarker AtLatLong: markerLocation];
}



- (void) loadMapAtIndex: (int) theIndex
{
	
	self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
	self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
	self.navigationController.toolbar.translucent = self.navigationController.navigationBar.translucent;
	
	BOOL shouldFadeOut = currentMapIndex != theIndex;	
	
	
	currentMapIndex = theIndex;
	
	Map *theMap = [maps objectAtIndex:currentMapIndex];
	if(!theMap) return;
	
	/*
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger theyear =
	[[gregorian components:NSYearCalendarUnit fromDate:[NSDate date]] year];
	[gregorian release];
	 */
	
	if(theMap.year != 2009)
		self.title = [NSString stringWithFormat:@"%d",theMap.year];
	
	
	[self updateArrows];
	
	
	shuffleButton.enabled = ([theMap plateCount] > 1);

	NSLog(@"plate count is %d", [theMap plateCount]);
	
	
	float targetZoom;
	float targetMinZoom;
	CLLocationCoordinate2D targetCenter;
	
	targetCenter = theMap.mapCenter;
	targetMinZoom = theMap.minZoom - 4.0;
	targetZoom = fmin(theMap.minZoom , MAX_ZOOM);

	if(oldMapView){
		if(locked || !shouldFadeOut) {
			targetCenter = oldMapView.contents.mapCenter;
			targetZoom = fmin(oldMapView.contents.zoom, MAX_ZOOM);
			targetMinZoom = oldMapView.contents.minZoom;

		}
		
		NSLog(@"are animations enabled? %d ", [UIView areAnimationsEnabled]);
		
		
		if(fadingOutView)
		{
			[fadingOutView removeFromSuperview];
			[fadingOutView release];
		}

			
		fadingOutView = oldMapView;
		oldMapView = nil;
		
		if(shouldFadeOut){
		
			amAnimating = YES;
		
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationCurve:UIViewAnimationCurveLinear];
			[UIView setAnimationDuration: kMAP_EXIT_DURATION ];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(oldMapFadedOut)/*@selector(oldMapFadedOut: finished: context:)*/];
			
			//[oldMapView removeFromSuperview];
			fadingOutView.alpha = 0.0;
			
			[UIView commitAnimations];
			
		}
		
		else{
			
		
			[NSTimer scheduledTimerWithTimeInterval:kMAP_EXIT_DURATION*2 target:self selector:@selector(oldMapHoldAndRemove) userInfo:nil repeats:NO];

		}

		
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
														 maxZoomLevel:MAX_ZOOM
														 minZoomLevel:targetMinZoom
													  backgroundImage:nil] autorelease];
		
		modernMapView.backgroundColor = [UIColor clearColor];
		modernMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		modernMapView.userInteractionEnabled = NO;

		
		[masterView addSubview: modernMapView];



		
	}
	
	
		oldMapView = [[RMMapView alloc] initWithFrame:self.view.frame];
		
	if(mapViews) [mapViews release];
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
												   maxZoomLevel:MAX_ZOOM
												   minZoomLevel:targetMinZoom
												backgroundImage:nil] autorelease];
		
	
		if(fadingOutView)
		{
			if(theMarker && [fadingOutView.markerManager managingMarker:theMarker])
			{
				[fadingOutView.markerManager removeMarker:theMarker];
				[oldMapView.markerManager addMarker:theMarker AtLatLong:markerLocation];

			}
		}
				
	
		
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
	
	[masterView addSubview: oldMapView];

	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:kMAP_ENTRANCE_DURATION];
	
	oldMapView.alpha = theMap.initialOpacity;
	
	[UIView commitAnimations];
	
	[slider setValue:theMap.initialOpacity animated: YES];

		
		
	
	[self.view bringSubviewToFront:infoButton];

	
	[self.view bringSubviewToFront: compassIndicator];

	
	
	
}

- (void) oldMapHoldAndRemove
{

	if(!spinner.isAnimating)
		[self oldMapFadedOut];
	
}
//- (void) oldMapFadedOut: (NSString *)animationID finished:(NSNumber *)finished context:(void *)context
- (void) oldMapFadedOut
{
	amAnimating = NO;
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

		[self hideChrome];
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
		
		if(newHiddenStatus)
			[self hideChrome];
		else
			[self showChrome];

	}
}

- (void) hideChrome
{
	[self.navigationController setNavigationBarHidden:YES animated:YES]; 
	[self.navigationController setToolbarHidden:YES animated:YES];
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];

	
	compassIndicator.center = CGPointMake(self.view.bounds.size.width - 40.0, self.view.bounds.size.height - 40.0);

	
	[UIView commitAnimations];
	
}
- (void) showChrome
{
	[self.navigationController setNavigationBarHidden:NO animated:YES]; 
	[self.navigationController setToolbarHidden:NO animated:YES];	
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	compassIndicator.center = CGPointMake(self.view.bounds.size.width - 40.0, self.view.bounds.size.height - 85.0);
	
	
	[UIView commitAnimations];
	
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
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated: animated];
	[self.navigationController setToolbarHidden:NO animated: animated];
	
	shuffleButton.enabled = ([[maps objectAtIndex:currentMapIndex] plateCount] > 1);

#if TARGET_IPHONE_SIMULATOR
	[self locationManager:nil didUpdateToLocation:
	 [[[CLLocation alloc] initWithLatitude:39.95249714905981 longitude:-75.16377925872803] autorelease]  
			 fromLocation:nil];
	
	dummyLocationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dummyLocationMove) userInfo:nil repeats:YES];
	
	
#else
	[locationManager startUpdatingLocation];

#endif
	
	
	if(compassEnabled && !compassRunning)
	{
		[self startCompass];
	}
	else {
		[self rotateToHeading:0.0 animated:NO];
		masterView.frame = self.view.frame;
		masterView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);	
		

		for(RMMapView* themapview in mapViews)
		{
			themapview.frame = self.view.frame;
			themapview.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);	

			[themapview.contents.tileLoader reload];
		}
		
		//NSLog(@"set to masterView.frame to %@ center to %@", NSStringFromCGRect(masterView.frame), NSStringFromCGPoint(masterView.center));
	}

	

	
}
- (void) dummyLocationMove
{
	
	markerLocation.latitude += 0.001;
	markerLocation.longitude += 0.001;
	
	[self locationManager:nil didUpdateToLocation:
	 [[[CLLocation alloc] initWithLatitude:markerLocation.latitude longitude:markerLocation.longitude] autorelease]  
			 fromLocation:nil];
	

	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	
	if(!self.modalViewController)
		[self.navigationController setToolbarHidden:YES animated: animated];
	
	
	
#if TARGET_IPHONE_SIMULATOR
	[dummyLocationTimer invalidate];	
#else
	[locationManager stopUpdatingLocation];
#endif
	
	if(compassRunning)
	{
		//NSLog(@"stopping compass on exit"); 
		[self stopCompass];
	}


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


#define kROTATION_CONSTANT 0.01

- (void) rotateToHeading:(double)inputHeading animated:(BOOL)isAnimated
{
//	NSLog(@"setting rotation to %f", currentRotation);
	//currentRotation += .01;
	
	CGFloat radianAngle = -1 * degreesToRadians(inputHeading);
	
	isAnimated = NO;
	
	
	if(isAnimated)
	{
		

		double theDuration = kROTATION_CONSTANT * fabs(inputHeading-currentRotation);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:theDuration];
		
		
	}
	
	masterView.transform = CGAffineTransformMakeRotation(radianAngle);
	compassIndicator.transform = CGAffineTransformMakeRotation(radianAngle);
	
	
	if(isAnimated){
		[UIView commitAnimations];
	}
	
	currentRotation = inputHeading;

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	
	for(RMMapView* mv in mapViews)
	{
		[mv.contents.tileLoader reload];
	}
	
}


@end
