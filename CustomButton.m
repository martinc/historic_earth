//
//  CustomButton.m
//  History
//
//  Created by Martin Ceperley on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomButton.h"


@implementation CustomButton
	

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
		[[image stretchableImageWithLeftCapWidth:12
								   topCapHeight:12] retain];
	}
	
	if (!pressedImage)
	{
		UIImage *image =
		[UIImage imageNamed:@"custombuttonpressed.png"];
		pressedImage =
		[[image stretchableImageWithLeftCapWidth:12
								   topCapHeight:12] retain];
	}
	
	[self setBackgroundImage:normalImage
					forState:UIControlStateNormal];
	[self setBackgroundImage:pressedImage
					forState:UIControlStateHighlighted];
	
}

- (void) dealloc
{
	[super dealloc];
	[normalImage release];
	[pressedImage release];
}
	

@end
