//
//  LeftSplitViewModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLeftSplitViewModel.h"
#import <ReactiveObjC.h>
#import "STLanguage.h"
#import "NSMutableArray+Helpers.h"
#import "STServices.h"
#import "STLanguageCellModel.h"
#import "STTranslation.h"

@interface STLeftSplitViewModel ()
@property (strong, nonatomic) RACSubject *dataReloadSubject;
@property (assign, nonatomic) BOOL autoLanguageSelected;
@property (strong, nonatomic) NSString *detectedLanguage;
@end

@implementation STLeftSplitViewModel
#pragma mark - Lifecycle
- (instancetype)init {
    NSAssert(NO, @"Use designated initializer initWithServices:");
    self = [super init];
    return self;
}

- (instancetype)initWithServices:(id <STServices>)services {
    if(self = [super init]) {
        _services = services;
        _visibleRowsCount = 10;
        _rowHeight = 40;
        _dataReloadSubject = [RACSubject new];
        _dataReloadSignal = [[_dataReloadSubject startWith:nil] ignore:nil];
        _sourceSelectedLanguage = self.services.databaseService.sourceSelectedLanguage;
        _targetSelectedLanguage = self.services.databaseService.targetSelectedLanguage;
        
        [self loadInitialData];
        [self bindSignals];
    }
    return self;
}

- (void)bindSignals {
    @weakify(self);
    [RACObserve(self, visibleRowsCount) subscribeNext:^(NSNumber *count) {
        @strongify(self);
        NSUInteger rowsCount = [count unsignedIntegerValue];
        NSUInteger sourceIndex = [self indexOfLanguage:self.sourceSelectedLanguage inCellModelsArray:self.sourceLanguages];
        NSUInteger targetIndex = [self indexOfLanguage:self.targetSelectedLanguage inCellModelsArray:self.targetLanguages];;

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
        [self updateBorders];
        [self.dataReloadSubject sendNext:@YES];
    }];
    
    
    RACSignal *autoSelected = [RACObserve(self, sourceSelectedLanguage) filter:^BOOL(STLanguage *language) {
        @strongify(self);
        return [self.services.languagesService.autoLanguage isEqual:language];
    }];
    
    [[RACObserve(self, lastTranslation)
        combineLatestWith:autoSelected]
        subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            STTranslation *translation = tuple.first;
            if (self.autoLanguageSelected) {
                if (translation.detectedLanguage) {
                    self.sourceSelectedTitle = [NSString stringWithFormat:@"(Auto) > %@", translation.detectedLanguage.title];
                } else {
                    self.sourceSelectedTitle = @"(Auto)";
                }
            }
        }];
    
    RAC(self, sourceSelectedTitle) = [RACObserve(self, sourceSelectedLanguage) map:^id (STLanguage *language) {
        return language.title;
    }];
    
    RAC(self, targetSelectedTitle) = [RACObserve(self, targetSelectedLanguage) map:^id (STLanguage *language) {
        return language.title;
    }];
}

#pragma mark - Cell viewmodels
- (void)loadInitialData {
    NSMutableArray *sourceLanguages = [self.services.databaseService.sourceLanguages mutableCopy];
    
    if (!sourceLanguages) sourceLanguages = [NSMutableArray new];
    
    if (sourceLanguages.count < defaultLanguagesCount) {
        NSArray *randomLanguages = [self.services.languagesService randomLanguagesExcluding:sourceLanguages withCount:defaultLanguagesCount - sourceLanguages.count];
        [sourceLanguages addObjectsFromArray:randomLanguages];
    }
    
    NSMutableArray *targetLanguages = [self.services.databaseService.targetLanguages mutableCopy];
    
    if (!targetLanguages) targetLanguages = [NSMutableArray new];
    
    if (targetLanguages.count < defaultLanguagesCount) {
        NSArray *randomLanguages = [self.services.languagesService randomLanguagesExcluding:sourceLanguages withCount:defaultLanguagesCount - targetLanguages.count];
        [targetLanguages addObjectsFromArray:randomLanguages];
    }
    
    NSArray <STLanguageCellModel *> *sourceLanguageViewModels = [self viewModelsForLanguages:sourceLanguages withSelectedSignal:RACObserve(self, sourceSelectedLanguage)];
    NSArray <STLanguageCellModel *> *targetLanguageViewModels = [self viewModelsForLanguages:targetLanguages withSelectedSignal:RACObserve(self, targetSelectedLanguage)];
    
    NSUInteger countOfSourceSelected = [[[sourceLanguageViewModels.rac_sequence filter:^BOOL(STLanguageCellModel *cellModel) {
        return cellModel.selected;
    }] array] count];
    
    NSUInteger countOfTargetSelected = [[[targetLanguageViewModels.rac_sequence filter:^BOOL(STLanguageCellModel *cellModel) {
        return cellModel.selected;
    }] array] count];
    
    if (countOfSourceSelected == 0 && !self.autoLanguageSelected) {
        sourceLanguageViewModels.firstObject.selected = YES;
    }
    
    if (countOfTargetSelected == 0) {
        targetLanguageViewModels.firstObject.selected = YES;
    }
    
    sourceLanguageViewModels.lastObject.shouldDrawBorder = NO;
    targetLanguageViewModels.lastObject.shouldDrawBorder = NO;
    
    self.sourceLanguages = sourceLanguageViewModels;
    self.targetLanguages = targetLanguageViewModels;
    [self.dataReloadSubject sendNext:@YES];
}

- (NSArray <STLanguageCellModel *> *)viewModelsForLanguages:(NSArray <STLanguage *>*)languages withSelectedSignal:(RACSignal *)selectedSignal{
    return [[languages.rac_sequence map:^id(STLanguage *language) {
        STLanguageCellModel *model = [self viewModelForLanguage:language withSelectedSignal:selectedSignal];
        return model;
    }] array];
}

- (STLanguageCellModel *)viewModelForLanguage:(STLanguage *)language withSelectedSignal:(RACSignal *)selectedSignal{
    STLanguageCellModel *model = [[STLanguageCellModel alloc] initWithLanguage:language];
    [selectedSignal subscribeNext:^(STLanguage *selected) {
        model.selected = [model.language isEqual:selected];
    }];
    model.shouldDrawBorder = YES;
    return model;
}

#pragma mark - Select languages
- (void)setSourceSelected:(NSInteger)index {
    self.sourceSelectedLanguage = [self.sourceLanguages objectAtIndex:index].language;
    [self saveLanguages];
}

- (void)setTargetSelected:(NSInteger)index {
    self.targetSelectedLanguage = [self.targetLanguages objectAtIndex:index].language;
    [self saveLanguages];
}

- (void)pushSourceLanguage:(STLanguage *)language {
    self.sourceLanguages = [self pushLanguage:language toCollection:self.sourceLanguages withSelectedSignal:RACObserve(self, sourceSelectedLanguage)];
    self.sourceSelectedLanguage = language;
    [self saveLanguages];
    [self updateBorders];
    [self.dataReloadSubject sendNext:@YES];
}

- (void)pushTargetLanguage:(STLanguage *)language {
    self.targetLanguages = [self pushLanguage:language toCollection:self.targetLanguages withSelectedSignal:RACObserve(self, targetSelectedLanguage)];
    self.targetSelectedLanguage = language;
    [self saveLanguages];
    [self updateBorders];
    [self.dataReloadSubject sendNext:@YES];
}

- (NSArray *)pushLanguage:(STLanguage *)language toCollection:(NSArray *)viewModels withSelectedSignal:(RACSignal *)selectedSignal {
    NSMutableArray <STLanguageCellModel *> *mutableModels = [viewModels mutableCopy];
    BOOL contains = NO;
    for (STLanguageCellModel *cellModel in viewModels) {
        if ([cellModel.language isEqual:language]) {
            contains = YES;
        }
    }
    
    if (!contains) {
        STLanguageCellModel *cellModel = [self viewModelForLanguage:language withSelectedSignal:selectedSignal];
        [mutableModels insertObject:cellModel atIndex:0];
        [mutableModels removeLastObject];
    }
    
    return [mutableModels copy];
}

- (void)switchAutoButton {
    if (self.autoLanguageSelected) {
        self.sourceSelectedLanguage = self.sourceLanguages[0].language;
    } else {
        self.sourceSelectedLanguage = [self.services.languagesService autoLanguage];
    }
    
    [self saveLanguages];
    [self.dataReloadSubject sendNext:@YES];
}

- (void)switchLanguages {
    STLanguage *source = self.sourceSelectedLanguage;
    STLanguage *target = self.targetSelectedLanguage;
    
    if (self.autoLanguageSelected) {
        //TODO: Do we need to do something here?
    } else {
        [self pushSourceLanguage:target];
        [self pushTargetLanguage:source];
    }
}

#pragma mark - Helpers
- (void)saveLanguages {
    [self.services.databaseService saveSourceLanguages:[[self.sourceLanguages.rac_sequence map:^id(STLanguageCellModel *cellModel) {
        return cellModel.language;
    }] array]];
    
    [self.services.databaseService saveTargetLanguages:[[self.targetLanguages.rac_sequence map:^id(STLanguageCellModel *cellModel) {
        return cellModel.language;
    }] array]];
    
    [self.services.databaseService saveSourceSelected:self.sourceSelectedLanguage];
    [self.services.databaseService saveTargetSelected:self.targetSelectedLanguage];
}

- (BOOL)autoLanguageSelected {
    return [self.sourceSelectedLanguage isEqual:[self.services.languagesService autoLanguage]];
}

- (NSInteger)indexOfLanguage:(STLanguage *)language inCellModelsArray:(NSArray <STLanguageCellModel *> *)cellModels {
    for (STLanguageCellModel * cellModel in cellModels) {
        if ([cellModel.language isEqual:language]) {
            return [cellModels indexOfObject:cellModel];
        }
    }
    
    return NSNotFound;
}

- (void)updateBorders {
    for (STLanguageCellModel *cellModel in self.sourceLanguages) {
        cellModel.shouldDrawBorder = YES;
    }
    for (STLanguageCellModel *cellModel in self.targetLanguages) {
        cellModel.shouldDrawBorder = YES;
    }
    self.sourceLanguages.lastObject.shouldDrawBorder = NO;
    self.targetLanguages.lastObject.shouldDrawBorder = NO;
}
@end
