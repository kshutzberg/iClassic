//
//  ICViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 4/30/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICViewController.h"
#import "ICTableViewController.h"


@interface ICViewController ()

@property (nonatomic, retain) ICTableViewController *tableViewController;

@property (nonatomic, assign) IBOutlet UITableView *tableView;  // Set as a placeholder for the child view controller

@end

@implementation ICViewController
@synthesize tableView = _tableView;
@synthesize scrollWheel = _scrollWheel;
@synthesize tableViewController = _tableViewController;

#pragma mark - Custom setters


// Table view must be embedded inside a navigation controller
- (void)setTableViewController:(ICTableViewController *)tableViewController
{
    if(_tableViewController != tableViewController)
    {
        tableViewController.tableView.frame = self.tableView.frame;
        
        _tableViewController.delegate = nil;
        tableViewController.delegate = self;
        
        [_tableViewController removeFromParentViewController];
        
        _tableViewController = tableViewController;
        
        [self addChildViewController:tableViewController];
        
        // Swap the table views
        
        [self.tableView removeFromSuperview];
        self.tableView = tableViewController.tableView;
        [self.view addSubview:self.tableView];
        
    }
}

#pragma mark - IC Table View Controller Delegate

- (void)tableViewController:(ICTableViewController *)tableViewController didPickCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [tableViewController.title isEqualToString:@"Settings"] ? @"mainTV" : @"settingsTV";
    self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
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
}

- (void)viewDidUnload
{
    [self setScrollWheel:nil];
    [self setTableView:nil];
    [self setTableViewController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    [self setTableViewController:nil];
    [super dealloc];
}
@end
