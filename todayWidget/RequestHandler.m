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
    request.keyHandler=[[KeyHandler alloc] init];
    return request;
}
+(RequestHandler *)NewTranslateRequest{
    
    RequestHandler *request=[[super alloc] init];
    [request setRequestType:@"translate"];
    request.keyHandler=[[KeyHandler alloc] init];
    return request;
}

-(void)performRequestForSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText {
    //Get keys for source language and target language
    NSString *sourceLanguage=[[NSArray getKeysArray] objectAtIndex:[[NSArray getValuesArray:YES] indexOfObject:sLang]];
    NSString *targetLanguage=[[NSArray getKeysArray] objectAtIndex:[[NSArray getValuesArray:YES] indexOfObject:tLang]];
    
    //encode input
    NSString *escapedInput = [inputText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    //prepare url
    NSString *urlString;
    
    if([[self requestType]isEqualToString:@"translate"]) {
        if(![sourceLanguage isEqualToString:@"auto"])
            urlString=[NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@-%@&options=1",[self.keyHandler currentTranslationKey], escapedInput,sourceLanguage, targetLanguage ];
        else
            urlString=[NSString stringWithFormat:@"https://translate.yandex.net/api/v1.5/tr.json/translate?key=%@&text=%@&lang=%@&options=1",[self.keyHandler currentTranslationKey], escapedInput, targetLanguage ];
    }
    else {
        urlString=[NSString stringWithFormat:@"https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=%@&lang=%@-%@&text=%@",[self.keyHandler currentDictionaryKey],sourceLanguage, targetLanguage,escapedInput ];
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
        
        if(!lang&&!text) {
            [self.keyHandler updateTranslationKey];
            return;
        }
        
        
        if(lang&&lang.length>0)
            lang=[[NSArray getValuesArray:YES] objectAtIndex:[[NSArray getKeysArray] indexOfObject:lang]];
        
        [array addObject:lang];
        [array addObject:text];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [_delegate receiveTranslateResponse:array];
        });
    }
    
    else {
        NSDictionary *dictionary=[Parser Dictionary:data];
        
        if(!dictionary){
            [self.keyHandler updateDictionaryKey];
            return;
        }
        
        
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