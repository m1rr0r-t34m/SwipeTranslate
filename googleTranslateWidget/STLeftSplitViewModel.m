//
//  LeftSplitViewModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLeftSplitViewModel.h"
#import "STLanguagesManager.h"
#import "STLanguageCellModel.h"
#import "SavedInfo.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "STLanguage.h"
#import "STTranslationManager.h"

@interface NSMutableArray (Helpers)
- (void)replaceElementAtIndex:(NSUInteger)firstIndex withElementAtIndex:(NSUInteger)secondIndex;
@end

@implementation NSMutableArray (Helpers)
- (void)replaceElementAtIndex:(NSUInteger)firstIndex withElementAtIndex:(NSUInteger)secondIndex {
    NSAssert(self.count > firstIndex, @"Out of bounds index");
    NSAssert(self.count > secondIndex, @"Out of bounds index");
    
    id firstObject = [self objectAtIndex:firstIndex];
    id secondObject = [self objectAtIndex:secondIndex];
    
    [self removeObjectAtIndex:firstIndex];
    [self insertObject:secondObject atIndex:firstIndex];
    
    [self removeObjectAtIndex:secondIndex];
    [self insertObject:firstObject atIndex:secondIndex];
}
@end

@interface STLeftSplitViewModel ()
@property (strong, nonatomic) RACSubject *dataReloadSubject;
@property (assign, nonatomic) BOOL autoLanguageSelected;
@property (strong, nonatomic) STLanguage *lastSourceSelectedLanguage;
@property (strong, nonatomic) NSString *detectedLanguage;
@end

@implementation STLeftSplitViewModel

- (instancetype)init {
    if(self = [super init]) {
        
        _visibleRowsCount = 10;
        _rowHeight = 40;
        _dataReloadSubject = [RACSubject new];
        _dataReloadSignal = [[_dataReloadSubject startWith:nil] ignore:nil];
        _sourceSelectedLanguage = [STLanguagesManager selectedSourceLanguage];
        _targetSelectedLanguage = [STLanguagesManager selectedTargetLanguage];
        
        [self prepareViewModels];
        [self bindSignals];
    }
    return self;
}

- (void)bindSignals {
    @weakify(self);
    [RACObserve(self, visibleRowsCount) subscribeNext:^(NSNumber *count) {
        @strongify(self);

        NSUInteger rowsCount = [count unsignedIntegerValue];
        
        NSUInteger sourceIndex = [self indexOfLanguage:self.sourceSelectedLanguage InCellModelsArray:self.sourceLanguages];
        NSUInteger targetIndex = [self indexOfLanguage:self.targetSelectedLanguage InCellModelsArray:self.targetLanguages];;

        NSMutableArray *sourceLanguages = [self.sourceLanguages mutableCopy];
        if (sourceIndex != NSNotFound && sourceIndex > rowsCount - 1) {
            [sourceLanguages replaceElementAtIndex:rowsCount-1 withElementAtIndex:sourceIndex];
        }
        
        NSMutableArray *targetLanguages = [self.targetLanguages mutableCopy];
        if (targetIndex != NSNotFound && targetIndex > rowsCount - 1) {
            [targetLanguages replaceElementAtIndex:rowsCount-1 withElementAtIndex:targetIndex];
        }
        
        self.sourceLanguages = [sourceLanguages copy];
        self.targetLanguages = [targetLanguages copy];
        
        [self saveLanguages];
        [self prepareViewModels];
    }];
    
    [[RACObserve(self, autoLanguageSelected) skip:1] subscribeNext:^(NSNumber *selected) {
        @strongify(self);
        if (selected.boolValue) {
            self.lastSourceSelectedLanguage = self.sourceSelectedLanguage;
            self.sourceSelectedLanguage = [STLanguagesManager autoLanguage];
        } else {
            self.sourceSelectedLanguage = self.lastSourceSelectedLanguage;
        }

        //TODO: Don't need to recreate viewModels here
        //Just drop selection and send reload signal (or even reload row if macOS can handle this)
        [self prepareViewModels];
    }];
    
    [[[[RACObserve([STTranslationManager manager], detectedLanguage) ignore:nil] distinctUntilChanged] map:^id(NSString *key) {
        return [STLanguagesManager languageForKey:key];
    }] subscribeNext:^(NSString *language) {
        @strongify(self);
        self.sourceSelectedTitle = [NSString stringWithFormat:@"(Auto) > %@", language];
    }];
    
    
    
    [RACObserve(self, sourceSelectedLanguage) subscribeNext:^(STLanguage *language) {
        @strongify(self);
        self.sourceSelectedTitle = language.title;
    }];
    
    [RACObserve(self, targetSelectedLanguage) subscribeNext:^(STLanguage *language) {
        @strongify(self);
        self.targetSelectedTitle = language.title;
    }];
    
    
    
}

- (void)saveLanguages {
    [SavedInfo setSourceLanguages:[[self.sourceLanguages.rac_sequence map:^id(STLanguageCellModel *cellModel) {
        return cellModel.title;
    }] array]];
    
    [SavedInfo setTargetLanguages:[[self.targetLanguages.rac_sequence map:^id(STLanguageCellModel *cellModel) {
        return cellModel.title;
    }] array]];
}

- (void)prepareViewModels {
    NSMutableArray *sourceLanguages = [[STLanguagesManager sourceLanguages] mutableCopy];
    if (!sourceLanguages) sourceLanguages = [NSMutableArray new];
    
    if (sourceLanguages.count < FavouriteLanguagesCount) {
        NSArray *randomLanguages = [STLanguagesManager randomLanguagesExcluding:sourceLanguages withCount:FavouriteLanguagesCount - sourceLanguages.count];
        [sourceLanguages addObjectsFromArray:randomLanguages];
    }
    
    NSMutableArray *targetLanguages = [[STLanguagesManager targetLanguages] mutableCopy];
    if (!targetLanguages) targetLanguages = [NSMutableArray new];
    
    if (targetLanguages.count < FavouriteLanguagesCount) {
        NSArray *randomLanguages = [STLanguagesManager randomLanguagesExcluding:sourceLanguages withCount:FavouriteLanguagesCount - targetLanguages.count];
        [targetLanguages addObjectsFromArray:randomLanguages];
    }
    
    NSArray <STLanguageCellModel *> *sourceLanguageViewModels = [self viewModelsForLanguages:sourceLanguages withSelectedLanguage:self.sourceSelectedLanguage];
    NSArray <STLanguageCellModel *> *targetLanguageViewModels = [self viewModelsForLanguages:targetLanguages withSelectedLanguage:self.targetSelectedLanguage];
    
    NSUInteger countOfSourceSelected = [[[sourceLanguageViewModels.rac_sequence filter:^BOOL(STLanguageCellModel *cellModel) {
        return cellModel.selected;
    }] array] count];
    
    NSUInteger countOfTargetSelected = [[[targetLanguageViewModels.rac_sequence filter:^BOOL(STLanguageCellModel *cellModel) {
        return cellModel.selected;
    }] array] count];
    
    if (countOfSourceSelected == 0 && !self.autoLanguageSelected) {
        [sourceLanguageViewModels firstObject].selected = YES;
    }
    
    if (countOfTargetSelected == 0) {
        [targetLanguageViewModels firstObject].selected = YES;
    }
    
    [sourceLanguageViewModels lastObject].shouldDrawBorder = NO;
    [targetLanguageViewModels lastObject].shouldDrawBorder = NO;
    
    self.sourceLanguages = sourceLanguageViewModels;
    self.targetLanguages = targetLanguageViewModels;
    [self.dataReloadSubject sendNext:@YES];
}

- (NSArray <STLanguageCellModel *> *)viewModelsForLanguages:(NSArray <STLanguage *>*)languages withSelectedLanguage:(STLanguage *)selectedLanguage {
    return [[languages.rac_sequence map:^id(STLanguage *language) {
        STLanguageCellModel *languageCellModel = [[STLanguageCellModel alloc] initWithLanguage:language Title:language.title];
        languageCellModel.shouldDrawBorder = YES;
        if ([languageCellModel.language isEqual:selectedLanguage]) {
            languageCellModel.selected = YES;
        }
        return languageCellModel;
    }] array];
}

- (NSInteger) indexOfLanguage:(STLanguage *)language InCellModelsArray:(NSArray <STLanguageCellModel *> *)cellModels {
    for (STLanguageCellModel * cellModel in cellModels) {
        if ([cellModel.language isEqual:language]) {
            return [cellModels indexOfObject:cellModel];
        }
    }
    
    return NSNotFound;
}

- (void)setSourceSelected:(NSInteger)index {
    self.sourceSelectedLanguage = [self.sourceLanguages objectAtIndex:index].language;
    [SavedInfo setSourceSelection:self.sourceSelectedLanguage.title];
}

- (void)setTargetSelected:(NSInteger)index {
    self.targetSelectedLanguage = [self.targetLanguages objectAtIndex:index].language;
    [SavedInfo setTargetSelection:self.targetSelectedLanguage.title];
}

//- (NSString *)sourceSelectedTitle {
//    //TODO: we need to clear detected language 
//    if (self.autoLanguageSelected && self.detectedLanguage) {
//        return [NSString stringWithFormat:@"(Auto) > %@", self.detectedLanguage];
//    } else {
//        return _sourceSelectedLanguage.title;
//    }
//}
//
//- (NSString *)targetSelectedTitle {
//    return _targetSelectedLanguage.title; 
//}

- (void)switchAutoButton {
    self.autoLanguageSelected = !self.autoLanguageSelected;
}
@end
