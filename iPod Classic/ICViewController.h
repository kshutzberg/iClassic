//
//  ICViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollWheelView.h"
#import "ICTableViewController.h"

@interface ICViewController : UIViewController < ICTableViewControllerDelegate, ScrollWheelDelegate >

@property (assign, nonatomic) IBOutlet ScrollWheelView *scrollWheel;
@property (retain, nonatomic) IBOutlet UIImageView *iPodView;

@end
