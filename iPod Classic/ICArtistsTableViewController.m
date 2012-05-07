//
//  ICArtistsTableViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/5/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICArtistsTableViewController.h"

#import "ICSongsTableViewController.h"


@implementation ICArtistsTableViewController
@synthesize artists = _artists;

#pragma mark - Model Management

- (void)setArtists:(NSArray *)artists
{
    if(artists != _artists)
    {
        [_artists release];
        _artists = [artists retain];
        
        self.tableView.rowHeight = 24;
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
    return [self.artists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    MPMediaItem *artist = [[self.artists objectAtIndex:indexPath.row] representativeItem];
    
    // Configure the cell...
    
    cell.textLabel.text = [artist valueForProperty:MPMediaItemPropertyArtist];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItemCollection *artistCollection = [self.artists objectAtIndex:indexPath.row];
    
    ICSongsTableViewController *songsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SongsTVC"];
    songsTVC.songs = artistCollection.items;
    
    [self.navigationController pushViewController:songsTVC animated:YES];
    
}




#pragma mark - Memory Management

- (void)dealloc
{
    self.artists = nil;
    [super dealloc];
}

@end
