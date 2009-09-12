//
//  AboutController.h
//  History
//
//  Created by Martin Ceperley on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutController : UIViewController <UIWebViewDelegate>  {
	
	IBOutlet UIWebView* webView;
	IBOutlet UIButton* versionButton;


}


@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIButton* versionButton;


@end
