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


@interface ICIPodViewController ()

@property (nonatomic, assign) ICNavigationController *screenNavigationController;

@property (nonatomic, assign) IBOutlet UITableView *tableView;  // Set as a placeholder for the child view controller

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


#pragma mark - IC Table View Controller Delegate


- (void)scrollWheel:(ICScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees
{
    //NSLog(@"Scroll wheel scrolled %f degrees.\n", degrees);
    
    [self.screenNavigationController.visibleViewController scrollWheel:scrollWheel didRotate:degrees];
}

- (void)scrollWheel:(ICScrollWheelView *)scrollWheel pressedButtonAtLocation:(ICScrollWheelButtonLocation)location
{
    [self.screenNavigationController.visibleViewController scrollWheel:scrollWheel pressedButtonAtLocation:location];
}

#pragma mark - View controller life cycle


- (void)setupScreen
{
    self.screenNavigationController = [[ICNavigationController alloc] initWithRootViewController:nil];
    self.screenNavigationController.view.frame = self.tableView.frame;
    
    // configure the screen navigation controller
    
    self.screenNavigationController.navigationBarHidden = YES;
    self.screenNavigationController.toolbarHidden = YES;
    
    // Remove the tableview and add the navigation controller
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self.view insertSubview:self.screenNavigationController.view belowSubview:self.iPodView];
    
    // Set up the table view controller
    
    ICTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainTV"];
    tableViewController.tableView.backgroundColor = [UIColor clearColor];
    
    tableViewController.delegate = self;
    
    tableViewController.tableView.showsVerticalScrollIndicator = NO;
    tableViewController.tableView.userInteractionEnabled = NO;
    
    // set this as the root view controller
    [self.screenNavigationController pushViewController:tableViewController animated:NO];
    
    //self.tableViewController = tableViewController;
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
