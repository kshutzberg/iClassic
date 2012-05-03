//
//  ScrollWheelView.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollWheelView;

typedef enum {
    ScrollWheelButtonLocationTop,
    ScrollWheelButtonLocationBottom,
    ScrollWheelButtonLocationLeft,
    ScrollWheelButtonLocationRight
} ScrollWheelButtonLocation;

@protocol ScrollWheelDelegate <NSObject>

@optional

- (void)scrollWheel:(ScrollWheelView *)scrollWheel pressedButtonAtLocation:(ScrollWheelButtonLocation)location;

- (void)scrollWheel:(ScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees;

@end


@interface ScrollWheelView : UIImageView

@property (nonatomic, assign) id < ScrollWheelDelegate > delegate;

@property (nonatomic, assign) int rotationTriggerSize;    // number of degrees it takes to fire the delegate method for rotations.

@end
