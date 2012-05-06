//
//  ICNavigationController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScreenViewController.h"

/*! @class      ICNavigationController
 
    @abstract   A navigation view controller specifically for use on the iPod screen.  ALL view controllers pushed onto this navigation controller should implement the ICScreenViewController protocol.
 */

@interface ICNavigationController : UINavigationController

- (void)pushViewController:(UIViewController < ICScreenViewController > *)viewController animated:(BOOL)animated;

@property (nonatomic, readonly) UIViewController < ICScreenViewController > *visibleViewController;

@end
