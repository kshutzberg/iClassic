//
//  ICNowPlayingView.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICNowPlayingView : UIView

@property (nonatomic, copy) NSString *bannerText;           // Main Text on screen: traditionally "Artist \n Song \n album"

@property (nonatomic, assign) int currentSongNumber;        // These two will be used to display in the top left:
@property (nonatomic, assign) int totalNumberOfSongs;       // [current #] of [total #]

@property (nonatomic, assign) NSTimeInterval currentTime;   // Displayed at the bottom left under the progress bar
@property (nonatomic, assign) NSTimeInterval totalTime;     // Displayed at the bottom right under the progress bar


@end
