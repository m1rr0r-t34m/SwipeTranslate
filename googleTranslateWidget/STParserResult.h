//
//  STParserResult.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 23/02/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STLanguage;

typedef enum : NSUInteger {
    STParsedResultTypeTranslation,
    STParsedResultTypeDictionary,
} STParsedResultType;

static NSString *kOriginalText = @"text";
static NSString *kTranscription = @"transcription";
static NSString *kTranslationKeys = @"translationKeys";
static NSString *kTranslationDict = @"translationDict";
static NSString *kTranslatedText = @"translatedText";
static NSString *kTranslatedSynonims = @"translatedSynonims";
static NSString *kMeanings = @"meanings";
static NSString *kExamples = @"examples";
static NSString *kTranslatedExamples = @"translatedExamples";

@interface STParserResult : NSObject
@property (assign, nonatomic) STParsedResultType type;
@property (strong, nonatomic) NSDictionary *parsedResponse;
@property (strong, nonatomic) STLanguage *detectedLanguage;
@end
