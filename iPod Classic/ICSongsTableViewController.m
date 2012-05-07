//
//  ICSongsTableViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/2/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICSongsTableViewController.h"
#import "Colors.h"

@implementation ICSongsTableViewController
@synthesize songs = _songs;

#pragma mark - Model Management

- (void)setSongs:(NSArray *)songs
{
    if(songs != _songs)
    {
        [_songs release];
        _songs = [songs retain];
        
        if([songs count]){
            MPMediaItemCollection *songsCollection = [MPMediaItemCollection collectionWithItems:songs];
            [[MPMusicPlayerController iPodMusicPlayer] setQueueWithItemCollection:songsCollection];
        }
        
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SongCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SongCell"] autorelease];
    }
    
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    cell.textLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem *song = [self.songs objectAtIndex:indexPath.row];
    [[MPMusicPlayerController iPodMusicPlayer] setNowPlayingItem:song];
    [[MPMusicPlayerController iPodMusicPlayer] play];
}

#pragma mark - Memory Management

- (void)dealloc
{
    self.songs = nil;
    [super dealloc];
}

@end
