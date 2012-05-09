//
//  ScrollWheelView.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICScrollWheelView;

typedef enum {
    ICScrollWheelButtonLocationTop,
    ICScrollWheelButtonLocationBottom,
    ICScrollWheelButtonLocationLeft,
    ICScrollWheelButtonLocationRight,
    ICScrollWheelButtonLocationCenter
} ICScrollWheelButtonLocation;

@protocol ICScrollWheelDelegate <NSObject>

@optional

- (void)scrollWheel:(ICScrollWheelView *)scrollWheel pressedButtonAtLocation:(ICScrollWheelButtonLocation)location;

- (void)scrollWheelPressedTopButton:(ICScrollWheelView *)scrollWheel;
- (void)scrollWheelPressedBottomButton:(ICScrollWheelView *)scrollWheel;
- (void)scrollWheelPressedLeftButton:(ICScrollWheelView *)scrollWheel;
- (void)scrollWheelPressedRightButton:(ICScrollWheelView *)scrollWheel;

- (void)scrollWheelPressedCenterButton:(ICScrollWheelView *)scrollWheel;
- (void)scrollWheelDoubleTappedCenterButton:(ICScrollWheelView *)scrollWheel;



- (void)scrollWheel:(ICScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees;

@end


@interface ICScrollWheelView : UIImageView

@property (nonatomic, assign) id < ICScrollWheelDelegate > delegate;

@property (nonatomic, assign) int rotationTriggerSize;    // number of degrees it takes to fire the delegate method for rotations.

@end
