//
//  SavedInfo.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "SavedInfo.h"

@implementation SavedInfo
+(BOOL)hasLanguages {
    if([[self standardUserDefaults]objectForKey:@"sourceDefault"]&&[[self standardUserDefaults]objectForKey:@"targetDefault"])
        return YES;
    return NO;
}

+(BOOL)hasChosenLanguages {
    if([[self standardUserDefaults]objectForKey:@"sourceDefaultSelection"]&&[[self standardUserDefaults] objectForKey:@"targetDefaultSelection"])
        return YES;
    return NO;
}
+(BOOL)hasDefaultText {
    if([[self standardUserDefaults]objectForKey:@"defaultInput"]&&[[self standardUserDefaults]objectForKey:@"defaultOutput"])
        return YES;
    return NO;
}
+(BOOL)hasAutoLanguage {
    if([[self standardUserDefaults]objectForKey:@"autoLanguage"])
        return YES;
    return NO;
}

+(NSString *)inputText {
    return [[self standardUserDefaults]stringForKey:@"defaultInput"];
}
+(NSString *)outputText {
     return [[self standardUserDefaults]stringForKey:@"defaultOutput"];
}
+(NSArray *)sourceLanguages {
    return [[self standardUserDefaults]arrayForKey:@"sourceDefault"];
}
+(NSArray *)targetLanguages {
    return [[self standardUserDefaults]arrayForKey:@"targetDefault"];
}
+(NSInteger)sourceSelection {
    return [[self standardUserDefaults] integerForKey:@"sourceDefaultSelection"];
}
+(NSInteger)targetSelection {
    return [[self standardUserDefaults] integerForKey:@"targetDefaultSelection"];
}
+(NSString *)autoLanguage {
    return [[self standardUserDefaults] stringForKey:@"autoLanguage"];
}



+(void)setInputText:(NSString *)input {
    [[self standardUserDefaults]setObject:input forKey:@"defaultInput"];
    [[self standardUserDefaults] synchronize];
}
+(void)setOutputText:(NSString *)output {
    [[self standardUserDefaults]setObject:output forKey:@"defaultOutput"];
    [[self standardUserDefaults] synchronize];
}
+(void)setSourceLanguages:(NSArray *)array {
    [[self standardUserDefaults]setObject:array forKey:@"sourceDefault"];
    [[self standardUserDefaults] synchronize];
}
+(void)setTargetLanguages:(NSArray *)array {
    [[self standardUserDefaults]setObject:array forKey:@"targetDefault"];
    [[self standardUserDefaults] synchronize];
}
+(void)setSourceSelection:(NSInteger)index {
    [[self standardUserDefaults] setObject:[NSNumber numberWithInteger:index] forKey:@"sourceDefaultSelection"];
    [[self standardUserDefaults] synchronize];
}
+(void)setTargetSelection:(NSInteger)index {
    [[self standardUserDefaults] setObject:[NSNumber numberWithInteger:index] forKey:@"targetDefaultSelection"];
    [[self standardUserDefaults] synchronize];
}
+(void)setAutoLanguage:(NSString *)lang {
    [[self standardUserDefaults] setObject:lang forKey:@"autoLanguage"];
}



@end
