//
//  ScrollWheelView.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICScrollWheelView.h"
#import "ICWheelGestureRecognizer.h"


@implementation ICScrollWheelView
@synthesize delegate = _delegate;
@synthesize rotationTriggerSize = _rotationTriggerSize;

- (void)awakeFromNib
{
    self.userInteractionEnabled = YES;
    
    // Add a tap gesture recognizer for buttons
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGR];
    [tapGR release];
    
    // Add a pan gesture recognizer for scrolling
    
    ICWheelGestureRecognizer *wheelGR = [[ICWheelGestureRecognizer alloc] initWithTarget:self action:@selector(spin:)];
    wheelGR.origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [self addGestureRecognizer:wheelGR];
    [wheelGR release];
}

#pragma mark - Gesture Handling

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    
    CGFloat height  = self.bounds.size.height;
    CGFloat width   = self.bounds.size.width;
    
    // Change these two values to adjust the sector size
    
    CGFloat sectorWidth = width / 3;
    CGFloat sectorHeight = height / 3;
    
    // Use these two values for the position to center horizontally/vertically
    
    CGFloat sectorXOffset = (width - sectorWidth)/2;
    CGFloat sectorYOffset = (height - sectorHeight)/2;
    
    CGRect leftSector       = CGRectMake(0, sectorYOffset, sectorWidth, sectorHeight);
    CGRect rightSector      = CGRectMake(width - sectorWidth, sectorYOffset, sectorWidth, sectorHeight);
    CGRect topSector        = CGRectMake(sectorXOffset, 0, sectorWidth, sectorHeight);
    CGRect bottomSector     = CGRectMake(sectorXOffset, height - sectorHeight, sectorWidth, sectorHeight);
    
    CGRect middleCector     = CGRectMake(sectorXOffset, sectorYOffset, sectorWidth, sectorHeight);
    
    
    
    if(![self.delegate respondsToSelector:@selector(scrollWheel:pressedButtonAtLocation:)])return;
    
    // Handle the touch
    
    if(CGRectContainsPoint(topSector, location)){
        [self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationTop];
    }
    if(CGRectContainsPoint(bottomSector, location)){
        [self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationBottom];
    }
    if(CGRectContainsPoint(leftSector, location)){
        [self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationLeft];
    }
    if(CGRectContainsPoint(rightSector, location)){
        [self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationRight];
    }
    if(CGRectContainsPoint(middleCector, location)){
        [self.delegate scrollWheel:self pressedButtonAtLocation:ICScrollWheelButtonLocationCenter];
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
