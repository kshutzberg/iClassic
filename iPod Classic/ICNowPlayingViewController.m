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


@property (nonatomic, retain) MPMediaItem *nowPlayingItem;
@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, assign) float timeCurrentSongPlayed;
@property (nonatomic, assign) float songDuration;

- (void)resetNowPlayingView;
- (NSString *)formattedTimedFromTimeInSeconds:(float)seconds;

@end

@implementation ICNowPlayingViewController

@synthesize updateTimer = _updateTimer, timeCurrentSongPlayed = _timeCurrentSongPlayed, songDuration = _songDuration, songs = _songs,
            currentSongIndex = _currentSongIndex, nowPlayingItem = _nowPlayingItem;

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
            
            //Set the current song to the previous song if we skip to previous item
            if (musicPlayer.currentPlaybackTime < 2) {
                self.currentSongIndex -= 1;
                //The first song's previous song is the last song
                if (self.currentSongIndex < 0) {
                    self.currentSongIndex = self.songs.count - 1;
                }
            }
            
            [self resetNowPlayingView];
            break;
        // Fastforward Button Pressed
        case ICScrollWheelButtonLocationRight:
            [musicPlayer skipToNextItem];
            [musicPlayer play];
            
            //Set the current song to the next song
            self.currentSongIndex++;
            self.currentSongIndex %= self.songs.count;
            
            [self resetNowPlayingView];
            break;
        // Select Button Pressed
        case ICScrollWheelButtonLocationCenter:
            break;
        default:
            break;
    }
}

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
    self.nowPlayingItem = musicPlayer.nowPlayingItem;
    ICNowPlayingView *view = (ICNowPlayingView *)self.view;
    view.songTitle.text = [self.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    view.artist.text = [self.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    view.tracksCounter.text = [NSString stringWithFormat:@"%d of %d", self.currentSongIndex + 1, self.songs.count];  //Note currentSongIndex is zero based -> index 0 = song number 1
    NSNumber *songLength = [self.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    self.songDuration = [songLength floatValue];
    self.timeCurrentSongPlayed = 0;
}

#pragma mark helpers
- (void)updateNowPlayingView {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    MPMediaItem *currentPlayingItem = musicPlayer.nowPlayingItem;
    //if the song has changed naturally we must detect and update the now playing view
    if (![self.nowPlayingItem isEqual:currentPlayingItem]) { 
        self.currentSongIndex++;
        self.currentSongIndex %= self.songs.count;
        [self resetNowPlayingView];
    }
    
    ICNowPlayingView *view = (ICNowPlayingView *)self.view;
    self.timeCurrentSongPlayed = [musicPlayer currentPlaybackTime];
    view.progressView.progress = self.timeCurrentSongPlayed / self.songDuration;
    view.timeThusFar.text = [self formattedTimedFromTimeInSeconds:self.timeCurrentSongPlayed];
    view.timeRemaining.text = [self formattedTimedFromTimeInSeconds:self.songDuration - self.timeCurrentSongPlayed];
}

- (NSString *)formattedTimedFromTimeInSeconds:(float)seconds {
    int minutes = seconds / 60;
    int adjustedSeconds = (int)seconds % 60;
    return [NSString stringWithFormat:@"%d:%02d",minutes,adjustedSeconds];
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
