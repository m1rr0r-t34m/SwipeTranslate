//
//  LanguageTable.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 30/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "LanguageTable.h"

@implementation LanguageTable

-(BOOL)acceptsFirstResponder{
    return NO;
}

- (void)drawRow:(NSInteger)rowIndex clipRect:(NSRect)clipRect {
    
    [super drawRow:rowIndex clipRect:clipRect];
    
    NSBezierPath * gridPath = [NSBezierPath bezierPath];
    NSRect rowRect = [self rectOfRow:rowIndex];
    if(rowIndex!=4) {
        
        [gridPath moveToPoint:NSMakePoint(rowRect.origin.x, rowRect.origin.y + rowRect.size.height-0.5)];
        [gridPath lineToPoint:NSMakePoint(rowRect.origin.x + rowRect.size.width, rowRect.origin.y + rowRect.size.height-0.5)];
        [[NSColor colorWithCalibratedRed:0.756 green:0.756 blue:0.756 alpha:0.65] set];
        [gridPath stroke];
    }
    
}

@end
