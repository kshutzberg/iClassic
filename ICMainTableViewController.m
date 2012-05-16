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
#import "ICNowPlayingViewController.h"

@interface ICMainTableViewController () < UIAlertViewDelegate >

@end

@implementation ICMainTableViewController

#pragma mark - Navigation Logic

-(void)showNowPlaying
{
    ICNowPlayingViewController *nowPlayingTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NowPlayingTVC"];    
    [self.navigationController pushViewController:nowPlayingTVC animated:YES];
}

- (void)showPlaylists
{
    ICPlaylistsTableViewController *playlistsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistsTVC"];
    playlistsTVC.playlists = [[MPMediaQuery playlistsQuery] collections];
    
    [self.navigationController pushViewController:playlistsTVC animated:YES];
}

- (void)showArtists
{
    ICArtistsTableViewController *artistsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistsTVC"];
    artistsTVC.artists = [[MPMediaQuery artistsQuery] collections];
    
    [self.navigationController pushViewController:artistsTVC animated:YES];
}

- (void)showSongs
{
    ICSongsTableViewController *songsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SongsTVC"];
    songsTVC.songs = [MPMediaQuery songsQuery].items;
    
    [self.navigationController pushViewController:songsTVC animated:YES];
}

- (void)showFeedback
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Give us feedback!" message:@"You are about to be redirected to the app store, so that you can write a review.  Your feedback is much appreciated! High five... you're awesome!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Lets Go!", nil];
    [alertView show];
    [alertView release];
}

#pragma mark - Alert View Deletate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        NSString *appID = @"527835521";
        NSString *itunesPath = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8",appID];
        NSURL *itunesURL = [NSURL URLWithString:itunesPath];
        
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    enum MainRow {
        MainRowNowPlaying   = 0,
        MainRowPlaylists    = 1,
        MainRowArtists      = 2,
        MainRowSongs        = 3,
        MainRowFeedback     = 4,
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
        case MainRowFeedback:
            [self showFeedback];
            break;
    }
}

@end
