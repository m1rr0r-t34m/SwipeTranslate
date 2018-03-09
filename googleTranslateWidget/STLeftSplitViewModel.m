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
#import "STMainViewModel.h"

@interface STLeftSplitViewModel ()
@property (readwrite, strong, nonatomic) id <STServices> services;
@property (strong, nonatomic) STMainViewModel *mainViewModel;
@property (readwrite, strong, nonatomic) RACSignal *dataReloadSignal;
@property (strong, nonatomic) RACSubject *dataReloadSubject;
@property (strong, nonatomic) STLanguage *sourceLanguage;
@property (strong, nonatomic) STLanguage *targetLanguage;
@property (readwrite, strong, nonatomic) NSArray <STLanguageCellModel *> *sourceLanguages;
@property (readwrite, strong, nonatomic) NSArray <STLanguageCellModel *> *targetLanguages;
@property (readwrite, strong, nonatomic) NSString *sourceSelectedTitle;
@property (readwrite, strong, nonatomic) NSString *targetSelectedTitle;
@property (readwrite, assign, nonatomic) BOOL autoLanguageSelected;
@end

@implementation STLeftSplitViewModel
#pragma mark - Lifecycle
- (instancetype)init {
    NSAssert(NO, @"Use designated initializer initWithServices:");
    self = [super init];
    return self;
}

- (instancetype)initWithMainViewModel:(STMainViewModel *)mainViewModel {
    if(self = [super init]) {
        _mainViewModel = mainViewModel;
        _services = mainViewModel.services;
        _visibleRowsCount = 10;
        _rowHeight = 40;
        _dataReloadSubject = [RACSubject new];
        _dataReloadSignal = [[_dataReloadSubject startWith:nil] ignore:nil];
        _sourceLanguage = self.services.databaseService.sourceSelectedLanguage;
        _targetLanguage = self.services.databaseService.targetSelectedLanguage;
        _mainViewModel.sourceLanguage = _sourceLanguage;
        _mainViewModel.targetLanguage = _targetLanguage;
        _autoLanguageSelected = [self isLanguageAuto:_sourceLanguage];
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
        NSUInteger sourceIndex = [self indexOfLanguage:self.sourceLanguage inCellModelsArray:self.sourceLanguages];
        NSUInteger targetIndex = [self indexOfLanguage:self.targetLanguage inCellModelsArray:self.targetLanguages];;

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
    
    [[RACObserve(self.mainViewModel, translation)
        combineLatestWith:RACObserve(self, autoLanguageSelected)]
        subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            STTranslation *translation = tuple.first;
            if ([tuple.second boolValue]) {
                if (translation.detectedLanguage) {
                    self.sourceSelectedTitle = [NSString stringWithFormat:@"(Auto) > %@", translation.detectedLanguage.title];
                } else {
                    self.sourceSelectedTitle = @"(Auto)";
                }
            }
        }];
    
    RAC(self, sourceSelectedTitle) = [RACObserve(self, sourceLanguage) map:^id (STLanguage *language) {
        return language.title;
    }];
    
    RAC(self, targetSelectedTitle) = [RACObserve(self, targetLanguage) map:^id (STLanguage *language) {
        return language.title;
    }];
    
    [[[[RACObserve(self.mainViewModel, translation) distinctUntilChanged]
        filter:^BOOL(STTranslation *translation) {
            return translation && translation.sourceLanguage && translation.targetLanguage;
        }]
        filter:^BOOL(STTranslation *translation) {
            @strongify(self);
            return ![translation.sourceLanguage isEqual:self.sourceLanguage] || ![translation.targetLanguage isEqual:self.targetLanguage];
        }]
        subscribeNext:^(STTranslation *translation) {
            @strongify(self);
            [self pushSourceLanguage:translation.sourceLanguage];
            [self pushTargetLanguage:translation.targetLanguage];
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
    
    NSArray <STLanguageCellModel *> *sourceLanguageViewModels = [self viewModelsForLanguages:sourceLanguages withSelectedSignal:RACObserve(self, sourceLanguage)];
    NSArray <STLanguageCellModel *> *targetLanguageViewModels = [self viewModelsForLanguages:targetLanguages withSelectedSignal:RACObserve(self, targetLanguage)];
    
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
- (void)setSourceSelectedIndex:(NSInteger)index {
    STLanguage *language = [self.sourceLanguages objectAtIndex:index].language;
    [self setSourceSelectedLanguage:language];
}

- (void)setTargetSelectedIndex:(NSInteger)index {
    STLanguage *language = [self.targetLanguages objectAtIndex:index].language;
    [self setTargetSelectedLanguage:language];
}

- (void)setSourceSelectedLanguage:(STLanguage *)language {
    if ([self.sourceLanguage isEqual:language]) {
        return;
    }
    [self pushSourceLanguage:language];
    self.mainViewModel.sourceLanguage = self.sourceLanguage;
    [self.mainViewModel allowTranslation];
}

- (void)setTargetSelectedLanguage:(STLanguage *)language {
    if ([self.targetLanguage isEqual:language]) {
        return;
    }
    [self pushTargetLanguage:language];
    self.mainViewModel.targetLanguage = self.targetLanguage;
    [self.mainViewModel allowTranslation];
}

- (void)pushSourceLanguage:(STLanguage *)language {
    self.sourceLanguage = language;
    if ([self isLanguageAuto:language]) {
        self.autoLanguageSelected = YES;
    } else {
        self.autoLanguageSelected = NO;
        self.sourceLanguages = [self pushLanguage:language toCollection:self.sourceLanguages withSelectedSignal:RACObserve(self, sourceLanguage)];
    }
    [self updateBorders];
    [self saveLanguages];
    [self.dataReloadSubject sendNext:@YES];
}

- (void)pushTargetLanguage:(STLanguage *)language {
    self.targetLanguages = [self pushLanguage:language toCollection:self.targetLanguages withSelectedSignal:RACObserve(self, targetLanguage)];
    self.targetLanguage = language;
    [self updateBorders];
    [self saveLanguages];
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
        [self setSourceSelectedIndex:0];
    } else {
        [self setSourceSelectedLanguage:[self.services.languagesService autoLanguage]];
    }
}

- (void)switchLanguages {
    STLanguage *source = self.sourceLanguage;
    STLanguage *target = self.targetLanguage;
    
    if (self.autoLanguageSelected) {
        //TODO: Do we need to do something here?
    } else {
        [self setSourceSelectedLanguage:target];
        [self setTargetSelectedLanguage:source];
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
    
    [self.services.databaseService saveSourceSelected:self.sourceLanguage];
    [self.services.databaseService saveTargetSelected:self.targetLanguage];
}

- (BOOL)isLanguageAuto:(STLanguage *)language {
    return [language isEqual:[self.services.languagesService autoLanguage]];
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
