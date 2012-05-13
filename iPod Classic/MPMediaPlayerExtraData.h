//
//  MPMediaPlayerControllerExtraData.h
//  iPod Classic
//
//  Created by Peter Tseng on 5/12/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMediaPlayerExtraData : NSObject

@property (nonatomic, readwrite) NSUInteger collectionCount;

+ (id)sharedExtraData;

@end
