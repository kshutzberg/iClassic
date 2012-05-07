//
//  ICTableView.m
//  iPod Classic
//
//  Created by Julian Shutzberg on 5/4/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ICTableView.h"

#import "Colors.h"

@implementation ICTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = TABLE_COLOR;
    }
    return self;
}

// There is a lag with regular tableivew selection (if you scroll fast enough, multiple cells will temporarily appear to be selected at the same time... so we have to implement our own selection visually.

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentView.backgroundColor = TABLE_COLOR_SELECTED;
    cell.backgroundColor = TABLE_COLOR_SELECTED;
    
    [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [super deselectRowAtIndexPath:indexPath animated:animated];
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = TABLE_COLOR;
    cell.backgroundColor = TABLE_COLOR;
}


@end
