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

@interface STMainViewModel()
//@property (strong, nonatomic) id <STServices> services;
@end

@implementation STMainViewModel
- (instancetype)init {
    NSAssert(NO, @"Use designated initializer initWithServices:");
    self = [super init];
    return self;
}

- (instancetype)initWithServices:(id <STServices>)services {
    if (self = [super init]) {
        _services = services;
        [self setupBindings];
    }
    return self;
}

- (void)setupBindings {
    RACSignal *textSignal = [RACObserve(self, sourceText) ignore:nil];
    RACSignal *sourceLanguageSignal = [RACObserve(self, sourceLanguage) ignore:nil];
    RACSignal *targetLanguageSignal = [RACObserve(self, targetLanguage) ignore:nil];
    
    @weakify(self);
    [[[[RACSignal combineLatest:@[textSignal, sourceLanguageSignal, targetLanguageSignal]]
        map:^RACSignal *(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSString *text, STLanguage *source, STLanguage *target) = tuple;
            return [self.services.translationService translationForText:text fromLanguage:source toLanguage:target];
        }]
        switchToLatest]
        subscribeNext:^(STTranslation *translation) {
            @strongify(self);
            self.translation = translation;
        }];
}
@end
