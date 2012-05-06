//
//  ScreenViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ICScrollWheelView.h"

/*!
 @protocol  ICScreenViewController
 
 @abstract  A protocol for a view controller on the iPod screen that will dictate the methods to be used to handle user input from the container ICIPodViewController user interface (i.e. the click wheel).
 */

@protocol ICScreenViewController < NSObject, ICScrollWheelDelegate >

@end
