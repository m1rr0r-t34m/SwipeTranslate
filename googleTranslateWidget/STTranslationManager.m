//
//  STTranslationManager.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 28/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STTranslationManager.h"
#import <AFNetworking/AFNetworking.h>


@implementation STTranslationManager


+(instancetype)Manager {
    
    static STTranslationManager *managerSignleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerSignleton = [[STTranslationManager alloc] init];
    });
    return managerSignleton;
}

-(instancetype)init {
    if(self = [super init]) {
        
    }
    return self;
}

-(void)getTranslationForString:(NSString *)string SourceLanguage:(NSString *)sourceLang AndTargetLanguage:(NSString *)targetLang {
    AFHTTPSessionManager *manger =[[AFHTTPSessionManager alloc] init];
    
    NSString *languages = [NSString stringWithFormat:@"%@-%@", sourceLang, targetLang];
    NSDictionary *params = @{@"key":@"trnsl.1.1.20151022T101327Z.947a48f231e6aa6e.7e71b163761e2e6791c492f9448b63e1c1f27a2e", @"text":string, @"lang":languages, @"options":@"1"};
    NSString *baseUrl = @"https://translate.yandex.net/api/v1.5/tr.json/translate";
    
    [manger setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
    NSURLSessionDataTask *task = [manger GET:baseUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}





@end
