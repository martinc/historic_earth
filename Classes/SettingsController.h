//
//  SettingsController.h
//  History
//
//  Created by Martin Ceperley on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsController : UIViewController {

	IBOutlet UILabel* cacheSizeLabel;
	
	IBOutlet UIButton* restoreButton;

	
	BOOL networkAvailable;
	
}

- (IBAction) done;

- (IBAction) restorePurchases;

- (IBAction) clearCache;

- (void) calculateSize;

- (id) initHaveNetwork: (BOOL) haveNetwork;


@property (nonatomic, retain) IBOutlet UILabel* cacheSizeLabel;
@property (nonatomic, retain) IBOutlet UIButton* restoreButton;


@end
