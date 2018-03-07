//
//  STDatabaseService.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 19/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLanguagesService.h"

@class STLanguage;
@class STTranslation;

static NSUInteger defaultLanguagesCount = 10;

@protocol STDatabaseService <NSObject>
- (instancetype)initWithLanguagesService:(id <STLanguagesService>)service;
#pragma mark - Select
- (NSArray <STLanguage *> *)sourceLanguages;
- (NSArray <STLanguage *> *)targetLanguages;
- (STLanguage *)sourceSelectedLanguage;
- (STLanguage *)targetSelectedLanguage;
- (NSArray <STTranslation *> *)favouriteTranslations;
#pragma mark - Insert / Remove
- (void)saveSourceLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveTargetLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveSourceSelected:(STLanguage *)language;
- (void)saveTargetSelected:(STLanguage *)language;
- (void)saveFavouriteTranslation:(STTranslation *)translation;
@end
