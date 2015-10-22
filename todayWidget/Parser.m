//
//  Parser.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "Parser.h"

@implementation Parser
+(NSString *)ParseGeneral:(NSData *)data {
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    strData=[strData parseFirstDive];
    
    return  [Parser ParseBody:strData];
}
+(NSString *)ParseBody:(NSString *)strData {
    
    NSInteger numberOfLines=[strData numberOfLines];
    NSString *outputString=[[NSString alloc] init];
    
    while(numberOfLines){
        NSString *strLine=[[NSString alloc]init];
        strLine=[strData parseSecondDive];
        if([strLine length]!=[strData length])
            strData=[strData substringWithRange:NSMakeRange([strLine length]+1, [strData length]-[strLine length]-1)];
        strLine=[strLine parseThirdDive];
        
        outputString =[outputString stringByAppendingString:strLine];
        numberOfLines--;
    }
    
    //Make end of line symbols visible by NSTextView
    outputString=[outputString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    outputString=[outputString stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r"];
    
    return outputString;

}
+(NSString *)ParseAuto:(NSData *)data {
    
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    strData=[strData parseFirstDiveForAuto];
    
    return  [Parser ParseBody:strData];
   
}
+(NSString *)ParseAutoCode:(NSData *)data {
    //Convert received data to NSString using NSUTF8StringEncoding
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return [strData parseAutoForLanguage];
    
}
@end
