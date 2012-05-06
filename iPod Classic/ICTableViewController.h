//
//  ICTableViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScreenViewController.h"

@class ICTableViewController;

@protocol ICTableViewControllerDelegate <NSObject>

@optional

- (void)tableViewController:(ICTableViewController *)tableViewController didPickCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ICTableViewController : UITableViewController < ICScreenViewController >

@property (nonatomic, assign) id < ICTableViewControllerDelegate > delegate;

@end
