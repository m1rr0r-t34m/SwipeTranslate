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
    [[NSAnimationContext currentContext] setDuration:1.0];
    
    if (self.frame.origin.y == -65)
        [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x, self.frame.origin.y + 60)];
    else
        [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x, self.frame.origin.y - 60)];
    
}

@end
