//
//  LanguageCell.m
//  googleTranslateWidget
//
//  Created by Andrei on 24/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "LanguageCell.h"

@implementation LanguageCell


-(NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    return nil;
    //[NSColor colorWithDeviceRed:0.29 green:0.27 blue:0.42 alpha:1];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    //Define highlight cell and text color
    if ([self isHighlighted]) {
        [[NSColor colorWithDeviceRed:0.83 green:0.83 blue:0.83 alpha:1] set];
        cellFrame.origin.x -= 1;
        cellFrame.origin.y -= 1;
        cellFrame.size.height += 1;
        cellFrame.size.width += 5;
        
        NSRectFill(cellFrame);
        [self setTextColor:[NSColor whiteColor]];
        
    }
    else {
        [self setTextColor:[NSColor grayColor]];
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

-(NSRect)drawingRectForBounds:(NSRect)theRect {
    NSRect newRect=theRect;
    newRect.origin.x+=180;
    self.editable=NO;
    return newRect;
}

@end
