//
//  MainViewControllerModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STMainViewModel.h"
#import "STTranslation.h"
#import "STLanguage.h"
#import <ReactiveObjC.h>
#import "STServicesImpl.h"

@interface STMainViewModel()
@property (readwrite, nonatomic) id <STServices> services;
@property (readwrite, assign, nonatomic) BOOL translating;
@property (strong, nonatomic) RACSignal *allowTranslationSignal;
@property (strong, nonatomic) RACSubject *allowTranslationSubject;
@end

@implementation STMainViewModel
#pragma mark - Initializations
- (instancetype)init {
    if (self = [super init]) {
        _services = [STServicesImpl new];
        _allowTranslationSubject = [RACSubject new];
        _allowTranslationSignal = [_allowTranslationSubject deliverOnMainThread];
        [self setupBindings];
    }
    return self;
}

#pragma mark - Bindings
- (void)setupBindings {
    RACSignal *textSignal = [RACObserve(self, sourceText) ignore:nil];
    RACSignal *sourceLanguageSignal = [RACObserve(self, sourceLanguage) ignore:nil];
    RACSignal *targetLanguageSignal = [RACObserve(self, targetLanguage) ignore:nil];
    
    @weakify(self);
    [[[[[[RACSignal combineLatest:@[textSignal, sourceLanguageSignal, targetLanguageSignal]] sample:self.allowTranslationSignal]
        filter:^BOOL(RACTuple *tuple) {
            RACTupleUnpack(NSString *text, STLanguage *source, STLanguage *target) = tuple;
            return ![self.translation.inputText isEqualToString:text] || ![self.translation.sourceLanguage isEqual:source] || ![self.translation.targetLanguage isEqual:target];
        }]
        map:^RACSignal *(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSString *text, STLanguage *source, STLanguage *target) = tuple;
            self.translating = YES;
            return [self errorFreeTranslationForText:text fromLanguage:source toLanguage:target];
        }]
        switchToLatest]
        subscribeNext:^(STTranslation *translation) {
            @strongify(self);
            self.translating = NO;
            self.translation = translation;
        }];
    
    [RACObserve(self, translation) subscribeNext:^(STTranslation *translation) {
        @strongify(self);
        if (translation && ![translation isEmpty]) {
            self.sourceLanguage = translation.sourceLanguage;
            self.targetLanguage = translation.targetLanguage;
        } else {
            self.sourceLanguage = self.sourceLanguage;
            self.targetLanguage = self.targetLanguage;
        }
        self.sourceText = translation.inputText;
    }];
}

- (void)setSavedTranslation:(STTranslation *)translation {
    self.translation = translation;
    self.sourceText = translation.inputText;
    self.sourceLanguage = translation.sourceLanguage;
    self.targetLanguage = translation.targetLanguage;
}

- (void)allowTranslation {
    [self.allowTranslationSubject sendNext:@YES];
}

- (RACSignal *)errorFreeTranslationForText:(NSString *)text fromLanguage:(STLanguage *)source toLanguage:(STLanguage *)target {
    @weakify(self);
    return [[self.services.translationService translationForText:text fromLanguage:source toLanguage:target]
            catch:^RACSignal *(NSError *error) {
                @strongify(self);
                STTranslation *translation = [STTranslation emptyTranslation];
                translation.inputText = self.sourceText;
                translation.sourceLanguage = self.sourceLanguage;
                translation.targetLanguage = self.targetLanguage;
                return [RACSignal return:translation];
            }];
}
@end
