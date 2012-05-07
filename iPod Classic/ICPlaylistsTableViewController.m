//
//  ICPlaylistsTableViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICPlaylistsTableViewController.h"

@implementation ICPlaylistsTableViewController
@synthesize playlists = _playlists;

#pragma mark - Model Management

- (void)setPlaylists:(MPMediaQuery *)playlists
{
    if(playlists != _playlists)
    {
        [_playlists release];
        _playlists = [playlists retain];
        
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
    return [[self.playlists items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaylistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    MPMediaItem *playlist = [[self.playlists items] objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    cell.textLabel.text = [playlist valueForProperty:MPMediaItemPropertyTitle];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MPMediaItem *playlist = [[self.playlists items] objectAtIndex:indexPath.row];
//    
//    [[MPMusicPlayerController iPodMusicPlayer] setQueueWithQuery:[MPMediaQuery songsQuery]];
}


#pragma mark - Memory Management

-(void)dealloc
{
    self.playlists = nil;
    [super dealloc];
}

@end
