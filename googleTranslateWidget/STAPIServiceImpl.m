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

#define TranslationKeys @[/*@"trnsl.1.1.20180301T131042Z.020bf4004a465716.c1c40e66bb6039f508e8a7a8c182765082a0f6cd",*/\
                            @"trnsl.1.1.20151022T101327Z.947a48f231e6aa6e.7e71b163761e2e6791c492f9448b63e1c1f27a2e", \
                            @"trnsl.1.1.20160205T220026Z.f79840726332a14f.3c6ff3304b4bafc4d2a932d887dc44da76d81514", \
                            @"trnsl.1.1.20160116T172821Z.1f08aedad7321adc.c61d63de33f7b02ef4fc0ff70bab33484e4f099b", \
                            @"trnsl.1.1.20160205T220239Z.ce57f766890fc533.4a16bfec84c96e8efa15e41c7d5a6d9b1e9a3d30"]

#define DictionaryKeys @[@"dict.1.1.20151022T180334Z.52a72548fccdbcf3.fe30ded92dd2687f0229f3ebc9709f4e27891329", \
                         @"dict.1.1.20160205T215034Z.bf16881b170334ea.acaaf8e74a7585d32222c44dd8b24b1f9a600d63", \
                         @"dict.1.1.20160205T220348Z.40c3f7bad7f3bfef.b687e6d75d1480c6dff2a42f247c05b03d8d1efa", \
                         @"dict.1.1.20160205T220417Z.0f58b3598733ed32.e125d2f45d0add3a56bc1faaef7650b3c440a407"]

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
