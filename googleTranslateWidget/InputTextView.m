//
//  InputTextView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 01/11/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView
@synthesize ready = _ready;

-(void)setReady:(BOOL)ready {
    _ready = ready;
    if(ready) {
        [self setString:@"Type some text"];
        [self setTextColor:[NSColor grayColor]];
        [self setSelectedRange:NSMakeRange(0, 0)];
    }
    else {
        [self setTextColor:[NSColor blackColor]];
    }
        
}
-(BOOL)ready{
    return _ready;
}
-(void)setSelectedRange:(NSRange)selectedRange {
    [super setSelectedRange:selectedRange];
    
}


@end
