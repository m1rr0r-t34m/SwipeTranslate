//
//  STTranslation.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 21/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STLanguage;
@class STParserResult;

typedef enum : NSUInteger {
    STTranslationTypeNormal,
    STTranslationTypeAuto
} STTranslationType;

@interface STTranslation : NSObject <NSCoding>
@property (assign, nonatomic) STTranslationType type;
@property (strong, nonatomic) NSString *inputText;
@property (strong, nonatomic) STParserResult *parserResult;
@property (strong, nonatomic) STLanguage *sourceLanguage;
@property (strong, nonatomic) STLanguage *targetLanguage;
@property (strong, nonatomic) STLanguage *detectedLanguage;
+ (instancetype)emptyTranslation;
- (BOOL)isEmpty;
@end
