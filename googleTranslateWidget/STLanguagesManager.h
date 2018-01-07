//
//  STLanguages.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STLanguage;

#define Alphabet @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"P", @"R", @"S", @"T", @"U", @"V", @"W", @"Y"]
#define LanguageKeys @[@"auto",@"sq",@"en",@"ar",@"hy",@"az",@"af",@"eu",@"be",@"bg",@"bs",@"cy",@"vi",@"hu",@"ht",@"gl",@"nl",@"el",@"ka",@"da",@"he",@"id",@"ga",@"it",@"is",@"es",@"kk",@"ca",@"ky",@"zh",@"ko",@"la",@"lv",@"lt",@"mg",@"ms",@"mt",@"mk",@"mn",@"de",@"no",@"fa",@"pl",@"pt",@"ro",@"ru",@"sr",@"sk",@"sl",@"sw",@"tg",@"th",@"tl",@"tt",@"tr",@"uz",@"uk",@"fi",@"fr",@"hr",@"cs",@"sv",@"et",@"ja"]
#define Languages @[@"Auto",@"Albanian",@"English",@"Arabic",@"Armenian",@"Azerbaijan",@"Afrikaans",@"Basque",@"Belarusian",@"Bulgarian",@"Bosnian",@"Welsh",@"Vietnamese",@"Hungarian",@"Haitian",@"Galician",@"Dutch",@"Greek",@"Georgian",@"Danish",@"Yiddish",@"Indonesian",@"Irish",@"Italian",@"Icelandic",@"Spanish",@"Kazakh",@"Catalan",@"Kyrgyz",@"Chinese",@"Korean",@"Latin",@"Latvian",@"Lithuanian",@"Malagasy",@"Malay",@"Maltese",@"Macedonian",@"Mongolian",@"German",@"Norwegian",@"Persian",@"Polish",@"Portuguese",@"Romanian",@"Russian",@"Serbian",@"Slovakian",@"Slovenian",@"Swahili",@"Tajik",@"Thai",@"Tagalog",@"Tatar",@"Turkish",@"Uzbek",@"Ukrainian",@"Finnish",@"French",@"Croatian",@"Czech",@"Swedish",@"Estonian",@"Japanese"]

#define FavouriteLanguagesCount 10

#define AutoLanguageKey @"auto"
#define AutoLanguageTitle @"Auto"

@interface STLanguagesManager : NSObject

+ (NSArray <STLanguage *> *)sourceLanguages;
+ (NSArray <STLanguage *> *)targetLanguages;
+ (NSArray <STLanguage *> *)allLanguages;
+ (NSArray<STLanguage *> *)randomLanguagesExcluding:(NSArray <STLanguage *> *)excludingArray withCount:(NSUInteger)count;
+ (STLanguage *)selectedSourceLanguage;
+ (STLanguage *)selectedTargetLanguage;
+ (STLanguage *)autoLanguage;
+ (NSString *)keyForLanguage:(NSString *)language;
+ (NSString *)languageForKey:(NSString *)key;
+ (NSArray<STLanguage *> *)languagesForLetter:(NSString *)letter;
@end
