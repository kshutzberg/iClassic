//
//  ICWheelGestureRecognizer.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICWheelGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#pragma mark - Math Helper Functions

static inline CGFloat dotProduct(CGSize vector1, CGSize vector2){
    return vector1.width * vector2.width + vector1.height + vector2.height;
}

static inline CGFloat getAngle(CGPoint startingPoint, CGPoint endingPoint)
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    //bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

@interface ICWheelGestureRecognizer ()

@property (nonatomic, readwrite) CGFloat bearing;

@end

#define MINIMUM_RADIUS      10
#define MAX_DEGREES         50

@implementation ICWheelGestureRecognizer
@synthesize rotationDegrees = _rotationDegrees;
@synthesize origin = _origin;
@synthesize bearing = _bearing;

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    
    CGFloat thetaNow = getAngle(self.origin, nowPoint);
    CGFloat thetaPrev = getAngle(self.origin, prevPoint);
    CGFloat theta = thetaNow - thetaPrev;
    
    //NSLog(@"NOW: %f PREV: %f THETA: %f\n", thetaNow, thetaPrev, theta);
    
    // Don't let theta exceed the maximum number of degrees
    // Ignore touches outside of the hit test view
    
    if(abs(theta) > MAX_DEGREES || ![self.view hitTest:[[touches anyObject] locationInView:self.view] withEvent:event]){
        return;
    }
    
    self.bearing = thetaNow;
    self.rotationDegrees += theta;
    
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.state == UIGestureRecognizerStatePossible || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.rotationDegrees = 0;
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    [super reset];
    self.rotationDegrees = 0;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return YES;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return NO;
}

@end
