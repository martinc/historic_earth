//
//  InfoController.h
//  History
//
//  Created by Martin Ceperley on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoController : UIViewController {
	
	IBOutlet UISwitch* lockSwitch;
	IBOutlet UISwitch* compassSwitch;

}

@property (nonatomic, retain) IBOutlet UISwitch* lockSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* compassSwitch;

- (IBAction) closeWindow;
- (IBAction) switchesChanged;

@end
