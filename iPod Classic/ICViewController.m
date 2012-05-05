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

@property (nonatomic, assign) UINavigationController *screenNavigationController;

#warning Now that we are using a UINavigationController, I would like to get rid of these two properties and encapsulate the logic into the view controllers being pushed rather than the iPod container view controller.

@property (nonatomic, retain) ICTableViewController *tableViewController;
@property (nonatomic, assign) IBOutlet UITableView *tableView;  // Set as a placeholder for the child view controller

@end

@implementation ICViewController
@synthesize tableView = _tableView;
@synthesize scrollWheel = _scrollWheel;
@synthesize iPodView = _iPodView;
@synthesize tableViewController = _tableViewController;

@synthesize screenNavigationController = _screenNavigationController;

#pragma mark - Custom setters


// Table view must be embedded inside a navigation controller
- (void)setTableViewController:(ICTableViewController *)tableViewController
{
    if(_tableViewController != tableViewController)
    {
        tableViewController.tableView.frame = self.tableView.frame;
        
        tableViewController.delegate = self;
        
        // push the tableViewController on screen
        if([self.screenNavigationController.viewControllers containsObject:tableViewController]){
            [self.screenNavigationController popToViewController:tableViewController animated:YES];
        }
        else if(tableViewController){
            [self.screenNavigationController pushViewController:tableViewController animated:YES];
        }
        
        tableViewController.tableView.showsVerticalScrollIndicator = NO;
        tableViewController.tableView.userInteractionEnabled = NO;
        
        _tableViewController.delegate = nil;
        
        [_tableViewController release];
        _tableViewController = [tableViewController retain];
    }
}

#pragma mark - IC Table View Controller Delegate

#warning Now that we are using a UINavigationController, this logic needs to be moved into the tableViewControllers

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

#warning Now that we are using a UINavigationController, this logic needs to be moved into the tableViewControllers

- (void)scrollWheel:(ScrollWheelView *)scrollWheel pressedButtonAtLocation:(ScrollWheelButtonLocation)location
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    switch (location) {
        case ScrollWheelButtonLocationTop:
            //self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTV"];
            if([self.screenNavigationController.viewControllers count] > 1){
                [self.screenNavigationController popViewControllerAnimated:YES];
                self.tableViewController = (id)self.screenNavigationController.visibleViewController;
            }
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


#warning Now that we are using a UINavigationController, this logic needs to be moved into the tableViewControllers
#warning The question is... should these views be the scroll wheel delegate or will we ever want to intercept scroll wheel events in the container ipod view?
- (void)scrollWheel:(ScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees
{
    //NSLog(@"Scroll wheel scrolled %f degrees.\n", degrees);
    
    int direction = (degrees > 0) ? 1 : -1;
    
    [self.tableViewController scrollDirection:direction];
}

#pragma mark - View controller life cycle

- (void)installScreenNavigationController
{
    self.screenNavigationController = [[UINavigationController alloc] initWithRootViewController:nil];
    self.screenNavigationController.view.frame = self.tableView.frame;
    
    // configure the screen navigation controller
    
    self.screenNavigationController.navigationBarHidden = YES;
    self.screenNavigationController.toolbarHidden = YES;
    
    // Remove the tableview and add the navigation controller
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self.view insertSubview:self.screenNavigationController.view belowSubview:self.iPodView];
}

- (void)installMainTableView
{
    self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTV"];
    self.tableViewController.tableView.backgroundColor = [UIColor clearColor];
    
    // set this as the root view controller
    //[self.screenNavigationController pushViewController:self.tableViewController animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self installScreenNavigationController];
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
