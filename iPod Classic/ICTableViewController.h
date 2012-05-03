//
//  ICTableViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICTableViewController;

@protocol ICTableViewControllerDelegate <NSObject>

@optional

- (void)tableViewController:(ICTableViewController *)tableViewController didPickCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ICTableViewController : UITableViewController

@property (nonatomic, assign) id < ICTableViewControllerDelegate > delegate;

- (void)selectCurrentRow;   // This method is called when the user taps the click wheel.  Default implementation does nothing

- (void)scrollDirection:(int)direction; // Moves selects the next cell moving up if direction is -1 and the next cell moving down if it is positive 1

@end
