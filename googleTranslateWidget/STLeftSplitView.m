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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <QuartzCore/QuartzCore.h>

#define NumberOfRows 5

static CGFloat minRowHeight = 40;
static CGFloat maxRowHeight = 60;
static NSUInteger maxNumberOfRows = 10;

@interface STLeftSplitView () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *sourceLanguageTable;
@property (weak) IBOutlet NSTableView *targetLanguageTable;
@property (weak) IBOutlet NSScrollView *sourceLanguageTableScroll;

@property (strong, nonatomic) NSNumber *LanguageCellHeight;
@property (strong, nonatomic) STLanguageCell *SampleCell;
@property (strong) IBOutlet NSTextFieldCell *fromTextField;
@property (strong) IBOutlet NSTextFieldCell *toTextField;

@end

@implementation STLeftSplitView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self  = [super initWithCoder:coder]) {
        _ViewModel = [STLeftSplitViewModel new];
        _LanguageCellHeight = @(50);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDelegates];
    
    
    //TODO: SMTHG MORE CLEVER??
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupViewResizes];
    });
    
//    @weakify(self);
//    [[RACObserve(self.ViewModel, sourceSelectedLanguage) ignore:nil] subscribeNext:^(NSString *selectedLanguage) {
//        @strongify(self);
//        self.fromTextField.stringValue = selectedLanguage;
//    }];
//    
//    [[RACObserve(self.ViewModel, targetSelectedLanguage) ignore:nil] subscribeNext:^(NSString *selectedLanguage) {
//        @strongify(self);
//        self.toTextField.stringValue = selectedLanguage;
//    }];
    
    
    
    
    [self.sourceLanguageTable setRefusesFirstResponder:YES];
    [self.targetLanguageTable setRefusesFirstResponder:YES];
    [self.sourceLanguageTable reloadData];
    [self.targetLanguageTable reloadData];
}

- (void)setupDelegates {
    [self.sourceLanguageTable setDelegate:self];
    [self.sourceLanguageTable setDataSource:self];
    
    [self.targetLanguageTable setDelegate:self];
    [self.targetLanguageTable setDataSource:self];
}

- (void)setupViewResizes {
    @weakify(self);
    
    [self.ViewModel.dataReloadSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.sourceLanguageTable reloadData];
        [self.targetLanguageTable reloadData];
    }];

    
    
//    [[[[[RACObserve(self.SampleCell, frame)
//         map:^id(NSValue *FrameValue) {
//             return @(CGRectGetHeight([FrameValue rectValue]));
//         }]
//         map:^id(NSNumber *Height) {
//             return @(roundf(Height.floatValue/3));
//         }]
//         distinctUntilChanged]
//         filter:^BOOL(NSNumber *FontSize) {
//            
////             //TODO: make staging
////             CGFloat cellHeight = self.SampleCell.frame.size.height;
////             CGFloat previousFontSize = self.SampleCell.Label.font.pointSize;
////            
////            return (previousFontSize > 0.7 * cellHeight || previousFontSize < 0.4*cellHeight);
//            return YES;
//         }]
//         subscribeNext:^(NSNumber *FontSize) {
//             
//            for(int i =0;i<self.ViewModel.visibleLanguagesCount;i++) {
//                
//                STLanguageCell *cell = [self.sourceLanguageTable rowViewAtRow:i makeIfNecessary:NO];
//                [cell.Label setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:[FontSize integerValue]]];
//                [cell.Label setNeedsLayout:YES];
//                
//                cell = [self.targetLanguageTable rowViewAtRow:i makeIfNecessary:NO];
//                [cell.Label setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:[FontSize integerValue]]];
//                [cell.Label setNeedsLayout:YES];
//            }
//        
//         }];
    
//    [[[[[RACObserve(self.SampleCell, frame)
//        map:^id(NSValue *FrameValue) {
//            return @(CGRectGetHeight([FrameValue rectValue]));
//        }]
//        map:^id(NSNumber *Height) {
//            return @(roundf(Height.floatValue/3));
//        }]
//        distinctUntilChanged]
//        filter:^BOOL(NSNumber *FontSize) {
//          
//            //TODO: make staging
//            CGFloat cellHeight = self.SampleCell.frame.size.height;
//            CGFloat previousFontSize = self.SampleCell.Label.font.pointSize;
//          
//            //return (previousFontSize > 0.7 * cellHeight || previousFontSize < 0.4*cellHeight);
//            return YES;
//        }]
//        subscribeNext:^(NSNumber *FontSize) {
//         
//         for(int i =0;i<NumberOfRows;i++) {
//             //
//             //                STLanguageCell *cell = [self.sourceLanguageTable rowViewAtRow:i makeIfNecessary:NO];
//             //                [cell.Label setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:[FontSize integerValue]]];
//             //                [cell.Label setNeedsLayout:YES];
//             //
//             //                cell = [self.targetLanguageTable rowViewAtRow:i makeIfNecessary:NO];
//             //                [cell.Label setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:[FontSize integerValue]]];
//             //                [cell.Label setNeedsLayout:YES];
//         }
//         
//     }];
    
    [[[RACObserve(self.sourceLanguageTableScroll, frame)
        map:^id(NSValue *frameValue) {
            return @(CGRectGetHeight([frameValue rectValue]));
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
            self.ViewModel.rowHeight = Height.floatValue / self.ViewModel.visibleLanguagesCount;
         
         
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0];
            [self.sourceLanguageTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.ViewModel.visibleLanguagesCount)]];
            [self.targetLanguageTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.ViewModel.visibleLanguagesCount)]];
            [NSAnimationContext endGrouping];
        }];
    
    
    [[[[RACObserve(self.sourceLanguageTableScroll, frame)
        map:^id(NSValue *FrameValue) {
            return @(CGRectGetHeight([FrameValue rectValue]));
        }]
        map:^id(NSNumber *Height) {
            @strongify(self);

            NSUInteger rowsCount = self.ViewModel.visibleLanguagesCount;
        
            if (self.ViewModel.visibleLanguagesCount > 1 && [Height floatValue] / rowsCount < minRowHeight) {
                rowsCount = (NSUInteger)([Height floatValue] / minRowHeight);
            }
            
            if (self.ViewModel.visibleLanguagesCount < maxNumberOfRows && [Height floatValue] / rowsCount > maxRowHeight) {
                rowsCount = (NSUInteger)([Height floatValue] / minRowHeight);
            }
            
            
            if (rowsCount == 0) {
                rowsCount = 1;
            } else if (rowsCount > maxNumberOfRows) {
                rowsCount = maxNumberOfRows;
            }
            
            self.ViewModel.rowHeight = [Height floatValue] / rowsCount;
            
            return @(rowsCount);
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *rowsCount) {
            @strongify(self);
            self.ViewModel.visibleLanguagesCount = [rowsCount unsignedIntegerValue];
        }];
}


#pragma mark - Table Views

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    
    STLanguageCell *Cell = [tableView makeViewWithIdentifier:@"languageCell" owner:self];
    STLanguageCellModel *cellModel;
    
    if (tableView == self.sourceLanguageTable) {
        cellModel = self.ViewModel.sourceLanguages[row];
    } else if (tableView == self.targetLanguageTable) {
        cellModel = self.ViewModel.targetLanguages[row];
    }
    
    [Cell setViewModel:cellModel];
    [Cell.Label setTextColor:[NSColor blackColor]];
    [Cell.Label setStringValue:cellModel.title];
    
    if (cellModel.selected) {
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
    
    
    self.SampleCell = Cell;
    
    return Cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return self.ViewModel.rowHeight;
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.ViewModel.visibleLanguagesCount;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    if (notification.object == self.sourceLanguageTable) {
        [self.ViewModel setSourceSelected:[[self sourceLanguageTable] selectedRow]];
    } else if(notification.object == self.targetLanguageTable) {
        [self.ViewModel setTargetSelected:[[self targetLanguageTable] selectedRow]];
    }
}


@end
