//
//  STApiKeyServiceImpl.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 23/02/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STAPIServiceImpl.h"
#import "STLanguage.h"
#import "STNetworkWrapper.h"
#import <ReactiveObjC.h>
#import "STParserResult.h"
#import "STConstants.h"

#define TranslationBaseURL @"https://translate.yandex.net/api/v1.5/tr.json/translate"
#define DictionaryBaseURL @"https://dictionary.yandex.net/api/v1/dicservice.json/lookup"

#define TranslationKeys @[]

#define DictionaryKeys @[]

@interface STAPIServiceImpl()
@property (strong, nonatomic) NSString *translationKey;
@property (strong, nonatomic) NSString *dictionaryKey;
@property (strong, nonatomic) STNetworkWrapper *networkManager;
@property (strong, nonatomic) id <STParserService> parserService;
@end

@implementation STAPIServiceImpl
- (instancetype)init {
    self = [super init];
    NSAssert(NO, @"Use designated initializer initWithParserService:");
    return self;
}

- (instancetype)initWithParserService:(id <STParserService>)parserService {
    if (self = [super init]) {
        _parserService = parserService;
        _networkManager = [STNetworkWrapper new];
        _translationKey = TranslationKeys[0];
        _dictionaryKey = DictionaryKeys[0];
    }
    
    return self;
}

- (RACSignal *)translationForText:(NSString *)text fromLanguage:(STLanguage *)source toLanguage:(STLanguage *)target {
    NSString *languages = [NSString stringWithFormat:@"%@-%@", source.key, target.key];
    if ([source.key isEqualToString:@"auto"]) {
        languages = target.key;
    }
    
    NSDictionary *params = @{@"key" : self.translationKey,
                             @"text" : text,
                             @"lang" : languages,
                             @"options" : @"1"};
    
    @weakify(self);
    return [[[self.networkManager requestWithURL:TranslationBaseURL parameters:params]
             flattenMap:^RACSignal *(NSDictionary *response) {
                 @strongify(self);
                 return [self.parserService translationForRawData:response];
             }]
             catch:^RACSignal *(NSError *error) {
                 @strongify(self);
                 NSInteger code = 0;
                 if ([error.domain isEqualToString:AFNetworkingErrorDomain]) {
                     code = [error.userInfo[AFNetworkingURLResponseErrorKey] statusCode];
                 } else if ([error.domain isEqualToString:STParserErrorDomain]) {
                     code = [error.userInfo[STParserOriginalCode] integerValue];
                 }
                 
                 if ([self errorCodeIndicatesKeyProblem:code]) {
                     [self switchTranslationKey];
                     if ([TranslationKeys indexOfObject:self.translationKey] != 0) {
                        return [self translationForText:text fromLanguage:source toLanguage:target];
                     }
                 }
                 
                 return [RACSignal error:error];
             }];
}

- (RACSignal *)definitionForText:(NSString *)text fromLanguage:(STLanguage *)source toLanguage:(STLanguage *)target {
    NSString *languages = [NSString stringWithFormat:@"%@-%@", source.key, target.key];
    NSDictionary *params = @{@"key" : self.dictionaryKey,
                             @"lang" : languages,
                             @"text" : text};
    
    @weakify(self);
    return [[[self.networkManager requestWithURL:DictionaryBaseURL parameters:params]
             flattenMap:^RACSignal *(NSDictionary *response) {
                 @strongify(self);
                 return [self.parserService definitionForRawData:response];
             }]
             catch:^RACSignal *(NSError *error) {
                 @strongify(self);
                 NSInteger code = 0;
                 if ([error.domain isEqualToString:AFNetworkingErrorDomain]) {
                     code = [error.userInfo[AFNetworkingURLResponseErrorKey] statusCode];
                 } else if ([error.domain isEqualToString:STParserErrorDomain]) {
                     code = [error.userInfo[STParserOriginalCode] integerValue];
                 }
                 
                 if ([self errorCodeIndicatesKeyProblem:code]) {
                     [self switchDictionaryKey];
                     if ([DictionaryKeys indexOfObject:self.dictionaryKey] != 0) {
                        return [self definitionForText:text fromLanguage:source toLanguage:target];
                     }
                 }
                 
                 return [RACSignal error:error];
             }];
}

- (void)switchTranslationKey {
    NSUInteger index = [TranslationKeys indexOfObject:self.translationKey];
    index++;
    if (index >= TranslationKeys.count) index = 0;
    self.translationKey = TranslationKeys[index];
}

- (void)switchDictionaryKey {
    NSUInteger index = [DictionaryKeys indexOfObject:self.dictionaryKey];
    index++;
    if (index >= DictionaryKeys.count) index = 0;
    self.dictionaryKey = DictionaryKeys[index];
}

- (BOOL)errorCodeIndicatesKeyProblem:(NSInteger)code {
    switch (code) {
        case 401:
            return YES;
            break;
        case 402:
            return YES;
            break;
        case 403:
            return YES;
            break;
        case 404:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}
@end
