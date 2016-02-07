//
//  favouritesListView.m
//  googleTranslateWidget
//
//  Created by Andrei on 07/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "favouritesListView.h"

@implementation favouritesListView

-(void)changeOrigin:(CGFloat)change{
    [[NSAnimationContext currentContext ]setDuration:0];
    if (self.frame.origin.x <= 503)
        _isOpened = YES;
    else
        _isOpened = NO;
    
    if (self.frame.origin.x >= 803)
        _isClosed = YES;
    else
        _isClosed = NO;
    
    if (_isOpened == YES && change < 0)
        [[self animator] setFrameOrigin:NSMakePoint(503, self.frame.origin.y)];
    else if (_isClosed == YES && change > 0)
        [[self animator] setFrameOrigin:NSMakePoint(803, self.frame.origin.y)];
    else
        [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x + change, self.frame.origin.y)];
    
}

-(void)checkState{
    if (self.frame.origin.x < 700)
        [[self animator] setFrameOrigin:NSMakePoint(503, self.frame.origin.y)];
    else
        [[self animator] setFrameOrigin:NSMakePoint(803, self.frame.origin.y)];
  
}



@end
