//
//  STLanguages.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLanguages.h"

@implementation STLanguages

//TODO: Auto language

+ (NSString *)languageForKey:(NSString *)key {
    NSInteger index = [LanguageKeys indexOfObject:key];
    return [Languages objectAtIndex:index];
}

+ (NSString *)keyForLanguage:(NSString *)language {
    NSInteger index = [Languages indexOfObject:language];
    return [LanguageKeys objectAtIndex:index];
}

@end
