//
//  LanguageCell.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 09/11/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "LanguageCell.h"

@implementation LanguageCell
-(NSRect)drawingRectForBounds:(NSRect)theRect {
    NSRect newRect=theRect;
    newRect.origin.x+=20;
    self.editable=NO;
    return newRect;
}
@end
