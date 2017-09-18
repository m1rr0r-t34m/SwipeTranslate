//
//  STTranslationManager.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 28/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STTranslationManager.h"
#import <AFNetworking/AFNetworking.h>

#define translationToken @"trnsl.1.1.20151022T101327Z.947a48f231e6aa6e.7e71b163761e2e6791c492f9448b63e1c1f27a2e"
#define dictionaryToken @"dict.1.1.20151022T180334Z.52a72548fccdbcf3.fe30ded92dd2687f0229f3ebc9709f4e27891329"
#define translationBaseURL @"https://translate.yandex.net/api/v1.5/tr.json/translate"
#define dictionaryBaseURL @"https://dictionary.yandex.net/api/v1/dicservice.json/lookup"

@interface STTranslationManager ()

@property (strong, nonatomic, readwrite) NSDictionary *result;
@property (strong, nonatomic, readwrite) NSDictionary *internalResult;
@property (strong, nonatomic, readwrite) NSString *detectedLanguage;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) NSURLSessionDataTask *currentTask;

@end

@implementation STTranslationManager
//TODO: Change keys

+ (instancetype)manager {
    
    static STTranslationManager *managerSignleton;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        managerSignleton = [[STTranslationManager alloc] init];
    });
    return managerSignleton;
}

- (instancetype)init {
    if(self = [super init]) {
        _result = [NSDictionary new];
        _manager = [AFHTTPSessionManager new];
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    }
    return self;
}

//TODO: Maybe we can store translation response in the private buffer (to avoid multiple public object updates)
// NSCAche
- (void)getTranslationForString:(NSString *)string SourceLanguage:(NSString *)sourceLang AndTargetLanguage:(NSString *)targetLang {
    
    [self cancelCurrentSession];
    
    //Handle auto language
    NSString *languages = [NSString new];
    
    if ([sourceLang isEqualToString:@"auto"]) {
        languages = targetLang;
    }
    else {
        languages = [NSString stringWithFormat:@"%@-%@", sourceLang, targetLang];
    }
    
    NSDictionary *params = @{@"key" : translationToken,
                             @"text" : string,
                             @"lang" : languages,
                             @"options" : @"1"};
    
    self.currentTask = [self.manager GET:translationBaseURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.internalResult = responseObject;
        
        if([sourceLang isEqualToString:@"auto"] && [responseObject objectForKey:@"detected"]) {
            NSString *detectedSourceLang = [[responseObject objectForKey:@"detected"] objectForKey:@"lang"];
            [self dictionaryTranslationForString:string sourceLanguage:detectedSourceLang targetLanguage:targetLang];
            self.detectedLanguage = detectedSourceLang;
        }
        else {
            [self dictionaryTranslationForString:string sourceLanguage:sourceLang targetLanguage:targetLang];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //TODO: Do something, reschedule, etc
        NSLog(@"Failed to perform translate request, %@", error);
    }];
}

- (void)dictionaryTranslationForString:(NSString *)string sourceLanguage:(NSString *)sourceLang targetLanguage:(NSString *)targetLang {
    
    NSString *languages = [NSString stringWithFormat:@"%@-%@", sourceLang, targetLang];
    NSDictionary *params = @{@"key" : dictionaryToken,
                            @"lang" : languages,
                            @"text" : string};
    self.currentTask = [self.manager GET:dictionaryBaseURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![[responseObject objectForKey:@"def"] count]) {
            //Dictionary response not available, handle previous response
            self.result = self.internalResult;
            return;
        }
        else {
            self.internalResult = responseObject;
            self.result = responseObject;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.result = self.internalResult;
        NSLog(@"Failed to perform dictionary request, %@", error);
    }];
}

- (void)cancelCurrentSession {
    [self.currentTask cancel];
}

@end
