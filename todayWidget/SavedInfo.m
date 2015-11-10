//
//  SavedInfo.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "SavedInfo.h"

@implementation SavedInfo
-(SavedInfo *)init {
    [self setSharedUserDefaults:[[NSUserDefaults alloc] initWithSuiteName:@"com.SwipeTranslateDesktop"]];
    return [super init];
}
-(BOOL)hasLanguages {
    if([ self.sharedUserDefaults objectForKey:@"sourceDefault"]&&[[self sharedUserDefaults]objectForKey:@"targetDefault"])
        return YES;
    return NO;
}

-(BOOL)hasChosenLanguages {
    if([[self sharedUserDefaults]objectForKey:@"sourceDefaultSelection"]&&[[self sharedUserDefaults] objectForKey:@"targetDefaultSelection"])
        return YES;
    return NO;
}
-(BOOL)hasDefaultText {
    if([[self sharedUserDefaults]objectForKey:@"defaultInput"]&&[[self sharedUserDefaults]objectForKey:@"defaultOutput"])
        return YES;
    return NO;
}
-(BOOL)hasAutoLanguage {
    if([[self sharedUserDefaults]objectForKey:@"autoLanguage"])
        return YES;
    return NO;
}

-(NSString *)inputText {
    return [[self sharedUserDefaults]stringForKey:@"defaultInput"];
}
-(NSString *)outputText {
     return [[self sharedUserDefaults]stringForKey:@"defaultOutput"];
}
-(NSArray *)sourceLanguages {
    return [[self sharedUserDefaults]arrayForKey:@"sourceDefault"];
}
-(NSArray *)targetLanguages {
    return [[self sharedUserDefaults]arrayForKey:@"targetDefault"];
}
-(NSInteger)sourceSelection {
    return [[self sharedUserDefaults] integerForKey:@"sourceDefaultSelection"];
}
-(NSInteger)targetSelection {
    return [[self sharedUserDefaults] integerForKey:@"targetDefaultSelection"];
}
-(NSString *)autoLanguage {
    return [[self sharedUserDefaults] stringForKey:@"autoLanguage"];
}



-(void)setInputText:(NSString *)input {
    [[self sharedUserDefaults]setObject:input forKey:@"defaultInput"];
    [[self sharedUserDefaults] synchronize];
}
-(void)setOutputText:(NSString *)output {
    [[self sharedUserDefaults]setObject:output forKey:@"defaultOutput"];
    [[self sharedUserDefaults] synchronize];
}
-(void)setSourceLanguages:(NSArray *)array {
    [[self sharedUserDefaults]setObject:array forKey:@"sourceDefault"];
    [[self sharedUserDefaults] synchronize];
}
-(void)setTargetLanguages:(NSArray *)array {
    [[self sharedUserDefaults]setObject:array forKey:@"targetDefault"];
    [[self sharedUserDefaults] synchronize];
}
-(void)setSourceSelection:(NSInteger)index {
    [[self sharedUserDefaults] setObject:[NSNumber numberWithInteger:index] forKey:@"sourceDefaultSelection"];
    [[self sharedUserDefaults] synchronize];
}
-(void)setTargetSelection:(NSInteger)index {
    [[self sharedUserDefaults] setObject:[NSNumber numberWithInteger:index] forKey:@"targetDefaultSelection"];
    [[self sharedUserDefaults] synchronize];
}
-(void)setAutoLanguage:(NSString *)lang {
    [[self sharedUserDefaults] setObject:lang forKey:@"autoLanguage"];
}



@end
