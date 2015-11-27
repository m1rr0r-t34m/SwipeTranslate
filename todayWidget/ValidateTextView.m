//
//  ValidativeTextView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "ValidateTextView.h"

@implementation NSTextView (ValidateTextView)

-(BOOL)isEmpty {
    if([[[self textStorage]string]isEqualToString:@""]) {
        return YES;
    }
    return NO;

}
-(BOOL)isWhiteSpace {
    if([[[self textStorage] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        return YES;
    }
    return NO;

}
-(NSUInteger)countWords {
    __block NSUInteger wordCount = 0;
    [[self string] enumerateSubstringsInRange:NSMakeRange(0, [self string].length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              wordCount++;
                          }];
    return wordCount;
}

@end
