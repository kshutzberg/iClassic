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

- (void)setSongs:(MPMediaQuery *)songs
{
    if(songs != _songs)
    {
        [_songs release];
        _songs = [songs retain];
        [self.tableView reloadData];
    }
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = TABLE_COLOR;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([[self.tableView visibleCells] count]){
        UITableViewCell *topCell = [self.tableView.visibleCells objectAtIndex:0];
        topCell.contentView.backgroundColor = TABLE_COLOR_SELECTED;
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
    return [[self.songs items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SongCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SongCell"] autorelease];
    }
    
    MPMediaItem *song = [[self.songs items] objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    cell.textLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem *song = [[self.songs items] objectAtIndex:indexPath.row];
    [[MPMusicPlayerController iPodMusicPlayer] setNowPlayingItem:song];
    [[MPMusicPlayerController iPodMusicPlayer] play];
}

@end
