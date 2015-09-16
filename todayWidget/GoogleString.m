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
-(NSString *)parseFirstDiveForAuto {
    int indexOfBracket=0;
    NSInteger endIndex=0;
    for(int i=(int)[self length]-1;i>0;i--){
        if([[self substringWithRange:NSMakeRange(i, 1)]isEqualToString:@"]"])
            indexOfBracket++;
        if(indexOfBracket==4){
            endIndex=i;
        }
        
    }
    return [self substringWithRange:NSMakeRange(2, endIndex-2)];
}
-(NSString *)parseSecondDive {
    int quoteCount=0;
    NSInteger endIndex;
    for(int i=0;i<[self length];i++){
        if([self characterAtIndex:i]=='"')
            quoteCount++;
        if([self characterAtIndex:i]==']'&&quoteCount%2==0){
            endIndex=i;
            break;
        }
    }
    return [self substringWithRange:NSMakeRange(0, endIndex+1)];
}
-(NSInteger)numberOfLines {
    int quoteCount=0;
    int numberOfLines=0;
    for(int i=0;i<[self length];i++){
        if([self characterAtIndex:i]=='"')
            quoteCount++;
        if(([self characterAtIndex:i]=='[')&&(quoteCount%2==0))
            numberOfLines++;
        
    }
    return numberOfLines;
}
-(NSString *)parseThirdDive {

    int countOfQuotes=0;
    NSInteger endIndex;
    for(int i=0;i<[self length];i++){
        if([self characterAtIndex:i]=='"'){
            countOfQuotes++;
            if(countOfQuotes==2) {
                endIndex=i;
                break;
            }
        }
    }
    return [self substringWithRange:NSMakeRange(2, endIndex-2)];
}

@end
