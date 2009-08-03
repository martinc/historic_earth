//
//  LocateMapsSource.h
//  History
//
//  Created by Martin Ceperley on 8/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"


@interface LocateMapsSource : TTListDataSource<TTURLRequestDelegate> {
@private
	BOOL _isLoading;
	BOOL _isLoaded;
	
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy nextPage:(BOOL)nextPage;


@end
