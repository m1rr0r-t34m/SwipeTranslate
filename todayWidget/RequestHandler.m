//
//  GoogleRequest.m
//  
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import "RequestHandler.h"

@implementation RequestHandler

+(NSURLRequest *)getRequestForSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText {
    //Get keys for source language and target language
    NSString *sourceLanguage=[[NSArray getKeysArray] objectAtIndex:[[NSArray getValuesArray:YES] indexOfObject:sLang]];
    NSString *targetLanguage=[[NSArray getKeysArray] objectAtIndex:[[NSArray getValuesArray:YES] indexOfObject:tLang]];
    
    //encode input
    NSString *escapedInput = [inputText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *translateKey=@"trnsl.1.1.20151022T101327Z.947a48f231e6aa6e.7e71b163761e2e6791c492f9448b63e1c1f27a2e";
    //prepare url
    NSString *urlString;
    if(![sourceLanguage isEqualToString:@"auto"])
        urlString=[NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@-%@&options=1",translateKey, escapedInput,sourceLanguage, targetLanguage ];
    else
        urlString=[NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@&options=1",translateKey, escapedInput, targetLanguage ];
    

    NSURL *url=[NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}
@end


