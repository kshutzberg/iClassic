//
//  ICNowPlayingView.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICNowPlayingView : UIView

@property (nonatomic, retain) IBOutlet UILabel *songTitle;
@property (nonatomic, retain) IBOutlet UILabel *artist;
@property (nonatomic, retain) IBOutlet UILabel *tracksCounter;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;

@end
