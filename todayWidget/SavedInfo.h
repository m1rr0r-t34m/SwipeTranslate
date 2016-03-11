//
//  SavedInfo.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguagesStorage.h"

@interface SavedInfo : NSUserDefaults

+(SavedInfo *)localDefaults;


-(BOOL)hasLanguages;
-(BOOL)hasChosenLanguages;
-(BOOL)hasDefaultText;
-(BOOL)hasAutoLanguage;
-(BOOL)hasUsedSidebar;


-(NSString *)inputText;
-(NSString *)outputText;
-(NSArray *)sourceLanguages;
-(NSArray *)targetLanguages;
-(NSString *)sourceSelection;
-(NSString *)targetSelection;
-(NSString *)autoLanguage;
-(BOOL)autoPushed;

-(void)setInputText:(NSString *)input;
-(void)setOutputText:(NSString *)output;
-(void)setSourceLanguages:(NSArray *)array;
-(void)setTargetLanguages:(NSArray *)array;
-(void)setSourceSelection:(NSString *)lang;
-(void)setTargetSelection:(NSString *)lang;
-(void)setAutoLanguage:(NSString *)lang;
-(void)setAutoPushed:(BOOL)value;
-(void)setUsedSidebar:(BOOL)value;

-(BOOL)isEmpty;

-(void)removeSidebarDefault;

@property NSUserDefaults *userDefaults;
@property NSString *type;
@end
