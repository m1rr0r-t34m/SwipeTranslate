//
//  NSAttributedString+Trimming.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 12/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "NSAttributedString+Trimming.h"

@implementation NSMutableAttributedString (Trimming)
-(void)trimWhitespace {
    // Trim leading whitespace and newlines
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [self.string rangeOfCharacterFromSet:charSet];
    
    while (range.length != 0 && range.location == 0)
    {
        [self replaceCharactersInRange:range withString:@""];
        range = [self.string rangeOfCharacterFromSet:charSet];
    }
    
    // Trim trailing whitespace and newlines
    range = [self.string rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    while (range.length != 0 && NSMaxRange(range) == self.length)
    {
        [self replaceCharactersInRange:range
                                 withString:@""];
        range = [self.string rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    }
}


@end
