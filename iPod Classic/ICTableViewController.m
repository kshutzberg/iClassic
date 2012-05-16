//
//  ICTableViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICTableViewController.h"
#import "Colors.h"

#import <MediaPlayer/MediaPlayer.h>

#import "ICIPodViewController.h"

@interface ICTableViewController ()

@end

@implementation ICTableViewController
@synthesize delegate = _delegate;

- (void)selectCurrentRow
{
    [self tableView:self.tableView didSelectRowAtIndexPath:self.tableView.indexPathForSelectedRow];
}

#pragma mark - Screen View Controller Protocol
    
#pragma mark Scroll wheel delegate

- (void)scrollWheelPressedTopButton:(ICScrollWheelView *)scrollWheel
{
    if([self.navigationController.viewControllers count] > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollWheelPressedCenterButton:(ICScrollWheelView *)scrollWheel
{
    [self selectCurrentRow];
}


- (void)scrollWheel:(ICScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees
{
    int up  = -1;
    int down = 1;
    
    int direction = (degrees > 0) ? 1 : -1;
    
    NSIndexPath *currentIndexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
    NSArray *visibleCells = [self.tableView visibleCells];
    
    // Next will be the index path above or below, but it is not guarenteed to be within the bounds of the tableview
    
    NSIndexPath *next = [NSIndexPath indexPathForRow:currentIndexPath.row + direction inSection:currentIndexPath.section];
    
    ///////////////////////////////////////
    
    UITableViewScrollPosition position = UITableViewScrollPositionNone;
    BOOL shouldSelectNextCell = NO;
    
    // Case 0: If there are no visible cells, return.
    
    if(![visibleCells count])return;
    
    // Case 1: selected cell is at the top
    
    if(currentCell == [visibleCells objectAtIndex:0])
    {
        // If we are moving up, select the cell above it, if there is one
        
        if (currentIndexPath.row > 0 && direction == up){
            //[self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionTop];
            position = UITableViewScrollPositionTop;
            shouldSelectNextCell = YES;
        }
        
        // If we are moving down, select the cell below, if there is one
        else if([visibleCells count] > 1 && direction == down){
            //[self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionNone];
            position = UITableViewScrollPositionNone;
            shouldSelectNextCell = YES;
        }
    }
    
    // Case 2: selected cell is at the bottom
    
    else if(currentCell == [visibleCells lastObject])
    {
        // If we are moving up, select the cell above it, if there is one
        
        if ([visibleCells count] > 1 && direction == up){
            //[self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionNone];
            position = UITableViewScrollPositionNone;
            shouldSelectNextCell = YES;
        }
        
        // If we are moving down, select the cell below, if there is one
        else if(currentIndexPath.row < [self.tableView numberOfRowsInSection:0] - 1 && direction == down){
            //[self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionBottom];
            position = UITableViewScrollPositionBottom;
            shouldSelectNextCell = YES;
        }
    }
    
    // Case 3: we are in the middle of the screen

    else {
        //UITableViewScrollPosition position = UITableViewScrollPositionNone;
        if([self.tableView cellForRowAtIndexPath:next] == [visibleCells objectAtIndex:0])
            position = UITableViewScrollPositionTop;
        if([self.tableView cellForRowAtIndexPath:next] == [visibleCells lastObject])
            position = UITableViewScrollPositionBottom;
        
        //[self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:position];
        shouldSelectNextCell = YES;
    }
    
    if(shouldSelectNextCell){
        // If we are going to eventually select the next cell, go ahead and deselect this one
        
        [self.tableView deselectRowAtIndexPath:currentIndexPath animated:NO];
        [self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:position];
//        UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:next];
//        
//        nextCell.contentView.backgroundColor = TABLE_COLOR_SELECTED;
//        nextCell.backgroundColor = TABLE_COLOR_SELECTED;
//        
//        currentCell.contentView.backgroundColor = TABLE_COLOR;
//        currentCell.backgroundColor = TABLE_COLOR;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.rowHeight = 24;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.userInteractionEnabled = NO;
    [ICIPodViewController sharedIpod].scrollWheel.rotationTriggerSize = 20;
}


// Automatically select the first cell when the view appears

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Make sure at least one cell is highlighted
    
    if(![self.tableView indexPathForSelectedRow] && ![[self.tableView indexPathsForSelectedRows] count] && [[self.tableView visibleCells] count]){
        UITableViewCell *topCell = [self.tableView.visibleCells objectAtIndex:0];
        [self.tableView selectRowAtIndexPath:[self.tableView indexPathForCell:topCell] animated:NO scrollPosition:UITableViewRowAnimationTop];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView formatTableViewCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    bool isSelected = [indexPath isEqual:[tableView indexPathForSelectedRow]];
    
    cell.contentView.backgroundColor = isSelected ? TABLE_COLOR_SELECTED : TABLE_COLOR;
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    cell.accessoryView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    
    cell.selectedBackgroundView.backgroundColor = TABLE_COLOR_SELECTED;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    [self tableView:tableView formatTableViewCell:cell forRowAtIndexPath:indexPath];
}

@end
