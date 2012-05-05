//
//  MPMediaItem+InformationAccessors.h
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaItem (InformationAccessors)

// Instead of calling valueForProperty throughout the app, lets make a category to encapsulate these with convinience methods and get type checking.

- (NSString *)songTitle;
- (NSString *)artistName;

@end
