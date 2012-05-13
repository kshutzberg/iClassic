//
//  ICViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICIPodViewController.h"

#import "ICNavigationController.h"

#import "ICTableViewController.h"
#import "ICSongsTableViewController.h"
#import "MPMediaPlayerExtraData.h"

@interface ICIPodViewController ()

@property (nonatomic, assign) ICNavigationController *screenNavigationController;

@property (nonatomic, assign) IBOutlet UITableView *tableView;  // Set as a placeholder for the child view controller

- (void)countSongsInCurrentPlaylist;

@end

@implementation ICIPodViewController
@synthesize tableView = _tableView;
@synthesize scrollWheel = _scrollWheel;
@synthesize iPodView = _iPodView;

@synthesize screenNavigationController = _screenNavigationController;

#pragma mark - Singleton methods

static ICIPodViewController *sharedIpod = nil;

+ (id)sharedIpod
{
    if(!sharedIpod)sharedIpod = [self allocWithZone:NULL];
    return sharedIpod;
}

+ (id)alloc {return [self sharedIpod];}

- (NSUInteger)retainCount{ return NSUIntegerMax; }
- (id)retain { return self; }
- (oneway void)release{ /* Do nothing */ };


#pragma mark - Scroll Wheel delegate


- (void)scrollWheel:(ICScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees
{
    //NSLog(@"Scroll wheel scrolled %f degrees.\n", degrees);
    
    [self.screenNavigationController.visibleViewController scrollWheel:scrollWheel didRotate:degrees];
}

- (void)scrollWheel:(ICScrollWheelView *)scrollWheel pressedButtonAtLocation:(ICScrollWheelButtonLocation)location{}


- (void)scrollWheelPressedTopButton:(ICScrollWheelView *)scrollWheel
{
    UIViewController < ICScrollWheelDelegate > *controller = self.screenNavigationController.visibleViewController;
    
    // Forward this message to the visisble view controller if they implement it
    
    if([controller respondsToSelector:_cmd]){
        [controller performSelector:_cmd withObject:scrollWheel];
    }
    
    // Default behavior
    
    else{
        NSLog(@"Menu button pressed. Ignoring...");
    }
}

- (void)scrollWheelPressedBottomButton:(ICScrollWheelView *)scrollWheel
{
    UIViewController < ICScrollWheelDelegate > *controller = self.screenNavigationController.visibleViewController;
    
    // Forward this message to the visisble view controller if they implement it
    
    if([controller respondsToSelector:_cmd]){
        [controller performSelector:_cmd withObject:scrollWheel];
    }
    
    // Default behavior
    
    else{
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        [musicPlayer playbackState] == MPMusicPlaybackStatePlaying ? [musicPlayer pause] : [musicPlayer play];
    }
}

- (void)scrollWheelPressedLeftButton:(ICScrollWheelView *)scrollWheel
{
    UIViewController < ICScrollWheelDelegate > *controller = self.screenNavigationController.visibleViewController;
    
    // Forward this message to the visisble view controller if they implement it
    
    if([controller respondsToSelector:_cmd]){
        [controller performSelector:_cmd withObject:scrollWheel];
    }
    
    // Default behavior
    
    else{
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        (musicPlayer.currentPlaybackTime > 2) ? [musicPlayer skipToBeginning] : [musicPlayer skipToPreviousItem];
        [musicPlayer play];
    }
}

- (void)scrollWheelPressedRightButton:(ICScrollWheelView *)scrollWheel
{
    UIViewController < ICScrollWheelDelegate > *controller = self.screenNavigationController.visibleViewController;
    
    // Forward this message to the visisble view controller if they implement it
    
    if([controller respondsToSelector:_cmd]){
        [controller performSelector:_cmd withObject:scrollWheel];
    }
    
    // Default behavior

    else{
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        [musicPlayer skipToNextItem];
        [musicPlayer play];
    }
}

- (void)scrollWheelPressedCenterButton:(ICScrollWheelView *)scrollWheel
{
    UIViewController < ICScrollWheelDelegate > *controller = self.screenNavigationController.visibleViewController;
    
    // Forward this message to the visisble view controller if they implement it
    
    if([controller respondsToSelector:_cmd]){
        [controller performSelector:_cmd withObject:scrollWheel];
    }
    
    // Default behavior
    
    else{
        NSLog(@"Center button pressed. Ignoring...");
    }
}

- (void)scrollWheelDoubleTappedCenterButton:(ICScrollWheelView *)scrollWheel
{
    UIViewController < ICScrollWheelDelegate > *controller = self.screenNavigationController.visibleViewController;
    
    // Forward this message to the visisble view controller if they implement it
    
    if([controller respondsToSelector:_cmd]){
        [controller performSelector:_cmd withObject:scrollWheel];
    }
    
    // Default behavior
    
    else{
        NSLog(@"Center button double tapped. Ignoring...");
    }
}

#pragma mark - View controller life cycle


- (void)setupScreen
{    
    // Set up the table view controller
    
    ICTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTV"];
    tableViewController.tableView.backgroundColor = [UIColor clearColor];
    
    tableViewController.delegate = self;
    
    tableViewController.tableView.showsVerticalScrollIndicator = NO;
    tableViewController.tableView.userInteractionEnabled = NO;
    
    // set this as the root view controller in a navigation controller
    
    self.screenNavigationController = [[ICNavigationController alloc] initWithRootViewController:tableViewController];
    self.screenNavigationController.view.frame = self.tableView.frame;
    
    // configure the screen navigation controller
    
    self.screenNavigationController.navigationBarHidden = YES;
    self.screenNavigationController.toolbarHidden = YES;
    
    // Remove the tableview and add the navigation controller
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self.view insertSubview:self.screenNavigationController.view belowSubview:self.iPodView];
    
    //Turn off shuffle mode!
    [[MPMusicPlayerController iPodMusicPlayer] setShuffleMode:MPMusicShuffleModeOff];
//    [self countSongsInCurrentPlaylist];
}

- (void)countSongsInCurrentPlaylist {
    NSUInteger count = 0;
    MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
    MPMediaItem *firstItem = [player nowPlayingItem];
    
    MPMediaItem *currentItem = nil;
    
    
    while (![firstItem isEqual:currentItem]) {
        [player skipToNextItem];
        currentItem = [player nowPlayingItem];
        count++;
    }
 
    MPMediaPlayerExtraData *data = [MPMediaPlayerExtraData sharedExtraData];
    data.collectionCount = count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupScreen];
    
    self.scrollWheel.delegate = self;
    self.scrollWheel.rotationTriggerSize = 20;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}

- (void)viewDidUnload
{
    [self setScrollWheel:nil];
    [self setTableView:nil];
    [self setIPodView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    [_iPodView release];
    [super dealloc];
}
@end
