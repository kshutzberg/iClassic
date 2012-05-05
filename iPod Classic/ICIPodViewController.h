//
//  ICViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICScrollWheelView.h"
#import "ICTableViewController.h"

@interface ICIPodViewController : UIViewController < ICTableViewControllerDelegate, ICScrollWheelDelegate >

@property (assign, nonatomic) IBOutlet ICScrollWheelView *scrollWheel;
@property (retain, nonatomic) IBOutlet UIImageView *iPodView;

@end
