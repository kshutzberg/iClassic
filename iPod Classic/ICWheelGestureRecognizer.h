//
//  ICWheelGestureRecognizer.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/3/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ICWheelGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CGFloat rotationDegrees;  // cumulative rotation degrees
@property (nonatomic, readonly) CGFloat bearing;        // absolute bearing relative to origin (degrees)

// Configure

// These properties MUST be set for the gesture recognizer to function
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat outerRadius;  


@end
