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
    return[[self alloc] initWithArray:@[@"auto",@"af", @"sq", @"ar", @"hy", @"az", @"eu", @"be", @"bn", @"bs", @"bg",
                                        @"ca", @"ceb", @"ny", @"zh-CN", @"zh-TW", @"hr", @"cs",
                                        @"da", @"nl", @"en", @"eo", @"et", @"tl", @"fi", @"fr",
                                        @"gl", @"ka", @"de",@"el", @"gu",
                                        @"ht", @"ha", @"iw",@"hi", @"hmn",@"hu", @"is",
                                        @"ig", @"id", @"ga", @"it", @"ja", @"jw", @"kn", @"kk", @"km", @"ko", @"lo",
                                        @"la", @"lv", @"lt", @"mk", @"mg", @"ms", @"ml", @"mt", @"mi", @"mr", @"mn",
                                        @"my", @"ne", @"no", @"fa", @"pl", @"pt", @"ma", @"ro", @"ru",
                                        @"sr", @"st", @"si", @"sk", @"sl", @"so", @"es", @"su", @"sw",
                                        @"sv", @"tg", @"ta", @"te", @"th", @"tr", @"uk", @"ur", @"uz",
                                        @"vi", @"cy", @"yi", @"yo", @"zu"]];
}
+(NSArray *)getValuesArray:(BOOL)full {
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:@[@"Afrikaans", @"Albanian", @"Arabic", @"Armenian", @"Azerbaijani",
                                                    @"Basque", @"Belarusian", @"Bengali", @"Bosnian", @"Bulgarian",
                                                    @"Catalan", @"Cebuano", @"Chichewa", @"Chinese Simplified", @"Chinese Traditional",
                                                    @"Croatian", @"Czech", @"Danish", @"Dutch", @"English",
                                                    @"Esperanto", @"Estonian", @"Filipino", @"Finnish", @"French", @"Galician",
                                                    @"Georgian", @"German", @"Greek", @"Gujarati", @"Haitian Creole",
                                                    @"Hausa", @"Hebrew", @"Hindi", @"Hmong", @"Hungarian",
                                                    @"Icelandic", @"Igbo", @"Indonesian", @"Irish", @"Italian",
                                                    @"Japanese", @"Javanese", @"Kannada", @"Kazakh", @"Khmer",
                                                    @"Korean", @"Lao", @"Latin", @"Latvian", @"Lithuanian",
                                                    @"Macedonian", @"Malagasy", @"Malay", @"Malayalam", @"Maltese",
                                                    @"Maori", @"Marathi", @"Mongolian", @"Myanmar", @"Nepale",
                                                    @"Norwegian", @"Persian", @"Polish", @"Portuguese", @"Punjabi", @"Romanian",
                                                    @"Russian", @"Serbian", @"Sesotho", @"Sinhala", @"Slovak",
                                                    @"Slovenian", @"Somali", @"Spanish", @"Sudanese", @"Swahili",
                                                    @"Swedish", @"Tajik", @"Tamil", @"Telugu", @"Thai", @"Turkish",
                                                    @"Ukrainian", @"Urdu", @"Uzbek", @"Vietnamese", @"Welsh",
                                                    @"Yiddish", @"Yoruba", @"Zulu"]];
    if(full)
        [array insertObject:@"Auto" atIndex:0];

     return[[NSArray alloc]initWithArray:array];
}
-(NSArray *)getArrayOfLanguagesWithLetter:(NSString *)letter {
    NSMutableArray *newArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[self count];i++){
        if([[[self objectAtIndex:i] substringWithRange:NSMakeRange(0, 1)] isEqualToString: letter])
            [newArray addObject:[self objectAtIndex:i]];
    }
    return [[NSArray alloc] initWithArray:newArray];
}
@end
