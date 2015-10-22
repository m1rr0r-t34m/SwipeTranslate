//
//  SavedInfo.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedInfo : NSUserDefaults
+(BOOL)hasLanguages;
+(BOOL)hasChosenLanguages;
+(BOOL)hasDefaultText;
+(BOOL)hasAutoLanguage;


+(NSString *)inputText;
+(NSString *)outputText;
+(NSArray *)sourceLanguages;
+(NSArray *)targetLanguages;
+(NSInteger)sourceSelection;
+(NSInteger)targetSelection;
+(NSString *)autoLanguage;

+(void)setInputText:(NSString *)input;
+(void)setOutputText:(NSString *)output;
+(void)setSourceLanguages:(NSArray *)array;
+(void)setTargetLanguages:(NSArray *)array;
+(void)setSourceSelection:(NSInteger)index;
+(void)setTargetSelection:(NSInteger)index;
+(void)setAutoLanguage:(NSString *)lang;
@end
