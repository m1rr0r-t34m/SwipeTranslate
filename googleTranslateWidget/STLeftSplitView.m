//
//  LeftSplitView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLeftSplitView.h"
#import "STLanguageCell.h"
#import "STLanguageCellModel.h"
#import <ReactiveObjC.h>
#import <QuartzCore/QuartzCore.h>
#import "STLanguageMenu.h"

#define NumberOfRows 5

static CGFloat minRowHeight = 40;
static CGFloat maxRowHeight = 60;
static NSUInteger maxNumberOfRows = 10;

@interface STLeftSplitView () <NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *sourceLanguageTable;
@property (weak) IBOutlet NSTableView *targetLanguageTable;
@property (weak) IBOutlet NSScrollView *sourceLanguageTableScroll;
@property (strong, nonatomic) IBOutlet NSButton *autoLanguageButton;
@property (weak) IBOutlet NSTextField *sourceLanguageTitleTextField;
@property (weak) IBOutlet NSTextField *targetLanguageTitleTextField;
@property (strong, nonatomic) STLanguageMenu *sourceLanguageMenu;
@property (strong, nonatomic) STLanguageMenu *targetLanguageMenu;
@end

@implementation STLeftSplitView
#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.sourceLanguageTitleTextField, stringValue) = RACObserve(self.viewModel, sourceSelectedTitle);
    RAC(self.targetLanguageTitleTextField, stringValue) = RACObserve(self.viewModel, targetSelectedTitle);

    [self setupMenus];
    [self setupViewResizes];
    
    @weakify(self);
    [self.viewModel.dataReloadSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.sourceLanguageTable reloadData];
        [self.targetLanguageTable reloadData];
    }];
    
    self.sourceLanguageTable.refusesFirstResponder = YES;
    self.targetLanguageTable.refusesFirstResponder = YES;
    self.sourceLanguageTable.focusRingType = NSFocusRingTypeNone;
    self.targetLanguageTable.focusRingType = NSFocusRingTypeNone;
    
    self.sourceLanguageTable.target = self;
    self.targetLanguageTable.target = self;
    self.sourceLanguageTable.action = @selector(handleTableViewTap:);
    self.targetLanguageTable.action = @selector(handleTableViewTap:);
    
    [RACObserve(self.viewModel, autoLanguageSelected) subscribeNext:^(NSNumber *autoSelected) {
        @strongify(self);
        if (autoSelected.boolValue) {
            self.autoLanguageButton.image = [NSImage imageNamed:@"AutoButtonPushed"];
        } else {
            self.autoLanguageButton.image = [NSImage imageNamed:@"AutoButtonIcon"];
        }
    }];
}

- (void)setupMenus {
    self.sourceLanguageMenu = [[STLanguageMenu alloc] initWithLanguagesService:self.viewModel.services.languagesService];
    self.targetLanguageMenu = [[STLanguageMenu alloc] initWithLanguagesService:self.viewModel.services.languagesService];
    
    @weakify(self);
    [self.sourceLanguageMenu.selectSignal subscribeNext:^(STLanguage *language) {
        @strongify(self);
        [self.viewModel setSourceSelectedLanguage:language];
    }];
    
    [self.targetLanguageMenu.selectSignal subscribeNext:^(STLanguage *language) {
        @strongify(self);
        [self.viewModel setTargetSelectedLanguage:language];
    }];
}

- (void)setupViewResizes {
    @weakify(self);
    [[[RACObserve(self.sourceLanguageTableScroll, frame)
        map:^id(NSValue *frameValue) {
            return @(CGRectGetHeight([frameValue rectValue]));
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
            self.viewModel.rowHeight = Height.floatValue / self.viewModel.visibleRowsCount;
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0];
            [self.sourceLanguageTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.viewModel.visibleRowsCount)]];
            [self.targetLanguageTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.viewModel.visibleRowsCount)]];
            [NSAnimationContext endGrouping];
        }];
    
    
    [[[[RACObserve(self.sourceLanguageTableScroll, frame)
        map:^id(NSValue *FrameValue) {
            return @(CGRectGetHeight([FrameValue rectValue]));
        }]
        map:^id(NSNumber *Height) {
            @strongify(self);

            NSUInteger rowsCount = self.viewModel.visibleRowsCount;
        
            if (self.viewModel.visibleRowsCount > 1 && [Height floatValue] / rowsCount < minRowHeight) {
                rowsCount = (NSUInteger)([Height floatValue] / minRowHeight);
            }
            
            if (self.viewModel.visibleRowsCount < maxNumberOfRows && [Height floatValue] / rowsCount > maxRowHeight) {
                rowsCount = (NSUInteger)([Height floatValue] / minRowHeight);
            }
            
            if (rowsCount == 0) {
                rowsCount = 1;
            } else if (rowsCount > maxNumberOfRows) {
                rowsCount = maxNumberOfRows;
            }
            
            self.viewModel.rowHeight = [Height floatValue] / rowsCount;
            
            return @(rowsCount);
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *rowsCount) {
            @strongify(self);
            self.viewModel.visibleRowsCount = [rowsCount unsignedIntegerValue];
        }];
}

#pragma mark - Table Views
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    STLanguageCellModel *cellModel;
    if (tableView == self.sourceLanguageTable) {
        cellModel = self.viewModel.sourceLanguages[row];
    } else {
        cellModel = self.viewModel.targetLanguages[row];
    }
    
    if (cellModel.selected) {
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
    
    return cellModel;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return self.viewModel.rowHeight;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.viewModel.visibleRowsCount;
}

- (void)handleTableViewTap:(NSTableView *)tableView {
    if (tableView == self.sourceLanguageTable) {
        [self.viewModel setSourceSelectedIndex:[self.sourceLanguageTable selectedRow]];
    } else if(tableView == self.targetLanguageTable) {
        [self.viewModel setTargetSelectedIndex:[self.targetLanguageTable selectedRow]];
    }
}

#pragma mark - Button actions
- (IBAction)autoButtonPress:(id)sender {
    [self.viewModel switchAutoButton];
}

- (IBAction)sourceLanguageButtonPress:(id)sender {
    [NSMenu popUpContextMenu:self.sourceLanguageMenu withEvent:NSApp.currentEvent forView:sender];
}

- (IBAction)targetLanguageButtonPress:(id)sender {
    [NSMenu popUpContextMenu:self.targetLanguageMenu withEvent:NSApp.currentEvent forView:sender];
}

- (IBAction)switchLanguagesButtonPress:(id)sender {
    [self.viewModel switchLanguages];
}

@end
