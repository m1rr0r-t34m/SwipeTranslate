//
//  LeftSplitViewModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLeftSplitViewModel.h"
#import "STLanguages.h"
#import "SavedInfo.h"

@implementation STLeftSplitViewModel

- (instancetype)init {
    if(self = [super init]) {
        [self getLanguagesFromUserDefaults];
    }
    return self;
}

- (void) getLanguagesFromUserDefaults {
    
    NSMutableArray *sourceLanguages = [NSMutableArray arrayWithArray:[SavedInfo sourceLanguages]];
    
    if(sourceLanguages.count < 7) {
        NSMutableSet *savedLanguages= [[NSMutableSet alloc] initWithArray:sourceLanguages];
        NSMutableSet *allLanguages= [[NSMutableSet alloc] initWithArray:Languages];
        [allLanguages minusSet:savedLanguages];
        
        NSArray *notSavedLanguages = [allLanguages allObjects];
        
        [sourceLanguages addObject:notSavedLanguages[0]];
        [sourceLanguages addObject:notSavedLanguages[1]];
        
        [SavedInfo setSourceLanguages:sourceLanguages];
    }
    
   
    NSMutableArray *targetLanguages = [NSMutableArray arrayWithArray:[SavedInfo sourceLanguages]];
    
    if(targetLanguages.count < 7) {
        NSMutableSet *savedLanguages= [[NSMutableSet alloc] initWithArray:targetLanguages];
        NSMutableSet *allLanguages= [[NSMutableSet alloc] initWithArray:Languages];
        [allLanguages minusSet:savedLanguages];
        
        NSArray *notSavedLanguages = [allLanguages allObjects];
        
        [targetLanguages addObject:notSavedLanguages[0]];
        [targetLanguages addObject:notSavedLanguages[1]];
        
        [SavedInfo setTargetLanguages:targetLanguages];
    }
    
    
    self.sourceLanguages = sourceLanguages;
    self.targetLanguages = targetLanguages;
}

- (void)setSourceSelected:(NSInteger)index {
    NSString *language = [self sourceLanguages][index];
    NSString *key = [STLanguages keyForLanguage:language];
    
    self.sourceSelectedLanguage = language;
    self.sourceSelectedLanguageKey = key;
}

- (void)setTargetSelected:(NSInteger)index {
    NSString *language = [self targetLanguages][index];
    NSString *key = [STLanguages keyForLanguage:language];
    
    self.targetSelectedLanguage = language;
    self.targetSelectedLanguageKey = key;
}

@end
