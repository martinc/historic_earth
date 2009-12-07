//
//  FavoritesController.h
//  History
//
//  Created by Martin Ceperley on 12/6/09.
//  Copyright 2009 Emergence Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface FavoritesController : UITableViewController {
	
	NSMutableArray* favorites;
	
	NSManagedObjectContext* context;

}

@end
