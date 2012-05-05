//
//  ICNavigationController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScreenViewController.h"

@interface ICNavigationController : UINavigationController

- (void)pushViewController:(UIViewController < ICScreenViewController > *)viewController animated:(BOOL)animated;

@property (nonatomic, readonly) UIViewController < ICScreenViewController > *visibleViewController;

@end
