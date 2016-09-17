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

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation STMainViewControllerModel

- (instancetype)init {
    if(self = [super init]) {
        [self setupBindings];
    }
    return self;
}

- (void) setupBindings {
    
    [self rac_liftSelector:@selector(performTranslationFor:from:to:)
               withSignals:[RACObserve(self, sourceText) ignore:nil],
                           [RACObserve(self, sourceLanguage) ignore:nil],
                           [RACObserve(self, targetLanguage) ignore:nil], nil];
    
    //RACObserve([STTranslationManager manager], result)
    
}
- (void) performTranslationFor:(NSString *)text from:(NSString *)source to:(NSString *)target {

    [[STTranslationManager manager] getTranslationForString:text SourceLanguage:[STLanguages keyForLanguage:source] AndTargetLanguage:[STLanguages keyForLanguage:target]];
}

@end
