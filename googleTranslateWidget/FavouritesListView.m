//
//  favouritesListView.m
//  googleTranslateWidget
//
//  Created by Andrei on 07/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "favouritesListView.h"

@implementation favouritesListView
float const defaultSlowSpeed = 150;
float const defaultMediumSpeed = 230;
float const defaultFastSpeed = 400;

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
    
    [_localDefaults setUsedSidebar:true];
    lastChange=change;
    
}

-(void)checkState{
    CGPoint origin = self.frame.origin;
    float modulusChange = ABS(lastChange);
    NSLog(@"last change %f",lastChange);

    if(modulusChange < 4) {
        if(origin.x > 653)
            [self closeBar:803-origin.x withSpeed:defaultSlowSpeed];
        
        else
            [self openBar:origin.x-503 withSpeed:defaultSlowSpeed];
        
    }
    else if(modulusChange < 15) {
        if(lastChange>0)
            [self closeBar:origin.x-503 withSpeed:defaultMediumSpeed];
        
        else
            [self openBar:803-origin.x withSpeed:defaultMediumSpeed];
    }
    else{
        if(lastChange>0)
            [self closeBar:origin.x-503 withSpeed:defaultFastSpeed];
        
        else
            [self openBar:803-origin.x withSpeed:defaultFastSpeed];
    }
    
    lastChange = 0;

}

-(void)closeBar:(int)distance withSpeed:(float)speed {
    [[NSAnimationContext currentContext ]setDuration:distance/(speed)];
    [[self animator] setFrameOrigin:NSMakePoint(803, self.frame.origin.y)];
}

-(void)openBar:(int)distance withSpeed: (float)speed {
    [[NSAnimationContext currentContext ]setDuration:distance/(speed)];
    [[self animator] setFrameOrigin:NSMakePoint(503, self.frame.origin.y)];
}

-(void)moveWithButton {
    [[NSAnimationContext currentContext] setDuration:0.5];
    

    if (self.frame.origin.x == 803)
        [[self animator] setFrameOrigin:NSMakePoint(503, self.frame.origin.y)];
    else if (self.frame.origin.x == 503)
        [[self animator] setFrameOrigin:NSMakePoint(803, self.frame.origin.y)];
}


@end
