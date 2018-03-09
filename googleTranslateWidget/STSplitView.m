//
//  STSplitView.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 09/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STSplitView.h"

@implementation STSplitView
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        self.dividerStyle = NSSplitViewDividerStyleThin;
    }
    
    return self;
}

- (NSColor *)dividerColor {
    return [NSColor colorWithCalibratedRed:0.756 green:0.756 blue:0.756 alpha:0.65];
}

@end
