//
//  LanguagesStorage.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 21/09/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "LanguagesStorage.h"

@implementation NSArray (LanguagesStorage)
+(NSArray *)getAlphabetArray {
    return[[self alloc] initWithArray:@[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"P", @"R", @"S", @"T", @"U", @"V", @"W", @"Y", @"Z"]];
}
+(NSArray *)getKeysArray {
    return[[self alloc] initWithArray:@[@"auto",@"sq",@"en",@"ar",@"hy",@"az",@"af",@"eu",@"be",@"bg",@"bs",@"cy",@"vi",@"hu",@"ht",@"gl",@"nl",@"el",@"ka",@"da",@"he",@"id",@"ga",@"it",@"is",@"es",@"kk",@"ca",@"ky",@"zh",@"ko",@"la",@"lv",@"lt",@"mg",@"ms",@"mt",@"mk",@"mn",@"de",@"no",@"fa",@"pl",@"pt",@"ro",@"ru",@"sr",@"sk",@"sl",@"sw",@"tg",@"th",@"tl",@"tt",@"tr",@"uz",@"uk",@"fi",@"fr",@"hr",@"cs",@"sv",@"et",@"ja"]];
}
+(NSArray *)getValuesArray:(BOOL)full {
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:@[@"Albanian",@"English",@"Arabic",@"Armenian",@"Azerbaijan",@"Afrikaans",@"Basque",@"Belarusian",@"Bulgarian",@"Bosnian",@"Welsh",@"Vietnamese",@"Hungarian",@"Haitian",@"Galician",@"Dutch",@"Greek",@"Georgian",@"Danish",@"Yiddish",@"Indonesian",@"Irish",@"Italian",@"Icelandic",@"Spanish",@"Kazakh",@"Catalan",@"Kyrgyz",@"Chinese",@"Korean",@"Latin",@"Latvian",@"Lithuanian",@"Malagasy",@"Malay",@"Maltese",@"Macedonian",@"Mongolian",@"German",@"Norwegian",@"Persian",@"Polish",@"Portuguese",@"Romanian",@"Russian",@"Serbian",@"Slovakian",@"Slovenian",@"Swahili",@"Tajik",@"Thai",@"Tagalog",@"Tatar",@"Turkish",@"Uzbek",@"Ukrainian",@"Finnish",@"French",@"Croatian",@"Czech",@"Swedish",@"Estonian",@"Japanese"]];
    if(full)
        [array insertObject:@"Auto" atIndex:0];

    return [array copy];
}
-(NSArray *)getArrayOfLanguagesWithLetter:(NSString *)letter {
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for(int i=0;i<[self count];i++){
        if([[[self objectAtIndex:i] substringWithRange:NSMakeRange(0, 1)] isEqualToString: letter])
            [array addObject:[self objectAtIndex:i]];
    }
    return [array copy];
}
@end
