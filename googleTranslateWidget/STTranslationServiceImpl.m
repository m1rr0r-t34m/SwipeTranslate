//
//  STTranslationServiceImpl.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STTranslationServiceImpl.h"
#import <ReactiveObjC.h>
#import "STLanguage.h"
#import "STTranslation.h"
#import "STParserResult.h"

@interface STTranslationServiceImpl()
@property (strong, nonatomic) id <STAPIService> apiService;
@end

@implementation STTranslationServiceImpl
- (instancetype)init {
    self = [super init];
    NSAssert(NO, @"Use designated initializer initWithAPIService:");
    return self;
}

- (instancetype)initWithAPIService:(id <STAPIService>)apiService {
    if (self = [super init]) {
        _apiService = apiService;
    }
    
    return self;
}

- (RACSignal *)translationForText:(NSString *)text fromLanguage:(STLanguage *)source toLanguage:(STLanguage *)target {
    if ([self textIsWhiteSpace:text]) {
        return [RACSignal return:[STTranslation emptyTranslation]];
    }
    
    __block STTranslation *translation = [STTranslation new];
    BOOL autoLanguage = [source.key isEqualToString:@"auto"];
    translation.type = autoLanguage? STTranslationTypeAuto : STTranslationTypeNormal;
    
    @weakify(self);
    return [[[self.apiService translationForText:text fromLanguage:source toLanguage:target]
              flattenMap:^RACSignal *(STParserResult *result) {
                  @strongify(self);
                  RACSignal *forwardSignal = [RACSignal return:result];
                  STLanguage *fromLanguage = source;
                  STLanguage *toLanguage = target;
                  if (translation.type == STTranslationTypeAuto && result.detectedLanguage) {
                      translation.detectedLanguage = result.detectedLanguage;
                      fromLanguage = result.detectedLanguage;
                  }
                  return [[self.apiService definitionForText:text fromLanguage:fromLanguage toLanguage:toLanguage] catchTo:forwardSignal];
              }]
             map:^id(STParserResult *response) {
                 translation.inputText = text;
                 translation.sourceLanguage = source;
                 translation.targetLanguage = target;
                 translation.parserResult = response;
                 return translation;
             }];
}

- (BOOL)textIsWhiteSpace:(NSString *)text {
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}
@end
