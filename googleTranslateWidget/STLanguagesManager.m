//
//  STLanguages.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLanguagesManager.h"
#import "STLanguage.h"
#import "SavedInfo.h"
#import <ReactiveCocoa.h>

static NSArray <STLanguage *> *cachedAllLanguages;

@implementation STLanguagesManager

//TODO: Auto language

+ (NSString *)languageForKey:(NSString *)key {
    NSInteger index = [LanguageKeys indexOfObject:key];
    return [Languages objectAtIndex:index];
}

+ (NSString *)keyForLanguage:(NSString *)language {
    NSInteger index = [Languages indexOfObject:language];
    return [LanguageKeys objectAtIndex:index];
}

+ (NSArray<STLanguage *> *)allLanguages {
    if (!cachedAllLanguages) {
        cachedAllLanguages = [[[LanguageKeys.rac_sequence zipWith:Languages.rac_sequence] map:^id(RACTuple *tuple) {
            return [[STLanguage alloc] initWithKey:[tuple first] andTitle:[tuple second]];
        }] array];
    }
    
    return cachedAllLanguages;
}

+ (NSArray<STLanguage *> *)sourceLanguages {
    return [self languagesForTitles:[SavedInfo sourceLanguages]];
}

+ (NSArray<STLanguage *> *)targetLanguages {
    return [self languagesForTitles:[SavedInfo targetLanguages]];
}

+ (NSArray<STLanguage *> *)languagesForTitles:(NSArray<NSString *> *)titles {
    @weakify(self);
    return [[titles.rac_sequence map:^id(NSString *title) {
        @strongify(self);
        return [self languageForTitle:title];
    }] array];
}

+ (STLanguage *)languageForTitle:(NSString *)title {
    NSUInteger index = [Languages indexOfObject:title];
    NSString *key = [LanguageKeys objectAtIndex:index];
    
    return [[STLanguage alloc] initWithKey:key andTitle:title];
}

+ (NSArray<STLanguage *> *)randomLanguagesExcluding:(NSArray <STLanguage *> *)excludingArray withCount:(NSUInteger)count {
    NSMutableSet <STLanguage *> *excludingSet = [NSMutableSet setWithArray:excludingArray];
    NSUInteger overallCount = excludingArray.count + count;
    
    while (excludingSet.count != overallCount) {
        [excludingSet addObject:[self randomLanguage]];
    }
    
    [excludingSet minusSet:[NSSet setWithArray:excludingArray]];
    
    return [excludingSet allObjects];
}

+ (STLanguage *)randomLanguage {
    uint32_t index = arc4random_uniform((uint32_t)[self allLanguages].count);
    return [[self allLanguages] objectAtIndex:index];
}

+ (STLanguage *)selectedSourceLanguage {
  return [self languageForTitle:[SavedInfo sourceSelection]];
}

+ (STLanguage *)selectedTargetLanguage {
  return [self languageForTitle:[SavedInfo targetSelection]];
}

@end
