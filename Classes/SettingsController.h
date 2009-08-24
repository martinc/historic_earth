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
	
}

- (IBAction) done;

- (IBAction) restorePurchases;

- (IBAction) clearCache;

- (void) calculateSize;

@property (nonatomic, retain) IBOutlet UILabel* cacheSizeLabel;

@end