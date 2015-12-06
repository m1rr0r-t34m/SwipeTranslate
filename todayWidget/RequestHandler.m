//
//  GoogleRequest.m
//
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import "RequestHandler.h"

@implementation RequestHandler
+(RequestHandler *)NewDictionaryRequest{
    
    RequestHandler *request=[[super alloc] init];
    [request setRequestType:@"dictionary"];
    return request;
}
+(RequestHandler *)NewTranslateRequest{
    
    RequestHandler *request=[[super alloc] init];
    [request setRequestType:@"translate"];
    return request;
}

-(void)performRequestForSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText {
    
    //Get keys for source language and target language
    NSString *sourceLanguage=[[NSArray getKeysArray] objectAtIndex:[[NSArray getValuesArray:YES] indexOfObject:sLang]];
    NSString *targetLanguage=[[NSArray getKeysArray] objectAtIndex:[[NSArray getValuesArray:YES] indexOfObject:tLang]];
    
    //encode input
    NSString *escapedInput = [inputText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *translateKey=@"trnsl.1.1.20151022T101327Z.947a48f231e6aa6e.7e71b163761e2e6791c492f9448b63e1c1f27a2e";
    NSString *dictionaryKey=@"dict.1.1.20151022T180334Z.52a72548fccdbcf3.fe30ded92dd2687f0229f3ebc9709f4e27891329";
    //prepare url
    NSString *urlString;
    
    if([[self requestType]isEqualToString:@"translate"]) {
        if(![sourceLanguage isEqualToString:@"auto"])
            urlString=[NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@-%@&options=1",translateKey, escapedInput,sourceLanguage, targetLanguage ];
        else
            urlString=[NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@&options=1",translateKey, escapedInput, targetLanguage ];
    }
    else {
        urlString=[NSString stringWithFormat:@"https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=%@&lang=%@-%@&text=%@",dictionaryKey,sourceLanguage, targetLanguage,escapedInput ];
    }
    
    
    NSURL *url=[NSURL URLWithString:urlString];
    [self performRequestWithURL:url];
}
-(void)performRequestWithURL:(NSURL *)url {
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    _currentSession=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    
    NSURLSessionDataTask *dataTask = [_currentSession dataTaskWithURL:url];
    
    
    [dataTask resume];
}




-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
    
    NSMutableArray *array=[NSMutableArray new];

    if([[self requestType]isEqualToString:@"translate"]) {
        NSString *lang=[Parser AutoLanguage:data];
        NSString *text=[Parser Text:data];
        if(lang)
            lang=[[NSArray getValuesArray:YES] objectAtIndex:[[NSArray getKeysArray] indexOfObject:lang]];
        
                [array addObject:lang];
        [array addObject:text];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [_delegate receiveTranslateResponse:array];
        });
    }
    
    else {
        NSDictionary *dictionary=[Parser Dictionary:data];
        [array addObject:dictionary];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [_delegate receiveDictionaryResponse:array];
        });
    }

    
   
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@",error);
    }
}
-(void)cancelCurrentSession {
    if(self.currentSession)
        [self.currentSession invalidateAndCancel];
}

@end