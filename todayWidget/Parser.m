//
//  GoogleString.m
//  
//
//  Created by Mark Vasiv on 04/09/15.
//
//

#import "Parser.h"

@implementation NSString (Parser)

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
//Method for retrieving language after language recognition request
-(NSString *)parseAutoForLanguage {
    
    int indexOfClosingBracket = 0;
    int indexOfOpeningQuote = 0;
    NSInteger endIndex = 0;
    NSInteger startIndex = 0;
    for (int i = (int)[self length]-1; i > 0; i--) {
        if ([self characterAtIndex:i]  == '"')
            indexOfOpeningQuote++;
        if ([self characterAtIndex:i ] ==']')
            indexOfClosingBracket++;
        
        if (indexOfClosingBracket == 4) {
            if(!endIndex)
                endIndex = i-2;
        }
        if (indexOfOpeningQuote == 2) {
            startIndex = i;
            break;
        }
        
    }
    
    return  [self substringWithRange:NSMakeRange(startIndex+1, endIndex-startIndex)];
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
