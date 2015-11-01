//
//  ValidateString.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 31/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "ValidateString.h"

@implementation NSString (ValidateString)
-(NSUInteger)countWords {
    __block NSUInteger wordCount = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                wordCount++;
                            }];
    return wordCount;
}
-(BOOL)isEmpty {
    if([self isEqualToString:@""]) {
        return YES;
    }
    return NO;
    
}
-(BOOL)isWhiteSpace {
    if([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        return YES;
    }
    return NO;
    
}
@end
