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

@interface ICNowPlayingViewController ()

- (void)updateNowPlayingView;

@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, assign) float timeCurrentSongPlayed;
@end

@implementation ICNowPlayingViewController

@synthesize updateTimer = _updateTimer, timeCurrentSongPlayed = _timeCurrentSongPlayed;

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
            self.timeCurrentSongPlayed = 0;
            (musicPlayer.currentPlaybackTime > 2) ? [musicPlayer skipToBeginning] : [musicPlayer skipToPreviousItem];
            [musicPlayer play];
            [self updateNowPlayingView];
            break;
        // Fastforward Button Pressed
        case ICScrollWheelButtonLocationRight:
            self.timeCurrentSongPlayed = 0;
            [musicPlayer skipToNextItem];
            [musicPlayer play];
            [self updateNowPlayingView];
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
    musicPlayer.volume += (degrees > 0) ? .1 : -.1;
}

#pragma mark helpers
- (void)updateNowPlayingView {

    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    MPMediaItem *nowPlayingItem = musicPlayer.nowPlayingItem;
    ICNowPlayingView *view = (ICNowPlayingView *)self.view;
    view.mainLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    
    //Approximately Update time played
    self.timeCurrentSongPlayed += [musicPlayer playbackState] == MPMusicPlaybackStatePlaying ? .1 : 0;
    NSNumber *songLength = [nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    view.progressView.progress = self.timeCurrentSongPlayed / [songLength floatValue];  
}

# pragma mark view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateNowPlayingView) userInfo:nil repeats:YES];
    self.timeCurrentSongPlayed = 0;
    [self updateNowPlayingView];
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
