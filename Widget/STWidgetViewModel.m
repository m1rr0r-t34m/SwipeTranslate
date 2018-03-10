//
//  STWidgetViewModel.m
//  Widget
//
//  Created by Mark Vasiv on 10/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STWidgetViewModel.h"
#import "STServicesImpl.h"
#import <ReactiveObjC.h>
#import "STLanguage.h"
#import "STTranslation.h"
#import "STParserResult.h"


@interface STWidgetViewModel()
@property (readwrite, strong, nonatomic) NSArray <STLanguage *> *sourceLanguages;
@property (readwrite, strong, nonatomic) NSArray <STLanguage *> *targetLanguages;
@property (readwrite, assign, nonatomic) NSInteger sourceSelectedIndex;
@property (readwrite, assign, nonatomic) NSInteger targetSelectedIndex;
@property (readwrite, strong, nonatomic) NSString *inputText;
@property (readwrite, strong, nonatomic) NSAttributedString *outputText;
@property (readwrite, strong, nonatomic) STLanguage *detectedLanguage;

@property (strong, nonatomic) STLanguage *sourceLanguage;
@property (strong, nonatomic) STLanguage *targetLanguage;

@property (strong, nonatomic) id <STServices> services;
@property (strong, nonatomic) STTranslation *translation;
@property (strong, nonatomic) RACSubject *allowTranslation;
@end

@implementation STWidgetViewModel
#pragma mark - Initialization
- (instancetype)init {
    if (self = [super init]) {
        _services = [STServicesImpl new];
        _allowTranslation = [RACSubject new];
        [self loadInitialData];
        [self bindSignals];
    }
    
    return self;
}

- (id <STLanguagesService>)languagesService {
    return self.services.languagesService;
}

#pragma mark - Setup
- (void)loadInitialData {
    self.sourceLanguages = self.services.databaseService.widgetSourceLanguages;
    self.targetLanguages = self.services.databaseService.widgetTargetLanguages;
    self.sourceLanguage = self.services.databaseService.widgetSourceSelectedLanguage;
    self.targetLanguage = self.services.databaseService.widgetTargetSelectedLanguage;
    self.translation = self.services.databaseService.widgetLastTranslation;
}

- (void)bindSignals {
    @weakify(self);
    
    [[RACObserve(self, translation) ignore:nil] subscribeNext:^(STTranslation *translation) {
        @strongify(self);
        if (!translation.isEmpty) {
            self.sourceLanguage = translation.sourceLanguage;
            self.targetLanguage = translation.targetLanguage;
            self.inputText = translation.inputText;
        }
        self.detectedLanguage = translation.detectedLanguage;
        self.outputText = [self textForTranslationResult:translation];
        [self.services.databaseService saveWidgetLastTranslation:translation];
    }];
    
    [[RACObserve(self, sourceLanguage) distinctUntilChanged] subscribeNext:^(STLanguage *language) {
        @strongify(self);
        [self pushSourceLanguage:language];
        [self saveLanguages];
    }];
    
    [[RACObserve(self, targetLanguage) distinctUntilChanged] subscribeNext:^(STLanguage *language) {
        @strongify(self);
        [self pushTargetLanguage:language];
        [self saveLanguages];
    }];
    
    RACSignal *textSignal = [[RACObserve(self, inputText) distinctUntilChanged] ignore:nil];
    RACSignal *sourceLanguageSignal = [[RACObserve(self, sourceLanguage) distinctUntilChanged] ignore:nil];
    RACSignal *targetLanguageSignal = [[RACObserve(self, targetLanguage) distinctUntilChanged] ignore:nil];
    
    [[[[[[[RACSignal combineLatest:@[textSignal, sourceLanguageSignal, targetLanguageSignal]] sample:[self.allowTranslation deliverOnMainThread]]
        filter:^BOOL(RACTuple *tuple) {
            RACTupleUnpack(NSString *text, STLanguage *source, STLanguage *target) = tuple;
            return ![self.translation.inputText isEqualToString:text] || ![self.translation.sourceLanguage isEqual:source] || ![self.translation.targetLanguage isEqual:target];
        }]
        map:^RACSignal *(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSString *text, STLanguage *source, STLanguage *target) = tuple;
            return [self.services.translationService translationForText:text fromLanguage:source toLanguage:target];
        }]
        switchToLatest]
        catch:^RACSignal *(NSError *error) {
            @strongify(self);
            STTranslation *translation = [STTranslation emptyTranslation];
            translation.inputText = self.inputText;
            translation.sourceLanguage = self.sourceLanguage;
            translation.targetLanguage = self.targetLanguage;
            return [RACSignal return:translation];
        }]
        subscribeNext:^(STTranslation *translation) {
            @strongify(self);
            self.translation = translation;
        }];
}

#pragma mark - Language handling
- (void)pushSourceLanguage:(STLanguage *)language {
    if ([language.key isEqualToString:@"auto"]) {
        self.sourceSelectedIndex = 1;
    } else {
        self.detectedLanguage = nil;
        RACTupleUnpack(NSArray *collection, NSNumber *index) = [self pushLanguage:language toCollection:self.sourceLanguages];
        self.sourceLanguages = collection;
        self.sourceSelectedIndex = index.integerValue + 2;
    }
}

- (void)pushTargetLanguage:(STLanguage *)language {
    RACTupleUnpack(NSArray *collection, NSNumber *index) = [self pushLanguage:language toCollection:self.targetLanguages];
    self.targetLanguages = collection;
    self.targetSelectedIndex = index.integerValue + 1;
}

- (RACTuple *)pushLanguage:(STLanguage *)language toCollection:(NSArray *)collection {
    BOOL exists = NO;
    NSInteger index = 0;
    
    for (STLanguage *existingLanguage in collection) {
        if ([existingLanguage isEqual:language]) {
            exists = YES;
            index = [collection indexOfObject:existingLanguage];
            break;
        }
    }
    
    NSMutableArray *mutableCollection = [collection mutableCopy];
    if (!exists) {
        [mutableCollection insertObject:language atIndex:0];
        [mutableCollection removeLastObject];
    }
    
    return RACTuplePack([mutableCollection copy], @(index));
}

- (void)saveLanguages {
    [self.services.databaseService saveWidgetSourceLanguages:self.sourceLanguages];
    [self.services.databaseService saveWidgetTargetLanguages:self.targetLanguages];
    [self.services.databaseService saveWidgetSourceSelected:self.sourceLanguage];
    [self.services.databaseService saveWidgetTargetSelected:self.targetLanguage];
}

#pragma mark - User initiated
- (void)updateInputText:(NSString *)text {
    self.inputText = text;
    [self.allowTranslation sendNext:@YES];
}

- (void)selectSourceIndex:(NSInteger)index {
    if (index == 1) {
        self.sourceLanguage = [self.services.languagesService autoLanguage];
    } else {
        self.sourceLanguage = self.sourceLanguages[index - 2];
    }
    
    [self.allowTranslation sendNext:@YES];
}

- (void)selectTargetIndex:(NSInteger)index {
    self.targetLanguage = self.targetLanguages[index - 1];
    [self.allowTranslation sendNext:@YES];
}

- (void)selectSourceLanguage:(STLanguage *)language {
    self.sourceLanguage = language;
    [self.allowTranslation sendNext:@YES];
}

- (void)selectTargetLanguage:(STLanguage *)language {
    self.targetLanguage = language;
    [self.allowTranslation sendNext:@YES];
}

- (void)switchLanguages {
    STLanguage *source = self.sourceLanguage;
    STLanguage *target = self.targetLanguage;
    if ([source.key isEqualToString:@"auto"]) {
        return;
    }
    [self selectTargetLanguage:source];
    [self selectSourceLanguage:target];
}

#pragma mark - Text handling
- (NSAttributedString *)textForTranslationResult:(STTranslation *)translation {
    if (!translation || !translation.parserResult || !translation.parserResult.parsedResponse || !translation.parserResult.parsedResponse.count) {
        return [NSAttributedString new];
    } else if (translation.parserResult.type == STParsedResultTypeTranslation) {
        return [self translationTextForResult:translation.parserResult];
    } else {
        return [self dictionaryTextForResult:translation.parserResult];
    }
}

- (NSAttributedString *)translationTextForResult:(STParserResult *)parserResult {
    return [[NSAttributedString alloc] initWithString:parserResult.parsedResponse[kTranslatedText] attributes:@{NSFontAttributeName : [NSFont systemFontOfSize:12.0]}];
}

- (NSAttributedString *)dictionaryTextForResult:(STParserResult *)parserResult {
    NSMutableAttributedString *outputText = [NSMutableAttributedString new];
    NSAttributedString *newLineString = [[NSAttributedString alloc] initWithString:@"\n"];
    
    NSColor *blackColor = [NSColor blackColor];
    NSFont *mainFont = [NSFont systemFontOfSize:12.0];
    NSDictionary *mainAttributes = @{NSFontAttributeName : mainFont, NSForegroundColorAttributeName : blackColor};
    NSFont *firstTranslationFont = [NSFont systemFontOfSize:16.0];
    NSDictionary *firstTranslationAttributes = @{NSFontAttributeName : firstTranslationFont, NSForegroundColorAttributeName : blackColor};
    
    NSString *transcription = parserResult.parsedResponse[kTranscription];
    if ([transcription length]) {
        [outputText appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"[%@]",transcription] attributes:mainAttributes]];
        [outputText appendAttributedString:newLineString];
    }
    
    NSArray *translationKeys = parserResult.parsedResponse[kTranslationKeys];
    NSDictionary *translationDict = parserResult.parsedResponse[kTranslationDict];
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

@end
