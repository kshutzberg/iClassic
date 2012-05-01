//
//  ScrollWheelView.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollWheelView;

@protocol ScrollWheelDelegate <NSObject>


@end


@interface ScrollWheelView : UIImageView

@property (nonatomic, assign) id < ScrollWheelDelegate > delegate;

@end
