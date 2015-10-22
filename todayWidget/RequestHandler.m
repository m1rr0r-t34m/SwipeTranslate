//
//  GoogleRequest.m
//
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import "RequestHandler.h"

@implementation RequestHandler

-(void)performRequestForSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText sender:(id)sender {
    
    returnView=sender;
    
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
    [self performRequestWithURL:url];
}
-(void)performRequestWithURL:(NSURL *)url {
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    
    
    [dataTask resume];
}




-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
    
    NSString *lang=[Parser AutoLanguage:data];
    NSString *text=[Parser Text:data];
    
    NSMutableArray *array=[NSMutableArray new];
    [array addObject:lang];
    [array addObject:text];
    
    [returnView performSelectorOnMainThread:@selector(processReceivedData:) withObject:array waitUntilDone:NO];
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@",error);
    }
}


@end