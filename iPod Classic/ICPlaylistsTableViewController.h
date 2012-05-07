//
//  ICPlaylistsTableViewController.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICTableViewController.h"

#import <MediaPlayer/MediaPlayer.h>


@interface ICPlaylistsTableViewController : ICTableViewController

@property (nonatomic, retain) NSArray *playlists;

@end
