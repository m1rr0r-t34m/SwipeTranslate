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

    if(change > 0){
        if(self.frame.origin.x <= 803){
            if(self.frame.origin.x + change <= 803)
                [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x + change, self.frame.origin.y)];
            else
                [[self animator] setFrameOrigin:NSMakePoint(803, self.frame.origin.y)];
        }
        
    }
    else if(change < 0){
        if(self.frame.origin.x >= 503){
            if(self.frame.origin.x + change >= 503)
                [[self animator] setFrameOrigin:NSMakePoint(self.frame.origin.x + change, self.frame.origin.y)];
            else
                [[self animator] setFrameOrigin:NSMakePoint(503, self.frame.origin.y)];
        }
        
    }
    
    
    lastChange=change;
    
}

-(void)checkState{
    if(lastChange>0){
        [[NSAnimationContext currentContext ]setDuration:1/lastChange];
        [[self animator] setFrameOrigin:NSMakePoint(803, self.frame.origin.y)];
    }
    else if(lastChange<0){
        [[NSAnimationContext currentContext ]setDuration:-1/lastChange];
        [[self animator] setFrameOrigin:NSMakePoint(503, self.frame.origin.y)];
    }
}



@end
