//
//  STLanguagesServiceImpl.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STLanguagesServiceImpl.h"
#import "STLanguage.h"
#import <ReactiveObjC.h>

#define Alphabet @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"P", @"R", @"S", @"T", @"U", @"V", @"W", @"Y"]
#define LanguageKeys @[@"auto",@"sq",@"en",@"ar",@"hy",@"az",@"af",@"eu",@"be",@"bg",@"bs",@"cy",@"vi",@"hu",@"ht",@"gl",@"nl",@"el",@"ka",@"da",@"he",@"id",@"ga",@"it",@"is",@"es",@"kk",@"ca",@"ky",@"zh",@"ko",@"la",@"lv",@"lt",@"mg",@"ms",@"mt",@"mk",@"mn",@"de",@"no",@"fa",@"pl",@"pt",@"ro",@"ru",@"sr",@"sk",@"sl",@"sw",@"tg",@"th",@"tl",@"tt",@"tr",@"uz",@"uk",@"fi",@"fr",@"hr",@"cs",@"sv",@"et",@"ja"]
#define Languages @[@"Auto",@"Albanian",@"English",@"Arabic",@"Armenian",@"Azerbaijan",@"Afrikaans",@"Basque",@"Belarusian",@"Bulgarian",@"Bosnian",@"Welsh",@"Vietnamese",@"Hungarian",@"Haitian",@"Galician",@"Dutch",@"Greek",@"Georgian",@"Danish",@"Yiddish",@"Indonesian",@"Irish",@"Italian",@"Icelandic",@"Spanish",@"Kazakh",@"Catalan",@"Kyrgyz",@"Chinese",@"Korean",@"Latin",@"Latvian",@"Lithuanian",@"Malagasy",@"Malay",@"Maltese",@"Macedonian",@"Mongolian",@"German",@"Norwegian",@"Persian",@"Polish",@"Portuguese",@"Romanian",@"Russian",@"Serbian",@"Slovakian",@"Slovenian",@"Swahili",@"Tajik",@"Thai",@"Tagalog",@"Tatar",@"Turkish",@"Uzbek",@"Ukrainian",@"Finnish",@"French",@"Croatian",@"Czech",@"Swedish",@"Estonian",@"Japanese"]

#define FavouriteLanguagesCount 10
#define AutoLanguageKey @"auto"
#define AutoLanguageTitle @"Auto"

static NSArray <STLanguage *> *cachedAllLanguages;

@implementation STLanguagesServiceImpl
- (NSArray *)alphabet {
    return Alphabet;
}

- (NSString *)languageForKey:(NSString *)key {
    NSInteger index = [LanguageKeys indexOfObject:key];
    return [Languages objectAtIndex:index];
}

- (NSString *)keyForLanguage:(NSString *)language {
    NSInteger index = [Languages indexOfObject:language];
    return [LanguageKeys objectAtIndex:index];
}

- (NSArray<STLanguage *> *)allLanguages {
    if (!cachedAllLanguages) {
        cachedAllLanguages = [[[LanguageKeys.rac_sequence zipWith:Languages.rac_sequence] map:^id(RACTuple *tuple) {
            return [[STLanguage alloc] initWithKey:[tuple first] andTitle:[tuple second]];
        }] array];
    }
    
    return cachedAllLanguages;
}

- (NSArray<STLanguage *> *)languagesForTitles:(NSArray<NSString *> *)titles {
    @weakify(self);
    return [[titles.rac_sequence map:^id(NSString *title) {
        @strongify(self);
        return [self languageForTitle:title];
    }] array];
}

- (STLanguage *)languageForTitle:(NSString *)title {
    NSUInteger index = [Languages indexOfObject:title];
    NSString *key = [LanguageKeys objectAtIndex:index];
    
    return [[STLanguage alloc] initWithKey:key andTitle:title];
}

- (NSArray<STLanguage *> *)randomLanguagesExcluding:(NSArray <STLanguage *> *)excludingArray withCount:(NSUInteger)count {
    NSMutableSet <STLanguage *> *excludingSet = [NSMutableSet setWithArray:excludingArray];
    [excludingSet addObject:[self autoLanguage]];
    NSUInteger overallCount = excludingArray.count + count;
    
    while (excludingSet.count != overallCount) {
        [excludingSet addObject:[self randomLanguage]];
    }
    
    [excludingSet minusSet:[NSSet setWithArray:excludingArray]];
    
    return [excludingSet allObjects];
}

- (STLanguage *)randomLanguage {
    uint32_t index = arc4random_uniform((uint32_t)[self allLanguages].count);
    return [[self allLanguages] objectAtIndex:index];
}

- (STLanguage *)autoLanguage {
    return [[STLanguage alloc] initWithKey:AutoLanguageKey andTitle:AutoLanguageTitle];
}

- (NSArray<STLanguage *> *)languagesForLetter:(NSString *)letter {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *language, NSDictionary<NSString *,id> *bindings) {
        return [[language substringToIndex:1] isEqualToString:letter];
    }];
    NSArray *languageTitles = [Languages filteredArrayUsingPredicate:predicate];
    NSMutableArray *languages = [NSMutableArray new];
    for (NSString *title in languageTitles) {
        NSString *key = [self keyForLanguage:title];
        STLanguage *language = [[STLanguage alloc] initWithKey:key andTitle:title];
        [languages addObject:language];
    }
    return [languages copy];
}
@end
