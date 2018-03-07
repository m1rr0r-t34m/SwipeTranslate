//
//  STRightSplitViewModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STRightSplitViewModel.h"
#import "STTranslation.h"
#import "STParserResult.h"
#import <ReactiveObjC.h>
#import "STServices.h"
#import "STFavouriteCellModel.h"
#import "STFavouriteUpdate.h"
#import "STMainViewModel.h"

@interface STRightSplitViewModel()
@property (strong, nonatomic) id <STServices> services;
@property (strong, nonatomic) RACSubject *favouritesUpdateSubject;
@property (strong, nonatomic) STTranslation *previousTranslation;
@property (strong, nonatomic) STTranslation *currentTranslation;
@property (strong, nonatomic) STMainViewModel *mainViewModel;
@end

@implementation STRightSplitViewModel
- (instancetype)initWithMainViewModel:(STMainViewModel *)mainViewModel  {
    if (self = [super init]) {
        _services = mainViewModel.services;
        _favouritesUpdateSubject = [RACSubject new];
        _favouritesUpdateSignal = [_favouritesUpdateSubject deliverOnMainThread];
        _mainViewModel = mainViewModel;
        _favouritesSelectedIndex = -1;
        [self setupBindings];
        [self fetchFavouriteTranslations];
    }
    
    return self;
}

- (void)setSourceText:(NSString *)text {
    self.inputText = text;
    [self.mainViewModel setSourceText:text];
}

- (void)setupBindings {
    RAC(self, translating) = RACObserve(self.mainViewModel, translating);
    
    @weakify(self);
    [RACObserve(self.mainViewModel, translation) subscribeNext:^(STTranslation *translation) {
        @strongify(self);
        self.currentTranslation = translation;
        self.previousTranslation = translation;
    }];
    
    [RACObserve(self, currentTranslation) subscribeNext:^(STTranslation *translation) {
        @strongify(self);
        self.outputText = [self textForTranslationResult:translation];
        self.inputText = translation.inputText;
        if (!self.inputText) self.inputText = [NSString new];
        if (!self.outputText) self.outputText = [NSAttributedString new];
        self.canSaveOrRemoveCurrentTranslation = (translation && translation.inputText && translation.parserResult && translation.parserResult.parsedResponse);
        self.currentTranslationIsSaved = [self translationIsSaved:translation];
    }];
}

- (void)showSavedTranslation:(NSInteger)index {
    if (index != NSNotFound && index != -1) {
        self.currentTranslation = self.favouriteViewModels[index].translation;
    } else if (![self.previousTranslation isEqual:self.currentTranslation]) {
        self.currentTranslation = self.previousTranslation;
    } else {
        self.currentTranslation = [STTranslation emptyTranslation];
    }
    self.favouritesSelectedIndex = index;
}

#pragma mark - Favourite translations
- (void)fetchFavouriteTranslations {
    NSArray *favourites = [self.services.databaseService favouriteTranslations];
    @weakify(self);
    self.favouriteViewModels = [[[favourites.rac_sequence map:^id (STTranslation *translation) {
        @strongify(self);
        return [self favouriteCellModelForTranslation:translation];
    }] array] mutableCopy];
    [self.favouritesUpdateSubject sendNext:[STFavouriteUpdate updateWithType:STFavouriteUpdateTypeReload index:0]];
}

- (STFavouriteCellModel *)favouriteCellModelForTranslation:(STTranslation *)translation {
    NSString *outputText = [self textForTranslationResult:translation].string;
    outputText = [outputText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    STFavouriteCellModel *model = [STFavouriteCellModel new];
    model.inputText = translation.inputText;
    model.outputText = outputText;
    model.translation = translation;
    
    @weakify(self);
    model.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [self removeTranslationSignalBlock:translation];
    }];
    return model;
}

- (NSInteger)indexOfCurrentTranslation {
    return [self indexOfTranslation:self.currentTranslation];
}

- (NSInteger)indexOfTranslation:(STTranslation *)translation {
    NSInteger index = -1;
    for (STFavouriteCellModel *model in self.favouriteViewModels) {
        if ([model.translation isEqual:translation]) {
            index = [self.favouriteViewModels indexOfObject:model];
            break;
        }
    }
    
    return index;
}

- (void)saveOrRemoveCurrentTranslation {
    if (self.currentTranslationIsSaved) {
        [self removeTranslation:self.currentTranslation];
    } else {
        [self saveTranslation:self.currentTranslation];
    }
}

- (void)saveTranslation:(STTranslation *)translation {
    STFavouriteCellModel *model = [self favouriteCellModelForTranslation:translation];
    [self.favouriteViewModels insertObject:model atIndex:0];
    [self.favouritesUpdateSubject sendNext:[STFavouriteUpdate updateWithType:STFavouriteUpdateTypeInsert index:0]];
    [self.services.databaseService saveFavouriteTranslation:translation];
    self.currentTranslationIsSaved = [self translationIsSaved:translation];
}

- (void)removeTranslation:(STTranslation *)translation {
    NSInteger index = [self indexOfTranslation:translation];
    [self.favouriteViewModels removeObjectAtIndex:index];
    [self.favouritesUpdateSubject sendNext:[STFavouriteUpdate updateWithType:STFavouriteUpdateTypeRemove index:index]];
    [self.services.databaseService removeFavouriteTranslation:translation];
    self.currentTranslationIsSaved = [self translationIsSaved:translation];
    self.favouritesSelectedIndex = -1;
}

- (RACSignal *)removeTranslationSignalBlock:(STTranslation *)translation {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self removeTranslation:translation];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (BOOL)translationIsSaved:(STTranslation *)checkTranslation {
    NSInteger count = [[[[self.favouriteViewModels.rac_sequence map:^id (STFavouriteCellModel *value) {
        return value.translation;
    }] filter:^BOOL(STTranslation *translation) {
        return [translation isEqual:checkTranslation];
    }] array] count];
    
    return count > 0;
}

#pragma mark - Translation result
- (NSAttributedString *)textForTranslationResult:(STTranslation *)translation {
    if (!translation || !translation.parserResult || !translation.parserResult.parsedResponse || !translation.parserResult.parsedResponse.count) {
        return [NSAttributedString new];
    } else if (translation.parserResult.type == STParsedResultTypeTranslation) {
        return [self translationTextForResult:translation.parserResult];
    } else {
        return [self dictionaryTextForResult:translation.parserResult];
    }
}

- (NSAttributedString *)dictionaryTextForResult:(STParserResult *)parserResult {
    NSMutableAttributedString *outputText = [NSMutableAttributedString new];
    NSAttributedString *newLineString = [[NSAttributedString alloc] initWithString:@"\n"];
    
    NSDictionary *translatedWordAttributes = @{NSFontAttributeName : [NSFont boldSystemFontOfSize:18.0]};
    NSDictionary *translatedSynonimsAttributes = @{NSFontAttributeName : [NSFont systemFontOfSize:17.0]};
    NSDictionary *partOfSpeechAttributes = @{NSFontAttributeName : [NSFont systemFontOfSize:15.5]};
    NSDictionary *transcriptionAttributes = @{NSFontAttributeName : [NSFont systemFontOfSize:24.0], NSForegroundColorAttributeName : [NSColor grayColor]};
    NSDictionary *meaningsAttributes = @{NSFontAttributeName : [NSFont systemFontOfSize:16.0 weight:NSFontWeightLight]};
    NSDictionary *examplesAttribtes = @{NSFontAttributeName : [NSFont systemFontOfSize:14.0 weight:NSFontWeightLight]};
    
    NSString *transcription = parserResult.parsedResponse[kTranscription];
    NSArray *translationKeys = parserResult.parsedResponse[kTranslationKeys];
    NSDictionary *translationDict = parserResult.parsedResponse[kTranslationDict];
    
    if (transcription.length) {
        [outputText appendAttributedString: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]", transcription] attributes:transcriptionAttributes]];
        [outputText appendAttributedString:newLineString];
        [outputText appendAttributedString:newLineString];
    }
    
    for (NSString *partOfSpeech in translationKeys) {
        NSAttributedString *partOfSpeechString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:", partOfSpeech] attributes:partOfSpeechAttributes];
        [outputText appendAttributedString:partOfSpeechString];
        [outputText appendAttributedString:newLineString];
        
        for (NSDictionary *translation in translationDict[partOfSpeech]) {
            NSAttributedString *translatedText = [[NSAttributedString alloc] initWithString:translation[kTranslatedText] attributes:translatedWordAttributes];
            [outputText appendAttributedString:translatedText];
            
            NSArray *synonims = translation[kTranslatedSynonims];
            for (NSString *synonim in synonims) {
                [outputText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@",synonim] attributes:translatedSynonimsAttributes]];
            }
            
            [outputText appendAttributedString:newLineString];
            
            NSArray *meanings = translation[kMeanings];
            for (NSString *meaningString in meanings) {
                [outputText appendAttributedString:[[NSAttributedString alloc] initWithString:meaningString attributes:meaningsAttributes]];
                if (meaningString != [meanings lastObject]) {
                    [outputText appendAttributedString:[[NSAttributedString alloc] initWithString:@", " attributes:meaningsAttributes]];
                }
            }
            
            if (meanings.count) {
                [outputText appendAttributedString:newLineString];
                [outputText appendAttributedString:newLineString];
            }
            
            NSArray *examples = translation[kExamples];
            NSArray *translatedExamples = translation[kTranslatedExamples];
            if (examples.count) {
                for(int k=0; k<examples.count; k++) {
                    [outputText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %C  %@ \n",examples[k], 0x2014, translatedExamples[k]] attributes:examplesAttribtes]];
                }
                [outputText appendAttributedString:newLineString];
            }
            [outputText appendAttributedString:newLineString];
        }
        
    }
    
    return outputText;
}

- (NSAttributedString *)translationTextForResult:(STParserResult *)parserResult {
    return [[NSAttributedString alloc] initWithString:parserResult.parsedResponse[kTranslatedText] attributes:@{NSFontAttributeName : [NSFont systemFontOfSize:16.0]}];
}
@end
