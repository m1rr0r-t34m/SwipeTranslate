//
//  favouritesListView.m
//  googleTranslateWidget
//
//  Created by Andrei on 07/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "favouritesListView.h"

@implementation favouritesListView
float const defaultSpeed = 80;

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
    CGPoint origin = self.frame.origin;
    float modulusChange = ABS(lastChange);
    

    if(modulusChange < 4) {
        if(origin.x > 653)
            [self closeBar:803-origin.x];
        
        else
            [self openBar:origin.x-503];
        
    }
    else{
        if(lastChange>0)
            [self closeBar:origin.x-503];
        
        else
            [self openBar:803-origin.x];
    }
    


}

-(void)closeBar:(int)distance {
    [[NSAnimationContext currentContext ]setDuration:distance/(defaultSpeed)];
    [[self animator] setFrameOrigin:NSMakePoint(803, self.frame.origin.y)];
}

-(void)openBar:(int)distance {
    [[NSAnimationContext currentContext ]setDuration:distance/(defaultSpeed)];
    [[self animator] setFrameOrigin:NSMakePoint(503, self.frame.origin.y)];
}

@end
