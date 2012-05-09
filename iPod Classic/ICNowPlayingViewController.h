//
//  ICNowPlayingViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenViewController.h"

@interface ICNowPlayingViewController : UIViewController <ICScreenViewController>

//These public attributes are set by ICSongsTableViewController
@property (nonatomic, assign) NSArray *songs; 
@property (nonatomic, assign) int currentSongIndex;

@end
