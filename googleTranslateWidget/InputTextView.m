//
//  InputTextView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 01/11/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView

-(void)unfold {
    InputScroll *scrollView = (InputScroll *) self.superview.superview;

    NSRect scrollFrame = scrollView.frame;
    NSRect textFrame = self.frame;
    
    scrollFrame.size.height=62;
    scrollFrame.origin.y-=40;
    textFrame.size.height=10000;

    
    self.superview.superview.frame = scrollFrame;
    self.frame=textFrame;

    [scrollView setScrolling:YES];
    self.open=YES;

}
-(void)fold {
    InputScroll *scrollView = (InputScroll *) self.superview.superview;
    
    NSRect scrollFrame = scrollView.frame;
    NSRect textFrame = self.frame;
    
    scrollFrame.size.height=22;
    scrollFrame.origin.y+=40;
    textFrame.size.height=40;
    
    self.superview.superview.frame = scrollFrame;
    self.frame=textFrame;
    
    [scrollView setScrolling:NO];
    self.open=NO;
}

@end
