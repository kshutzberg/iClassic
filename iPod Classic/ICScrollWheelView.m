//
//  ScrollWheelView.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICScrollWheelView.h"
#import "ICWheelGestureRecognizer.h"

#define OUTER_RADIUS        ( MAX(self.bounds.size.height, self.bounds.size.width) / 2.0f )
#define INNER_RADIUS        ((30.0f / 107.0f) * MIN(self.bounds.size.height, self.bounds.size.width) / 2.0f )

@implementation ICScrollWheelView
@synthesize delegate = _delegate;
@synthesize rotationTriggerSize = _rotationTriggerSize;

- (void)awakeFromNib
{
    self.userInteractionEnabled = YES;
    
    //Add a long tap gesture recognizer for fast forwarding and rewinding
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
    [self addGestureRecognizer:longPressGR];
    
    // Add a tap gesture recognizer for buttons
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tapGR requireGestureRecognizerToFail:longPressGR];
    [self addGestureRecognizer:tapGR];
    [tapGR release];
    
    // Add a pan gesture recognizer for scrolling
    
    ICWheelGestureRecognizer *wheelGR = [[ICWheelGestureRecognizer alloc] initWithTarget:self action:@selector(spin:)];
    wheelGR.origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    wheelGR.innerRadius = INNER_RADIUS;
    wheelGR.outerRadius = OUTER_RADIUS;
    [self addGestureRecognizer:wheelGR];
    [wheelGR release];
}

#pragma mark - Touch Handling

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // We want to intercept all touch events, on the screen in this UI control.
    // that way if the user is already moving their finger and they it the wheel it will spin.
    return self;
}

#pragma mark - Gesture Handling

- (void)pressed:(UILongPressGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    CGFloat height  = self.bounds.size.height;
    CGFloat width   = self.bounds.size.width;
    
    CGFloat sectorWidth = width / 3.5;
    CGFloat sectorHeight = height / 3.5;
    
    CGFloat sectorYOffset = (height - sectorHeight)/2;
    
    CGRect leftSector       = CGRectMake(0, sectorYOffset, sectorWidth, sectorHeight);
    CGRect rightSector      = CGRectMake(width - sectorWidth, sectorYOffset, sectorWidth, sectorHeight);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(scrollWheelReleasedLeftOrRightButton:)]) {
            [self.delegate scrollWheelReleasedLeftOrRightButton:self];
        }
    } else {
        if(CGRectContainsPoint(leftSector, location) && [self.delegate respondsToSelector:@selector(scrollWheelPressedAndHeldLeftButton:)]){
            if (recognizer.state == UIGestureRecognizerStateEnded) {
                
            } else {
                [self.delegate scrollWheelPressedAndHeldLeftButton:self];
            }
        }
        if(CGRectContainsPoint(rightSector, location) && [self.delegate respondsToSelector:@selector(scrollWheelPressedAndHeldRightButton:)]){
            [self.delegate scrollWheelPressedAndHeldRightButton:self];
        }
    }
}
                                                 
- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    CGFloat height  = self.bounds.size.height;
    CGFloat width   = self.bounds.size.width;
    
    // Change these two values to adjust the sector size
    
    CGFloat sectorWidth = width / 3.5;
    CGFloat sectorHeight = height / 3.5;
    
    // Use these two values for the position to center horizontally/vertically
    
    CGFloat sectorXOffset = (width - sectorWidth)/2;
    CGFloat sectorYOffset = (height - sectorHeight)/2;
    
    CGRect leftSector       = CGRectMake(0, sectorYOffset, sectorWidth, sectorHeight);
    CGRect rightSector      = CGRectMake(width - sectorWidth, sectorYOffset, sectorWidth, sectorHeight);
    CGRect topSector        = CGRectMake(sectorXOffset, 0, sectorWidth, sectorHeight);
    CGRect bottomSector     = CGRectMake(sectorXOffset, height - sectorHeight, sectorWidth, sectorHeight);
    
    CGRect middleCector     = CGRectMake(sectorXOffset, sectorYOffset, sectorWidth, sectorHeight);
    
    
    
    //if(![self.delegate respondsToSelector:@selector(scrollWheel:pressedButtonAtLocation:)])return;
    
    // Handle the touch
    
    if(CGRectContainsPoint(topSector, location) && [self.delegate respondsToSelector:@selector(scrollWheelPressedTopButton:)]){
        [self.delegate scrollWheelPressedTopButton:self];
    }
    if(CGRectContainsPoint(bottomSector, location) && [self.delegate respondsToSelector:@selector(scrollWheelPressedBottomButton:)]){
        //[self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationBottom];
        [self.delegate scrollWheelPressedBottomButton:self];
    }
    if(CGRectContainsPoint(leftSector, location) && [self.delegate respondsToSelector:@selector(scrollWheelPressedLeftButton:)]){
        //[self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationLeft];
        [self.delegate scrollWheelPressedLeftButton:self];
    }
    if(CGRectContainsPoint(rightSector, location) && [self.delegate respondsToSelector:@selector(scrollWheelPressedRightButton:)]){
        //[self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationRight];
        [self.delegate scrollWheelPressedRightButton:self];
    }
    if(CGRectContainsPoint(middleCector, location)
       && [self.delegate respondsToSelector:@selector(scrollWheelPressedCenterButton:)]
       && recognizer.numberOfTapsRequired == 1)
    {
        //[self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationCenter];
        [self.delegate scrollWheelPressedCenterButton:self];
    }
    if(CGRectContainsPoint(middleCector, location)
       && [self.delegate respondsToSelector:@selector(scrollWheelDoubleTappedCenterButton:)]
       && recognizer.numberOfTapsRequired == 2)
    {
        [self.delegate scrollWheelDoubleTappedCenterButton:self];
    }

}

- (void)spin:(ICWheelGestureRecognizer *)recognizer
{
    //NSLog(@"User rotated %f degrees.\n",recognizer.rotationDegrees);
    
    if([self.delegate respondsToSelector:@selector(scrollWheel:didRotate:)])
    {
        int roundedBearing = recognizer.bearing;
        if(!self.rotationTriggerSize || !(roundedBearing % self.rotationTriggerSize) || abs(recognizer.rotationDegrees) > self.rotationTriggerSize){
            
            // Only notify the delegate if it actually moved
            if(abs(recognizer.rotationDegrees) > 1){
                [self.delegate scrollWheel:self didRotate:recognizer.rotationDegrees];
                recognizer.rotationDegrees = 0;
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
