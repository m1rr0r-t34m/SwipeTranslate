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
@end

@implementation STMainViewModel
#pragma mark - Initializations
- (instancetype)init {
    if (self = [super init]) {
        _services = [STServicesImpl new];
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
    [[[[[[RACSignal combineLatest:@[textSignal, sourceLanguageSignal, targetLanguageSignal]] throttle:0.1] filter:^BOOL(RACTuple *tuple) {
            RACTupleUnpack(NSString *text, STLanguage *source, STLanguage *target) = tuple;
            return ![self.translation.inputText isEqualToString:text] || ![self.translation.sourceLanguage isEqual:source] || ![self.translation.targetLanguage isEqual:target];
        }]
        map:^RACSignal *(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSString *text, STLanguage *source, STLanguage *target) = tuple;
            self.translating = YES;
            return [self.services.translationService translationForText:text fromLanguage:source toLanguage:target];
        }]
        switchToLatest]
        subscribeNext:^(STTranslation *translation) {
            @strongify(self);
            self.translating = NO;
            self.translation = translation;
        }];
    
    [RACObserve(self, translation) subscribeNext:^(STTranslation *translation) {
        @strongify(self);
        if (translation) {
            self.sourceText = translation.inputText;
            self.sourceLanguage = translation.sourceLanguage;
            self.targetLanguage = translation.targetLanguage;
        }
    }];
}
@end
