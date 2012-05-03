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
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, readonly) CGFloat bearing;        // absolute bearing relative to origin (degrees)

@end
