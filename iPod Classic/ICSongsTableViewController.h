//
//  ICSongsTableViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/2/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "ICTableViewController.h"

@interface ICSongsTableViewController : ICTableViewController

@property (nonatomic, retain) MPMediaQuery *songs;

@end
