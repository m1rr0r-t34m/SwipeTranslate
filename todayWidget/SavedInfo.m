//
//  SavedInfo.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "SavedInfo.h"

@implementation SavedInfo
//+(SavedInfo *)localDefaults {
//    SavedInfo *instance=[super new];
//    
//    //[instance setUserDefaults:[NSUserDefaults standardUserDefaults]];
//    //[instance setType:@"local"];
//    if([instance isEmpty])
//        [instance createInitialDefaults];
//    return instance;
//}

+(void)createInitialDefaults {

        [self setInputText:@""];
        [self setOutputText:@""];
        [self setSourceLanguages:@[@"English",@"French",@"Spanish",@"Russian",@"Finnish"]];
        [self setTargetLanguages:@[@"French",@"Russian",@"English",@"Finnish",@"Spanish"]];
        [self setSourceSelection:@"English"];
        [self setTargetSelection:@"French"];
        [self setAutoLanguage:nil];

    
}

+(BOOL)isEmpty {
    
    if(![self hasLanguages]) {
        return YES;
    }
    else {
        for(int i=0;i<[[self targetLanguages] count];i++){
            if(![[NSArray getValuesArray:NO] containsObject:[self targetLanguages][i]])
                return YES;
        }
        for(int i=0;i<[[self sourceLanguages] count];i++){
            if(![[NSArray getValuesArray:NO] containsObject:[self sourceLanguages][i]])
                return YES;
        }
    }
    
    if(![self hasChosenLanguages]) {
        return YES;
    }
    else {
        for(int i=0;i<[[self sourceLanguages] count];i++){
            if(![[NSArray getValuesArray:NO] containsObject:[self sourceSelection]])
                return YES;
        }
        for(int i=0;i<[[self targetLanguages] count];i++){
            if(![[NSArray getValuesArray:NO] containsObject:[self targetSelection]])
                return YES;
        }
    }

    return NO;
}

+(BOOL)hasLanguages {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"sourceDefault"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"targetDefault"])
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sourceDefault"] count]==5&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"targetDefault"] count]==5)
            return YES;
        else
            return NO;
    }
    
    return NO;
}

+(BOOL)hasUsedSidebar {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sidebarUsage"])
        return true;
    else
        return false;
}


+(BOOL)hasChosenLanguages {
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"sourceDefaultSelection"]&&[[NSUserDefaults standardUserDefaults] objectForKey:@"targetDefaultSelection"]&&![[NSScanner scannerWithString:[[NSUserDefaults standardUserDefaults]stringForKey:@"sourceDefaultSelection"]]scanInt:nil]&&![[NSScanner scannerWithString:[[NSUserDefaults standardUserDefaults]stringForKey:@"targetDefaultSelection"]]scanInt:nil])
        return YES;
    return NO;
}
+(BOOL)hasDefaultText {
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"defaultInput"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"defaultOutput"])
        return YES;
    return NO;
}
+(BOOL)hasAutoLanguage {
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"autoLanguage"])
        return YES;
    return NO;
}

+(NSString *)inputText {
    return [[NSUserDefaults standardUserDefaults]stringForKey:@"defaultInput"];
}
+(NSString *)outputText {
     return [[NSUserDefaults standardUserDefaults]stringForKey:@"defaultOutput"];
}
+(NSArray *)sourceLanguages {
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"sourceDefault"];
}
+(NSArray *)targetLanguages {
    return [[NSUserDefaults standardUserDefaults]arrayForKey:@"targetDefault"];
}
+(NSString *)sourceSelection {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sourceDefaultSelection"];
}
+(NSString *)targetSelection {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"targetDefaultSelection"];
}
+(NSString *)autoLanguage {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"autoLanguage"];
}
+(BOOL)autoPushed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"autoPushed"];
}


+(void)setInputText:(NSString *)input {
    [[NSUserDefaults standardUserDefaults]setObject:input forKey:@"defaultInput"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setOutputText:(NSString *)output {
    [[NSUserDefaults standardUserDefaults]setObject:output forKey:@"defaultOutput"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setSourceLanguages:(NSArray *)array {
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"sourceDefault"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setTargetLanguages:(NSArray *)array {
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"targetDefault"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setSourceSelection:(NSString *)lang {
    [[NSUserDefaults standardUserDefaults] setObject:lang forKey:@"sourceDefaultSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setTargetSelection:(NSString *)lang {
    [[NSUserDefaults standardUserDefaults] setObject:lang forKey:@"targetDefaultSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setAutoLanguage:(NSString *)lang {
    [[NSUserDefaults standardUserDefaults] setObject:lang forKey:@"autoLanguage"];
}
+(void)setAutoPushed:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"autoPushed"];
}

+(void)setUsedSidebar:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"sidebarUsage"];
}

+(void)removeSidebarDefault {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sidebarUsage"];
}

@end
