//
//  ICNowPlayingViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "MPMediaPlayerExtraData.h"
#import "ICNowPlayingViewController.h"
#import "ICNowPlayingView.h"
#import "ICIPodViewController.h"

@interface ICNowPlayingViewController ()

- (void)updateNowPlayingView;

@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, assign) float timeCurrentSongPlayed;
@property (nonatomic, assign) float songDuration;

- (void)resetNowPlayingView;
- (NSString *)formattedTimedFromTimeInSeconds:(float)seconds;

@end

@implementation ICNowPlayingViewController

@synthesize updateTimer = _updateTimer, timeCurrentSongPlayed = _timeCurrentSongPlayed, songDuration = _songDuration;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Scroll wheel delegate

- (void)scrollWheelPressedTopButton:(ICScrollWheelView *)scrollWheel
{
    //Stop the timer
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    //Change Views
    if([self.navigationController.viewControllers count] > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollWheel:(ICScrollWheelView *)scrollWheel didRotate:(CGFloat)degrees {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicPlayer.volume += (degrees > 0) ? .06 : -.06;
}


- (void)resetNowPlayingView {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMediaItem *nowPlayingItem = musicPlayer.nowPlayingItem;
    ICNowPlayingView *view = (ICNowPlayingView *)self.view;
    
    // Update UILabels
    NSUInteger numSongs = [[MPMediaPlayerExtraData sharedExtraData] collectionCount];
    
    
    view.songTitle.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    view.artist.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    
    if (numSongs != 0) {
        view.tracksCounter.text = [NSString stringWithFormat:@"%d of %d", [musicPlayer indexOfNowPlayingItem] + 1, numSongs];  //Note the index is zero based -> index 0 = song number 1

    }
    else
    {
        view.tracksCounter.text = @"";
    }
    NSNumber *songLength = [nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    self.songDuration = [songLength floatValue];
    self.timeCurrentSongPlayed = 0;
}

#pragma mark helpers
- (void)updateNowPlayingView {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];    
    ICNowPlayingView *view = (ICNowPlayingView *)self.view;
    self.timeCurrentSongPlayed = [musicPlayer currentPlaybackTime];
    
    // Update progress bar 
    view.progressView.progress = self.songDuration ? self.timeCurrentSongPlayed / self.songDuration : 0;
    view.timeThusFar.text = [self formattedTimedFromTimeInSeconds:self.timeCurrentSongPlayed];
    view.timeRemaining.text = [self formattedTimedFromTimeInSeconds:self.songDuration - self.timeCurrentSongPlayed];
}

- (NSString *)formattedTimedFromTimeInSeconds:(float)seconds {
    int minutes = seconds / 60;
    int adjustedSeconds = (int)seconds % 60;
    return [NSString stringWithFormat:@"%d:%02d",minutes,adjustedSeconds];
}

#pragma mark - Notifications

- (void)nowPlayingItemDidChange:(NSNotification *)notification
{
    [self resetNowPlayingView];
}

# pragma mark view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//Create a timer to update the progress view
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateNowPlayingView) userInfo:nil repeats:YES];

    //Must increase the size of the progress view for proper rendering without clipping
    //It is impossible to increase the height of progress view by using the story board
    ICNowPlayingView *view = (ICNowPlayingView *)self.view;
    [view.progressView setFrame:CGRectMake(view.progressView.frame.origin.x, view.progressView.frame.origin.y, 192, 13)];
    
    //Configure the now playing view
    [self resetNowPlayingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure click wheel
    
    [ICIPodViewController sharedIpod].scrollWheel.rotationTriggerSize = 10;
    
    // Register for notifiations
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingItemDidChange:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
    [musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Remove observer from notification center
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
    [musicPlayer endGeneratingPlaybackNotifications];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
