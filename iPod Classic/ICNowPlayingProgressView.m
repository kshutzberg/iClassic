#import "ICNowPlayingProgressView.h"

#define kCustomProgressViewFillOffsetX 1
#define kCustomProgressViewFillOffsetTopY 1
#define kCustomProgressViewFillOffsetBottomY 3

@implementation ICNowPlayingProgressView

- (void)drawRect:(CGRect)rect {
    UIImage *background = [UIImage imageNamed:@"PlaybarEmpty.png"];
    [background drawInRect:rect];
 
    UIImage *cursor = [UIImage imageNamed:@"DiamondPositionTracker.png"];
    NSInteger maxWidth = rect.size.width - cursor.size.width;
    NSInteger curWidth = floor([self progress] * maxWidth);  
    [cursor drawAtPoint:CGPointMake(curWidth, 0)];
}

@end
