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
    
    //prepare url
    NSString *urlString=[NSString stringWithFormat:@"https://translate.googleapis.com/translate_a/single?client=gtx&ie=UTF-8&oe=UTF-8&sl=%@&tl=%@&dt=t&q=%@", sourceLanguage, targetLanguage, escapedInput];
    NSURL *url=[NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}
+(NSArray *)getRequestsForExternalURL:(NSString *)urlString{
    NSMutableArray *requests=[NSMutableArray new];
    NSURL *firstCandidateURL = [NSURL URLWithString:urlString];
    NSURL *secondCandidateUrl = [NSURL URLWithString:urlString];
    
    //If not valid URL retun NULL
    if(!firstCandidateURL)
        return NULL;
    else {
        //If doesn't have prefix, add both of them
        if(!firstCandidateURL.scheme){
            firstCandidateURL=[NSURL URLWithString:[NSString stringWithFormat:@"https://www.%@",urlString]];
            secondCandidateUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.%@",urlString]];
        }
        //Add 2 candidates to array and return it
        [requests addObject:[NSURLRequest requestWithURL:firstCandidateURL]];
        [requests addObject:[NSURLRequest requestWithURL:secondCandidateUrl]];
        return [[NSArray alloc] initWithArray:requests];
    }
}

@end


