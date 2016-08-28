//
//  STLanguageCell.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLanguageCell.h"

@implementation STLanguageCell



-(void)drawSeparatorInRect:(NSRect)dirtyRect {
    if(self.index != 6) {
        
        NSBezierPath * gridPath = [NSBezierPath bezierPath];
                NSRect rowRect = dirtyRect;
        
        
                [gridPath moveToPoint:NSMakePoint(rowRect.origin.x, rowRect.origin.y + rowRect.size.height - 0.5)];
                [gridPath lineToPoint:NSMakePoint(rowRect.origin.x + rowRect.size.width, rowRect.origin.y + rowRect.size.height - 0.5 )];
                [[NSColor colorWithCalibratedRed:0.756 green:0.756 blue:0.756 alpha:0.65] set];
                [gridPath stroke];
    }
}



@end
