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
@property (strong, nonatomic) STLanguageCell *sampleCell;
@property (strong) IBOutlet NSTextFieldCell *fromTextField;
@property (strong) IBOutlet NSTextFieldCell *toTextField;
@property (strong, nonatomic) IBOutlet NSButton *autoLanguageButton;
@property (strong, nonatomic) IBOutlet NSButton *SourceLanguageButton;

@property (weak) IBOutlet NSTextField *sourceLanguageTitleTextField;
@property (weak) IBOutlet NSTextField *targetLanguageTitleTextField;

@end

@implementation STLeftSplitView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self  = [super initWithCoder:coder]) {
        _viewModel = [STLeftSplitViewModel new];
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
    
    @weakify(self);
    [RACObserve(self.viewModel, sourceSelectedTitle) subscribeNext:^(NSString *title) {
        @strongify(self);
        self.sourceLanguageTitleTextField.stringValue = title;
    }];
    
    [RACObserve(self.viewModel, targetSelectedTitle) subscribeNext:^(NSString *title) {
        @strongify(self);
        self.targetLanguageTitleTextField.stringValue = title;
    }];
}

- (void)setupDelegates {
    //TODO: Use storyboard
    [self.sourceLanguageTable setDelegate:self];
    [self.sourceLanguageTable setDataSource:self];
    
    [self.targetLanguageTable setDelegate:self];
    [self.targetLanguageTable setDataSource:self];
}

- (void)setupViewResizes {
    @weakify(self);
    
    [self.viewModel.dataReloadSignal subscribeNext:^(id x) {
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
- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    STLanguageCell *cell = [tableView makeViewWithIdentifier:@"languageCell" owner:self];
    STLanguageCellModel *cellModel;
    
    if (tableView == self.sourceLanguageTable) {
        cellModel = self.viewModel.sourceLanguages[row];
    } else if (tableView == self.targetLanguageTable) {
        cellModel = self.viewModel.targetLanguages[row];
    }
    
    [cell setViewModel:cellModel];
    [cell.Label setTextColor:[NSColor blackColor]];
    [cell.Label setStringValue:cellModel.title];
    
    if (cellModel.selected) {
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
    
    self.sampleCell = cell;
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return self.viewModel.rowHeight;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.viewModel.visibleRowsCount;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if (notification.object == self.sourceLanguageTable) {
        [self.viewModel setSourceSelected:[[self sourceLanguageTable] selectedRow]];
    } else if(notification.object == self.targetLanguageTable) {
        [self.viewModel setTargetSelected:[[self targetLanguageTable] selectedRow]];
    }
}

#pragma mark - Button actions
- (IBAction)autoButtonPress:(id)sender {
    [self.viewModel switchAutoButton];
}

- (IBAction)sourceLanguageButtonPress:(id)sender {
    //TODO: create menu
}

@end
