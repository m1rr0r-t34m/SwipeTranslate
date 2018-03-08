//
//  STLanguageCell.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLanguageCell.h"
#import "STLanguageCellModel.h"

@implementation STLanguageCell

- (void)drawSeparatorInRect:(NSRect)dirtyRect {
    if (!self.viewModel.shouldDrawBorder) {
        return;
    }
    
    NSBezierPath *gridPath = [NSBezierPath bezierPath];
    NSRect rowRect = dirtyRect;

    [gridPath moveToPoint:NSMakePoint(rowRect.origin.x, rowRect.origin.y + rowRect.size.height - 0.5)];
    [gridPath lineToPoint:NSMakePoint(rowRect.origin.x + rowRect.size.width, rowRect.origin.y + rowRect.size.height - 0.5 )];
    [[NSColor colorWithCalibratedRed:0.756 green:0.756 blue:0.756 alpha:0.65] set];
    [gridPath stroke];    
}

- (void)setObjectValue:(id)objectValue {
    if (objectValue) {
        [self fillWithModel:(STLanguageCellModel *)objectValue];
    }
}

- (void)fillWithModel:(STLanguageCellModel *)model {
    [self.label setStringValue:model.title];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.label setTextColor:[NSColor blackColor]];
}
@end
