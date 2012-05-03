//
//  ICViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICViewController.h"
#import "ICTableViewController.h"
#import "ICSongsTableViewController.h"


@interface ICViewController ()

@property (nonatomic, retain) ICTableViewController *tableViewController;

@property (nonatomic, assign) IBOutlet UITableView *tableView;  // Set as a placeholder for the child view controller

@end

@implementation ICViewController
@synthesize tableView = _tableView;
@synthesize scrollWheel = _scrollWheel;
@synthesize iPodView = _iPodView;
@synthesize tableViewController = _tableViewController;

#pragma mark - Custom setters


// Table view must be embedded inside a navigation controller
- (void)setTableViewController:(ICTableViewController *)tableViewController
{
    if(_tableViewController != tableViewController)
    {
        tableViewController.tableView.frame = self.tableView.frame;
        
        [self addChildViewController:tableViewController];
        
        tableViewController.delegate = self;
        
        // Swap the table views
        
        [self.tableView removeFromSuperview];
        self.tableView = tableViewController.tableView;
        [self.view insertSubview:tableViewController.tableView belowSubview:self.iPodView];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        
        
        [_tableViewController removeFromParentViewController];
        _tableViewController.delegate = nil;
        
        [_tableViewController release];
        _tableViewController = [tableViewController retain];
    }
}

#pragma mark - IC Table View Controller Delegate

- (void)tableViewController:(ICTableViewController *)tableViewController didPickCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier= nil;
    
    if([tableViewController.title isEqualToString:@"SongsTVC"]){
        identifier = @"mainTV";
        if(indexPath.row == 0)
            self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    else {
        identifier = @"SongsTVC";
        ICSongsTableViewController *songsTVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        songsTVC.songs = [MPMediaQuery songsQuery];
        self.tableViewController = songsTVC;
    }
}

#pragma mark - Scroll wheel delegate

- (void)scrollWheel:(ScrollWheelView *)scrollWheel pressedButtonAtLocation:(ScrollWheelButtonLocation)location
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    switch (location) {
        case ScrollWheelButtonLocationTop:
            self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTV"];
            break;
        case ScrollWheelButtonLocationBottom:
            [musicPlayer playbackState] == MPMusicPlaybackStatePlaying ? [musicPlayer pause] : [musicPlayer play];
            break;
        case ScrollWheelButtonLocationLeft:
            [musicPlayer skipToPreviousItem];
            break;
        case ScrollWheelButtonLocationRight:
            [musicPlayer skipToNextItem];
            break;
        default:
            break;
    }
}

- (void)scrollWheel:(ScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees
{
    //NSLog(@"Scroll wheel scrolled %f degrees.\n", degrees);
    
#define UP          -1
#define DOWN        1
    
    int direction = (degrees > 0) ? 1 : -1;
    
    NSIndexPath *currentIndexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
    NSArray *visibleCells = [self.tableView visibleCells];
    
    // Next will be the index path above or below, but it is not guarenteed to be within the bounds of the tableview
    
    NSIndexPath *next = [NSIndexPath indexPathForRow:currentIndexPath.row + direction inSection:currentIndexPath.section];
    
    // Case 1: selected cell is at the top
    
    if(currentCell == [visibleCells objectAtIndex:0])
    {
        // If we are moving up, select the cell above it, if there is one
        
        if (currentIndexPath.row > 0 && direction == UP){
            [self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        // If we are moving down, select the cell below, if there is one
        else if([visibleCells count] > 1 && direction == DOWN){
            [self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    // Case 2: selected cell is at the bottom
    
    else if(currentCell == [visibleCells lastObject])
    {
        // If we are moving up, select the cell above it, if there is one
        
        if ([visibleCells count] > 1 && direction == UP){
            [self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        // If we are moving down, select the cell below, if there is one
        else if(currentIndexPath.row < [self.tableView numberOfRowsInSection:0] - 1 && direction == DOWN){
            [self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:UITableViewScrollPositionBottom];
        }
    }
    
    // Case 3: we are in the middle of the screen
    
    else {
        UITableViewScrollPosition position = UITableViewScrollPositionNone;
        if([self.tableView cellForRowAtIndexPath:next] == [visibleCells objectAtIndex:0])
            position = UITableViewScrollPositionTop;
        if([self.tableView cellForRowAtIndexPath:next] == [visibleCells lastObject])
            position = UITableViewScrollPositionBottom;
        
        [self.tableView selectRowAtIndexPath:next animated:NO scrollPosition:position];
    }
    
}

#pragma mark - View controller life cycle

- (void)installMainTableView
{
    self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTV"];
    
    // Configure table view controller
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Replace the placeholder tableview with the real one
    [self installMainTableView];
    
    self.scrollWheel.delegate = self;
    self.scrollWheel.rotationTriggerSize = 20;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}

- (void)viewDidUnload
{
    [self setScrollWheel:nil];
    [self setTableView:nil];
    [self setTableViewController:nil];
    [self setIPodView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    [self setTableViewController:nil];
    [_iPodView release];
    [super dealloc];
}
@end
