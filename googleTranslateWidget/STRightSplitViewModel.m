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

@interface STRightSplitViewModel()
@property (strong, nonatomic) id <STServices> services;
@end

@implementation STRightSplitViewModel
- (instancetype)initWithServices:(id <STServices>)services {
    if (self = [super init]) {
        _services = services;
        [self setupBindings];
        [self fetchFavouriteTranslations];
    }
    
    return self;
}

- (void)setupBindings {
    @weakify(self);
    RAC(self, outputText) = [RACObserve(self, translation) map:^id (STTranslation *translation) {
        @strongify(self);
        return [self textForTranslationResult:translation];
    }];
}

- (void)fetchFavouriteTranslations {
    NSArray *favourites = [self.services.databaseService favouriteTranslations];
    @weakify(self);
    self.favouriteViewModels = [favourites.rac_sequence map:^id (STTranslation *translation) {
        @strongify(self);
        return [self favouriteCellModelForTranslation:translation];
    }].array;
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

- (NSAttributedString *)textForTranslationResult:(STTranslation *)translation {
    if (!translation || !translation.parserResult || !translation.parserResult.parsedResponse || !translation.parserResult.parsedResponse.count) {
        return [NSAttributedString new];
    } else if (translation.parserResult.type == STParsedResultTypeTranslation) {
        return [self translationTextForResult:translation.parserResult];
    } else {
        return [self dictionaryTextForResult:translation.parserResult];
    }
}

- (STFavouriteCellModel *)favouriteCellModelForTranslation:(STTranslation *)translation {
    NSString *outputText = [self textForTranslationResult:translation].string;
    outputText = [outputText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

    return [[STFavouriteCellModel alloc] initWithInput:translation.inputText output:outputText];
}
- (void)saveFavouriteTranslation {
    NSArray *favourites = [self.services.databaseService favouriteTranslations];
    BOOL found = NO;
    for (STTranslation *translation in favourites) {
        if ([translation isEqual:self.translation]) {
            found = YES;
        }
    }
    
    NSMutableArray *favouriteCellModels = [self.favouriteViewModels mutableCopy];
    STFavouriteCellModel *cellModel = [self favouriteCellModelForTranslation:self.translation];
    if (!found) {
        [self.services.databaseService saveFavouriteTranslation:self.translation];
        [favouriteCellModels insertObject:cellModel atIndex:0];
    } else {
        [self.services.databaseService removeFavouriteTranslation:self.translation];
        for (STFavouriteCellModel *model in self.favouriteViewModels) {
            if ([model.translation isEqual:self.translation]) {
                [favouriteCellModels removeObject:model];
            }
        }
    }
    
    self.favouriteViewModels = [favouriteCellModels copy];
}
@end
