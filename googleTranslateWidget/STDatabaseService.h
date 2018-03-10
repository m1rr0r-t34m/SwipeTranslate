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

static NSUInteger languagesCount = 10;
static NSUInteger widgetSourceLanguagesCount = 2;
static NSUInteger widgetTargetLanguagesCount = 3;

@protocol STDatabaseService <NSObject>
- (instancetype)initWithLanguagesService:(id <STLanguagesService>)service;
#pragma mark - Select
- (NSArray <STLanguage *> *)sourceLanguages;
- (NSArray <STLanguage *> *)targetLanguages;
- (STLanguage *)sourceSelectedLanguage;
- (STLanguage *)targetSelectedLanguage;
- (NSArray <STTranslation *> *)favouriteTranslations;
- (NSNumber *)hasUsedFavouriteBar;
- (NSArray <STLanguage *> *)widgetSourceLanguages;
- (NSArray <STLanguage *> *)widgetTargetLanguages;
- (STLanguage *)widgetSourceSelectedLanguage;
- (STLanguage *)widgetTargetSelectedLanguage;
- (STTranslation *)widgetLastTranslation;
#pragma mark - Insert / Remove
- (void)saveSourceLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveTargetLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveSourceSelected:(STLanguage *)language;
- (void)saveTargetSelected:(STLanguage *)language;
- (void)saveFavouriteTranslation:(STTranslation *)translation;
- (void)removeFavouriteTranslation:(STTranslation *)translation;
- (void)saveHasUsedFavouriteBar:(NSNumber *)used;
- (void)saveWidgetSourceLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveWidgetTargetLanguages:(NSArray <STLanguage *> *)languages;
- (void)saveWidgetSourceSelected:(STLanguage *)language;
- (void)saveWidgetTargetSelected:(STLanguage *)language;
- (void)saveWidgetLastTranslation:(STTranslation *)translation;
@end
