//
//  ICNowPlayingViewController.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "ICNowPlayingViewController.h"
#import "ICNowPlayingView.h"
#import "ICIPodViewController.h"

@interface ICNowPlayingViewController ()

- (void)updateNowPlayingView;

@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, assign) float timeCurrentSongPlayed;
@property (nonatomic, assign) float songDuration;

- (void)resetNowPlayingView;

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

- (void)scrollWheel:(ICScrollWheelView *)scrollWheel pressedButtonAtLocation:(ICScrollWheelButtonLocation)location
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    //TODO: Code unification
    switch (location) {
        // Menu Button Pressed
        case ICScrollWheelButtonLocationTop:
            //Stop the timer
            [self.updateTimer invalidate];
            self.updateTimer = nil;
            
            //Change Views
            if([self.navigationController.viewControllers count] > 1){
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        // Play/Pause Button Pressed
        case ICScrollWheelButtonLocationBottom:
            [musicPlayer playbackState] == MPMusicPlaybackStatePlaying ? [musicPlayer pause] : [musicPlayer play];
            break;
        // Rewind Button Pressed
        case ICScrollWheelButtonLocationLeft:
            (musicPlayer.currentPlaybackTime > 2) ? [musicPlayer skipToBeginning] : [musicPlayer skipToPreviousItem];
            [musicPlayer play];
            [self resetNowPlayingView];
            break;
        // Fastforward Button Pressed
        case ICScrollWheelButtonLocationRight:
            [musicPlayer skipToNextItem];
            [musicPlayer play];
            [self resetNowPlayingView];
            break;
        // Select Button Pressed
        case ICScrollWheelButtonLocationCenter:
            break;
        default:
            break;
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
    view.songTitle.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    view.artist.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *songLength = [nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    self.songDuration = [songLength floatValue];
    self.timeCurrentSongPlayed = 0;
}

#pragma mark helpers
- (void)updateNowPlayingView {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    ICNowPlayingView *view = (ICNowPlayingView *)self.view;
    self.timeCurrentSongPlayed = [musicPlayer currentPlaybackTime];
    view.progressView.progress = self.timeCurrentSongPlayed / self.songDuration;
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
    [ICIPodViewController sharedIpod].scrollWheel.rotationTriggerSize = 10;
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
