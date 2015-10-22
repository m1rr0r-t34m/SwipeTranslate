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
-(void)deleteQuotes {
    NSRange searchRange = [[[self textStorage] string] rangeOfString:@"\""];
    if (searchRange.location != NSNotFound)
    {
        [self setString:[[[self textStorage] string] stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        [self setSelectedRange:NSMakeRange(searchRange.location,0) ];
    }
    
}


@end
