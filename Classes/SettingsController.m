//
//  SettingsController.m
//  History
//
//  Created by Martin Ceperley on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"
#import <StoreKit/StoreKit.h>


@implementation SettingsController

@synthesize cacheSizeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self calculateSize];


	
}

- (void) viewWillAppear:(BOOL)animated
{
	
	self.title = @"Settings";
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	
}

- (void) calculateSize
{
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	
	NSString* folderPath = [paths objectAtIndex:0];
	double totalSize = 0.0;
	
	
	NSArray *contents;
	NSEnumerator *enumerator;
	NSString *path;
	contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
	enumerator = [contents objectEnumerator];
	while (path = [enumerator nextObject]) {
		NSDictionary *fattrib = [[NSFileManager defaultManager] fileAttributesAtPath:[folderPath stringByAppendingPathComponent:path] traverseLink:YES];
		totalSize += [fattrib fileSize] / 1048576.0;
	}
	
	
	cacheSizeLabel.text = [NSString stringWithFormat:@"%.1f MB", totalSize];
	
	/*
	float memoryUsage = [[NSURLCache sharedURLCache] currentMemoryUsage] / 1048576.0;
	float diskUsage = [[NSURLCache sharedURLCache] currentDiskUsage] / 1048576.0;
	NSLog(@"NSURL cache using %f mb memory and %f mb disk", memoryUsage, diskUsage);
	 */
}

- (IBAction) done
{

	[self.navigationController popViewControllerAnimated: YES];
	
}


- (IBAction) restorePurchases
{
	
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
	
}

- (IBAction) clearCache
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* base = [paths objectAtIndex:0];	
	NSString* rmcachePath = [base stringByAppendingPathComponent:@"__RMCache"];
	[[NSFileManager defaultManager] removeItemAtPath:rmcachePath error:NULL];

	
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	 
	[self calculateSize];

}



/*

- (unsigned long long) fastFolderSizeAtFSRef:(FSRef*)theFileRef
{
    FSIterator    thisDirEnum = NULL;
    unsigned long long totalSize = 0;
	
    // Iterate the directory contents, recursing as necessary
    if (FSOpenIterator(theFileRef, kFSIterateFlat, &thisDirEnum) ==  
		noErr)
    {
        const ItemCount kMaxEntriesPerFetch = 256;
        ItemCount actualFetched;
        FSRef    fetchedRefs[kMaxEntriesPerFetch];
        FSCatalogInfo fetchedInfos[kMaxEntriesPerFetch];
		
        // DCJ Note right now this is only fetching data fork  
		//sizes... if we decide to include
			// resource forks we will have to add kFSCatInfoRsrcSizes
			
			OSErr fsErr = FSGetCatalogInfoBulk(thisDirEnum,  
											   kMaxEntriesPerFetch, &actualFetched,
											   NULL, kFSCatInfoDataSizes |  
											   kFSCatInfoNodeFlags, fetchedInfos,
											   fetchedRefs, NULL, NULL);
        while ((fsErr == noErr) || (fsErr == errFSNoMoreItems))
        {
            ItemCount thisIndex;
            for (thisIndex = 0; thisIndex < actualFetched; thisIndex++)
            {
                // Recurse if it's a folder
                if (fetchedInfos[thisIndex].nodeFlags &  
					kFSNodeIsDirectoryMask)
                {
                    totalSize += [self  
								  fastFolderSizeAtFSRef:&fetchedRefs[thisIndex]];
                }
                else
                {
                    // add the size for this item
                    totalSize += fetchedInfos 
					[thisIndex].dataLogicalSize;
                }
            }
			
            if (fsErr == errFSNoMoreItems)
            {
                break;
            }
            else
            {
                // get more items
                fsErr = FSGetCatalogInfoBulk(thisDirEnum,  
											 kMaxEntriesPerFetch, &actualFetched,
											 NULL, kFSCatInfoDataSizes |  
											 kFSCatInfoNodeFlags, fetchedInfos,
											 fetchedRefs, NULL, NULL);
            }
        }
        FSCloseIterator(thisDirEnum);
    }
    return totalSize;
}
 
 */

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
