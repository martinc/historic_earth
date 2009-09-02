
#import "LenientUISlider.h"

#define SLIDER_X_BOUND 0
#define SLIDER_Y_BOUND 20

/*
 * A UISlider that increases the area to grab the ball and also slides
 * the ball to wherever on the bar you put your finger.
 */
@implementation LenientUISlider : UISlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    lastBounds = result;
    
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* result = [super hitTest:point withEvent:event];
    //if (result != self)
	{
        // check if this is within what we consider a reasonable range. It will for x as x is the whole slider
        if ((point.y >= -SLIDER_Y_BOUND) && (point.y < (lastBounds.size.height + SLIDER_Y_BOUND)))
		{
            //result = self;
			float value;
			// scale to 1
			value = point.x-self.bounds.origin.x;
			value = value/self.bounds.size.width;
			// clip
			if (value<0) value=0;
			if (value>1) value=1;
			// scale to valuerange
			value = value*(self.maximumValue - self.minimumValue) + self.minimumValue;
			[self setValue:value animated:NO];
			
			if(result!=self) { // To prevent it from happening again if [super hitTest:point withEvent:event]; already preformed the action.
				[self sendActionsForControlEvents:UIControlEventValueChanged];
			}
			//NSLog(@"UISlider hit: (%f, %f) value %f", point.x, point.y, self.value);
        }
    }
    
    //NSLog(@"UISlider(%d).hitTest: (%f, %f) result=%d", self, point.x, point.y, result);
    
    return result;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    
    if (!result) {
        
        // check if this is within what we consider a reasonable range for just the ball
        if ((point.x >= (lastBounds.origin.x - SLIDER_X_BOUND)) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + SLIDER_X_BOUND))
            && (point.y >= -SLIDER_Y_BOUND) && (point.y < (lastBounds.size.height + SLIDER_Y_BOUND))) {
            
            result = YES;
        }
    }
    
    //NSLog(@"UISlider(%d).pointInside: (%f, %f) result=%d", self, point.x, point.y, result);
    
    return result;
}

@end