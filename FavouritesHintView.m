//
//  FavouritesHintView.m
//  googleTranslateWidget
//
//  Created by Andrei on 10/03/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "FavouritesHintView.h"

@implementation FavouritesHintView

-(void)moveFavouritesBar {
    [[NSAnimationContext currentContext] setDuration:0.6];
    
    if (self.frame.origin.y == -65)
        [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x, self.frame.origin.y + 60)];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                     selector:@selector(closeFavouritesBar)
                                     userInfo:nil
                                     repeats:NO];
    
    _arrowTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                           target:self
                                                           selector:@selector(moveArrow)
                                                           userInfo:nil
                                                           repeats:YES];
    

    
}

-(void)moveArrow {
    [[NSAnimationContext currentContext] setDuration:0.7];
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [arrowImageLeft setFrameOrigin:NSMakePoint(arrowImageLeft.frame.origin.x + 650, arrowImageLeft.frame.origin.y)];
    }];
    
    if (arrowImageLeft.frame.origin.x == 584)
        [[arrowImageLeft animator] setFrameOrigin:NSMakePoint(arrowImageLeft.frame.origin.x - 650, arrowImageLeft.frame.origin.y)];
    [CATransaction commit];
}

-(void)closeFavouritesBar {
    
    [[NSAnimationContext currentContext] setDuration:0.6];
    
    if (self.frame.origin.y == -5)
        [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x, self.frame.origin.y -60)];
    [_arrowTimer invalidate];
}

@end
