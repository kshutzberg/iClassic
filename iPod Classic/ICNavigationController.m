//
//  ICNavigationController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICNavigationController.h"

@implementation ICNavigationController

- (void)pushViewController:(UIViewController<ICScreenViewController> *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:YES];
}

- (UIViewController<ICScreenViewController> *)visibleViewController
{
    id viewController = [super visibleViewController];
    
    if(![viewController conformsToProtocol:@protocol(ICScreenViewController)])
        [NSException raise:NSInternalInconsistencyException format:@"[<ICNavigationController_instance> visibleViewController] did not return an ICViewController."];
    
    return viewController;
}

@end
