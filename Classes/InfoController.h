//
//  InfoController.h
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;

@interface InfoController : UIViewController {
	
	IBOutlet UILabel* yearLabel;
	IBOutlet UILabel* atlasLabel;
	IBOutlet UILabel* plateLabel;
	IBOutlet UILabel* longLabel;
	IBOutlet UILabel* latLabel;
	
	IBOutlet UIImageView* compassImage;
	IBOutlet UILabel* compassLabel;
	IBOutlet UISwitch* compassSwitch;

	IBOutlet UIImageView* lockImage;
	IBOutlet UILabel* lockLabel;
	IBOutlet UISwitch* lockSwitch;
	
	MapViewController* mapViewController;

}

@property (nonatomic, retain) IBOutlet UISwitch* lockSwitch;
@property (nonatomic, retain) IBOutlet UIImageView* lockImage;
@property (nonatomic, retain) IBOutlet UILabel* lockLabel;

@property (nonatomic, retain) IBOutlet UISwitch* compassSwitch;
@property (nonatomic, retain) IBOutlet UIImageView* compassImage;
@property (nonatomic, retain) IBOutlet UILabel* compassLabel;

@property (nonatomic, retain) IBOutlet UILabel* yearLabel;
@property (nonatomic, retain) IBOutlet UILabel* atlasLabel;
@property (nonatomic, retain) IBOutlet UILabel* plateLabel;
@property (nonatomic, retain) IBOutlet UILabel* longLabel;
@property (nonatomic, retain) IBOutlet UILabel* latLabel;


- (id)initWithMapView:(MapViewController *) mapViewController;
- (IBAction) closeWindow;
- (IBAction) switchesChanged;

@end
