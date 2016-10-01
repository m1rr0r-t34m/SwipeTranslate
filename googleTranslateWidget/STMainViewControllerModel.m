//
//  MainViewControllerModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STMainViewControllerModel.h"

#import "STLanguages.h"
#import "STTranslationManager.h"
#import "Parser.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation STMainViewControllerModel

- (instancetype)init {
    if(self = [super init]) {
        [self setupBindings];
    }
    return self;
}

- (void) setupBindings {
    
    RACSignal *translationNeedSignal =
    [RACSignal combineLatest:@[[RACObserve(self, sourceText) ignore:nil],
                       [RACObserve(self, sourceLanguage) ignore:nil],
                       [RACObserve(self, targetLanguage) ignore:nil]]];
    
    [self rac_liftSelector:@selector(performTranslationFor:from:to:)
               withSignalOfArguments:[translationNeedSignal throttle:0.5]];
    
    RACSignal *translationSignal =
    [[[[RACObserve([STTranslationManager manager], result)
        ignore:nil] 
        filter:^BOOL(NSDictionary *receivedData) {
            return [[receivedData allKeys] count];
        }]
        map:^id(NSDictionary *receivedData) {
            return [Parser parsedResult:receivedData];
        }]
        filter:^BOOL(NSAttributedString *result) {
            return [result length] > 0;
        }];
    
    RAC(self, translatedText) = translationSignal;
    
}
- (void) performTranslationFor:(NSString *)text from:(NSString *)source to:(NSString *)target {

    [[STTranslationManager manager] getTranslationForString:text SourceLanguage:[STLanguages keyForLanguage:source] AndTargetLanguage:[STLanguages keyForLanguage:target]];
}

@end
