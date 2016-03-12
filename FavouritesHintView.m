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
    
    _barTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                     selector:@selector(closeHintBar)
                                     userInfo:nil
                                     repeats:NO];
    
    _arrowTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                     selector:@selector(moveArrow)
                                     userInfo:nil
                                     repeats:YES];
    _isOpened = YES;
    

    
}

-(void)moveArrow {
    [[NSAnimationContext currentContext] setDuration:0.9];
    [arrowImageLeft setHidden:NO];
    
   // [arrowImageLeft setFrameOrigin:NSMakePoint(100, arrowImageLeft.frame.origin.y)];
    
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [arrowImageLeft setFrameOrigin:NSMakePoint(arrowImageLeft.frame.origin.x + 166, arrowImageLeft.frame.origin.y)];
        [arrowImageLeft setHidden:YES];
    }];
    
    if (arrowImageLeft.frame.origin.x == 100)
        [[arrowImageLeft animator] setFrameOrigin:NSMakePoint(arrowImageLeft.frame.origin.x - 166, arrowImageLeft.frame.origin.y)];
    [CATransaction commit];
}

-(void)closeHintBar{
    [[NSAnimationContext currentContext] setDuration:0.08];
    [[self animator] setHidden:YES];

    [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x, -65)];
    [_arrowTimer invalidate];
    [_barTimer invalidate];
    _isOpened = NO;
}

/*-(void)closeHintBarWithSpeed:(CGFloat)change {

  
    
        [[NSAnimationContext currentContext] setDuration:0.08];
    
    
    [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x, -65)];
    [_barTimer invalidate];
    [_arrowTimer invalidate];
    
    if (change < 0){
        if (self.frame.origin.y <= -5) {
            if (self.frame.origin.y + change <= -5 && self.frame.origin.y + change >= -65)
                [self setFrameOrigin:NSMakePoint(self.frame.origin.x, self.frame.origin.y + change)];
            else
                [self setFrameOrigin:NSMakePoint(self.frame.origin.x, -65)];
        }
    }
}
*/


@end
