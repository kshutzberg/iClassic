//
//  ICMainTableViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICMainTableViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "ICPlaylistsTableViewController.h"
#import "ICArtistsTableViewController.h"
#import "ICSongsTableViewController.h"

@implementation ICMainTableViewController

#pragma mark - Navigation Logic

-(void)showNowPlaying
{
    
}

- (void)showPlaylists
{
    ICPlaylistsTableViewController *playlistsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistsTVC"];
    
    [self.navigationController pushViewController:playlistsTVC animated:YES];
}

- (void)showArtists
{
    ICArtistsTableViewController *artistsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistsTVC"];
    
    [self.navigationController pushViewController:artistsTVC animated:YES];
}

- (void)showSongs
{
    ICSongsTableViewController *songsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SongsTVC"];
    songsTVC.songs = [MPMediaQuery songsQuery];
    
    [self.navigationController pushViewController:songsTVC animated:YES];
}

- (void)showSettings
{
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    enum MainRow {
        MainRowNowPlaying   = 0,
        MainRowPlaylists    = 1,
        MainRowArtists      = 2,
        MainRowSongs        = 3,
        MainRowSettings     = 4,
    };
    
    enum MainRow row = indexPath.row;
    
    switch (row) {
        case MainRowNowPlaying:
            [self showNowPlaying];
            break;
        case MainRowPlaylists:
            [self showPlaylists];
            break;
        case MainRowArtists:
            [self showArtists];
            break;
        case MainRowSongs:
            [self showSongs];
            break;
        case MainRowSettings:
            [self showSettings];
            break;
    }
}

@end
