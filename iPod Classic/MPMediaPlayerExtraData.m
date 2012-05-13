//
//  MPMediaPlayerControllerExtraData.m
//  iPod Classic
//
//  Created by Peter Tseng on 5/12/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "MPMediaPlayerExtraData.h"

@implementation MPMediaPlayerExtraData

@synthesize collectionCount = _collectionCount;

-(NSUInteger)retainCount {
    return NSUIntegerMax;
}

-(id)retain {
    return self;
}

- (oneway void)release {}

+ (id)sharedExtraData {
    static id sharedExtraData = nil;
    if (!sharedExtraData) {
        sharedExtraData = [self alloc];
    }
    return sharedExtraData;
}


@end
