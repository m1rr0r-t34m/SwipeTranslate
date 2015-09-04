//
//  GoogleString.m
//  
//
//  Created by Mark Vasiv on 04/09/15.
//
//

#import "GoogleString.h"

@implementation NSString (GoogleString)

-(NSString *)parseFirstDive {
    bool isThatSecondBracket=NO;
    NSInteger endIndex;
    for(int i=(int)[self length]-1;i>0;i--){
        if([[self substringWithRange:NSMakeRange(i, 1)]isEqualToString:@"]"]){
            if(!isThatSecondBracket)
                isThatSecondBracket=YES;
            else{
                endIndex=i;
                break;
            }
        }
    }
    return [self substringWithRange:NSMakeRange(2, endIndex-2)];
}
-(NSString *)parseSecondDive {
    NSInteger endIndex;
    for(int i=0;i<[self length];i++){
        if([[self substringWithRange:NSMakeRange(i, 1)]isEqualToString:@"]"]){
            endIndex=i;
            break;
        }
    }
    return [self substringWithRange:NSMakeRange(0, endIndex+1)];
}
-(NSInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"["] count]-1;
}
-(NSString *)parseThirdDive {
    bool isThatSecondQuote=NO;
    NSInteger endIndex;
    for(int i=(int)[self length]-1;i>0;i--){
        if([[self substringWithRange:NSMakeRange(i, 1)]isEqualToString:@"\""]){
            if(!isThatSecondQuote)
                isThatSecondQuote=YES;
            else{
                endIndex=i;
                break;
            }
        }
    }
    return [self substringWithRange:NSMakeRange(2, endIndex-4)];
}

@end
