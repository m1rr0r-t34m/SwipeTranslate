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
    
}

-(void)closeFavouritesBar {
    
    [[NSAnimationContext currentContext] setDuration:0.6];
    [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x, self.frame.origin.y -60)];
    
}

@end
