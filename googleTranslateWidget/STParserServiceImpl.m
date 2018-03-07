//
//  STParserServiceImpl.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 19/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STParserServiceImpl.h"
#import <Cocoa/Cocoa.h>
#import <ReactiveObjC.h>
#import "STParserResult.h"
#import "STLanguage.h"
#import "STConstants.h"

@interface STParserServiceImpl()
@property (strong, nonatomic) id <STLanguagesService> languageService;
@end

@implementation STParserServiceImpl
- (instancetype)init {
    self = [super init];
    NSAssert(NO, @"Use designated initializer initWithParserService:");
    return self;
}

- (instancetype)initWithLanguageService:(id <STLanguagesService>)service {
    if (self = [super init]) {
        _languageService = service;
    }
    
    return self;
}

- (RACSignal *)translationForRawData:(NSDictionary *)rawData {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if (!rawData || rawData.count == 0 || !rawData[@"text"]) {
            [subscriber sendError:[self parserEmptyDataError]];
            return nil;
        }
        
        RACTuple *validation = [self errorValidationForRawData:rawData];
        RACTupleUnpack(NSNumber *success, NSNumber *code) = validation;
        
        if (!success.boolValue) {
            [subscriber sendError:[self parserValidationErrorWithOriginalCode:code.integerValue]];
            return nil;
        }
        
        STParserResult *result = [STParserResult new];
        result.type = STParsedResultTypeTranslation;
        
        NSString *translatedText = rawData[@"text"][0];
        NSString *detected = rawData[@"detected"][@"lang"];
        if (detected && detected.length) {
            result.detectedLanguage = [[STLanguage alloc] initWithKey:detected andTitle:[self.languageService languageForKey:detected]];
        }
        
        result.parsedResponse = @{kTranslatedText : [translatedText lowercaseString]};
        
        [subscriber sendNext:result];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)definitionForRawData:(NSDictionary *)rawData {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if (!rawData || rawData.count == 0 || [rawData[@"def"] count] == 0) {
            [subscriber sendError:[self parserEmptyDataError]];
            return nil;
        }
        
        RACTuple *validation = [self errorValidationForRawData:rawData];
        RACTupleUnpack(NSNumber *success, NSNumber *code) = validation;
        
        if (!success.boolValue) {
            [subscriber sendError:[self parserValidationErrorWithOriginalCode:code.integerValue]];
            return nil;
        }
        
        NSString *originalText;
        NSString *transcription;
        NSMutableDictionary *translationDict = [NSMutableDictionary new];
        NSMutableArray *translationKeys = [NSMutableArray new];
        
        for (NSDictionary *definition in rawData[@"def"]) {
            NSString *partOfSpeech = [definition[@"pos"] lowercaseString];
            
            if (definition[@"text"]) originalText = [definition[@"text"] lowercaseString];
            
            if (definition[@"ts"]) transcription = [definition[@"ts"] lowercaseString];
            
            NSMutableArray *restructuredTranslations = [NSMutableArray new];
            
            for (NSDictionary *translation in definition[@"tr"]) {
                NSMutableDictionary *restructuredTranslation = [NSMutableDictionary new];
                
                NSString *translatedText = [translation[@"text"] lowercaseString];
                if (translatedText) {
                    restructuredTranslation[kTranslatedText] = translatedText;
                }
                
                NSArray *synonimsStructure = translation[@"syn"];
                NSArray *translatedSynonims = [synonimsStructure.rac_sequence map:^id (NSDictionary *synonim) {
                    return [synonim[@"text"] lowercaseString];
                }].array;
                if (translatedSynonims) {
                    restructuredTranslation[kTranslatedSynonims] = translatedSynonims;
                }
                
                NSArray *meaningsStructure = translation[@"mean"];
                NSArray *meanings = [meaningsStructure.rac_sequence map:^id (NSDictionary *meaning) {
                    return [meaning[@"text"] lowercaseString];
                }].array;
                if (meanings) {
                    restructuredTranslation[kMeanings] = meanings;
                }
                
                NSArray *examplesStructure = translation[@"ex"];
                NSArray *examples = [examplesStructure.rac_sequence map:^id (NSDictionary *example) {
                    return [example[@"text"] lowercaseString];
                }].array;
                if (examples) {
                    restructuredTranslation[kExamples] = examples;
                }
                
                NSArray *translatedExamples = [examplesStructure.rac_sequence map:^id (NSDictionary *example) {
                    return [example[@"tr"][0][@"text"] lowercaseString];
                }].array;
                if (translatedExamples) {
                    restructuredTranslation[kTranslatedExamples] = translatedExamples;
                }
                
                [restructuredTranslations addObject:restructuredTranslation];
            }
            
            if (partOfSpeech) {
                [translationDict setObject:restructuredTranslations forKey:partOfSpeech];
                [translationKeys addObject:partOfSpeech];
            }
        }
        
        NSMutableDictionary *restructuredDict = [NSMutableDictionary new];
        if (transcription) {
            [restructuredDict setObject:transcription forKey:kTranscription];
        }
        [restructuredDict setObject:translationKeys forKey:kTranslationKeys];
        [restructuredDict setObject:translationDict forKey:kTranslationDict];
        
        STParserResult *result = [STParserResult new];
        result.type = STParsedResultTypeDictionary;
        result.parsedResponse = restructuredDict;
        [subscriber sendNext:result];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACTuple *)errorValidationForRawData:(NSDictionary *)rawData {
    BOOL success = NO;
    NSInteger code = [rawData[@"code"] integerValue];
    
    switch (code) {
        case 200:
            NSLog(@"STParser: Operation completed successfully.");
            success = YES;
            break;
        case 401:
            NSLog(@"STParser: Invalid API key.");
            break;
        case 402:
            NSLog(@"STParser: This API key has been blocked.");
            break;
        case 403:
            NSLog(@"STParser: You have reached the daily limit for requests (including calls of the translate method).");
            break;
        case 404:
            NSLog(@"STParser: You have reached the daily limit for the volume of translated text (including calls of the translate method).");
            break;
        default:
            success = YES;
            break;
    }
    
    return RACTuplePack(@(success), @(code));
}

//TODO: move to widget's ViewModel
- (NSAttributedString *)dictionaryOutputForWidgetWithDictionary:(NSDictionary *)receivedData {
    NSMutableAttributedString *outputText = [NSMutableAttributedString new];
    NSAttributedString *newLineString = [[NSAttributedString alloc] initWithString:@"\n"];
    
    NSColor *whiteColor = [NSColor whiteColor];
    NSFont *mainFont = [NSFont systemFontOfSize:12.0];
    NSDictionary *mainAttributes = @{NSFontAttributeName : mainFont, NSForegroundColorAttributeName : whiteColor};
    NSFont *firstTranslationFont = [NSFont systemFontOfSize:16.0];
    NSDictionary *firstTranslationAttributes = @{NSFontAttributeName : firstTranslationFont, NSForegroundColorAttributeName : whiteColor};
    
    NSString *transcription = receivedData[kTranscription];
    if ([transcription length]) {
        [outputText appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"[%@]",transcription] attributes:mainAttributes]];
        [outputText appendAttributedString:newLineString];
    }
    
    NSArray *translationKeys = receivedData[kTranslationKeys];
    NSDictionary *translationDict = receivedData[kTranslationDict];
    NSArray *translations = translationDict[translationKeys[0]];
    
    for (NSDictionary *translation in translations) {
        NSString *translatedText = [[NSString alloc] initWithString:translation[kTranslatedText]];
        if (translation == translations.firstObject) {
            [outputText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", translatedText] attributes:firstTranslationAttributes]];
        } else {
            [outputText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@", translatedText] attributes:mainAttributes]];
        }
        
        NSArray *synonims = translation[kTranslatedSynonims];
        for (NSString *synonim in synonims) {
            [outputText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@",synonim] attributes:mainAttributes]];
        }
    }

    
    return outputText;
}

- (NSError *)parserEmptyDataError {
    return [NSError errorWithDomain:STParserErrorDomain code:100 userInfo:@{STParserErrorType : @"Empty Data"}];
}

- (NSError *)parserValidationErrorWithOriginalCode:(NSInteger)originalCode {
    return [NSError errorWithDomain:STParserErrorDomain code:101 userInfo:@{STParserErrorType : @"Validation", STParserOriginalCode : @(originalCode)}];
}
@end
