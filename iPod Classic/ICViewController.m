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
        self.tableView.userInteractionEnabled = NO;
        
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
            (musicPlayer.currentPlaybackTime > 2) ? [musicPlayer skipToBeginning] : [musicPlayer skipToPreviousItem];
            [musicPlayer play];
            break;
        case ScrollWheelButtonLocationRight:
            [musicPlayer skipToNextItem];
            [musicPlayer play];
            break;
        case ScrollWheelButtonLocationCenter:
            [self.tableViewController selectCurrentRow];
            break;
        default:
            break;
    }
}

- (void)scrollWheel:(ScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees
{
    //NSLog(@"Scroll wheel scrolled %f degrees.\n", degrees);
    
    int direction = (degrees > 0) ? 1 : -1;
    
    [self.tableViewController scrollDirection:direction];
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
