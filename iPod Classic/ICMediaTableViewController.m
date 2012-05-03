//
//  ICMediaTableViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "ICMediaTableViewController.h"
#import "Colors.h"

@interface ICMediaTableViewController ()

@end

@implementation ICMediaTableViewController

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    if (indexPath.row == 1) {
        [musicPlayer skipToNextItem];
    }
    else if(indexPath.row == 2){
        [musicPlayer play];
    }
    else if(indexPath.row ==3) {
        [musicPlayer pause];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View Controller life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
