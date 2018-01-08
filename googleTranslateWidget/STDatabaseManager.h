//
//  STDatabaseManager.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 08/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STLanguage;

@interface STDatabaseManager : NSObject
#pragma mark - Initialization
+ (instancetype)sharedInstance;
#pragma mark - Select
- (NSArray <STLanguage *> *)sourceLanguages;
- (NSArray <STLanguage *> *)targetLanguages;
- (STLanguage *)sourceSelectedLanguage;
- (STLanguage *)targetSelectedLanguage;
#pragma mark - Insert
- (void)saveSourceLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveTargetLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveSourceSelected:(STLanguage *)language;
- (void)saveTargetSelected:(STLanguage *)language;
@end
