//
//  CustomButton.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomButton.h"


@implementation CustomButton
	
// global images so we don't load/create them over and over
UIImage *normalImage;
UIImage *pressedImage;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self initialize];
	}
	return self;
		
}

- (id)initWithCoder:(NSCoder *)coder
{
	if (self = [super initWithCoder:coder])
	{
		[self initialize];
	}
	return self;
}

- (void) initialize 
{
	if (!normalImage)
	{
		UIImage *image =
		[UIImage imageNamed:@"custombuttonnormal.png"];
		normalImage =
		[image stretchableImageWithLeftCapWidth:12
								   topCapHeight:12];
	}
	
	if (!pressedImage)
	{
		UIImage *image =
		[UIImage imageNamed:@"custombuttonpressed.png"];
		pressedImage =
		[image stretchableImageWithLeftCapWidth:12
								   topCapHeight:12];
	}
	
	[self setBackgroundImage:normalImage
					forState:UIControlStateNormal];
	[self setBackgroundImage:pressedImage
					forState:UIControlStateHighlighted];
	
}

@end
