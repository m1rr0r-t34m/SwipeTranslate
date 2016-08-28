//
//  LeftSplitView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLeftSplitView.h"
#import "STLanguageCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import <QuartzCore/QuartzCore.h>

#define NumberOfRows 7

@interface STLeftSplitView () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *sourceLanguageTable;
@property (weak) IBOutlet NSTableView *targetLanguageTable;
@property (weak) IBOutlet NSScrollView *sourceLanguageTableScroll;

@property (strong, nonatomic) NSNumber *LanguageCellHeight;
@property (strong, nonatomic) STLanguageCell *SampleCell;

@end

@implementation STLeftSplitView

#pragma mark - Initialization

-(instancetype)initWithCoder:(NSCoder *)coder {
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
    
    
    [self.sourceLanguageTable setRefusesFirstResponder:YES];
    [self.targetLanguageTable setRefusesFirstResponder:YES];
    [self.sourceLanguageTable reloadData];
    [self.targetLanguageTable reloadData];
}

- (void) setupDelegates {
    [self.sourceLanguageTable setDelegate:self];
    [self.sourceLanguageTable setDataSource:self];
    
    [self.targetLanguageTable setDelegate:self];
    [self.targetLanguageTable setDataSource:self];
}

- (void) setupViewResizes {
    @weakify(self);
    
    [[[RACObserve(self.sourceLanguageTableScroll, frame)
        map:^id(NSValue *frameValue) {
            return @(CGRectGetHeight([frameValue rectValue]));
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
            self.LanguageCellHeight = @(Height.floatValue/NumberOfRows);
            
            
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0];
            [self.sourceLanguageTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, NumberOfRows)]];
            [self.targetLanguageTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, NumberOfRows)]];
            [NSAnimationContext endGrouping];
        }];
    
    
    [[[[[RACObserve(self.SampleCell, frame)
         map:^id(NSValue *FrameValue) {
             return @(CGRectGetHeight([FrameValue rectValue]));
         }]
         map:^id(NSNumber *Height) {
             return @(roundf(Height.floatValue/3));
         }]
         distinctUntilChanged]
         filter:^BOOL(NSNumber *FontSize) {
            
             //TODO: make staging
             CGFloat cellHeight = self.SampleCell.frame.size.height;
             CGFloat previousFontSize = self.SampleCell.Label.font.pointSize;
            
            //return (previousFontSize > 0.7 * cellHeight || previousFontSize < 0.4*cellHeight);
            return YES;
         }]
         subscribeNext:^(NSNumber *FontSize) {
             
            for(int i =0;i<NumberOfRows;i++) {
                
                STLanguageCell *cell = [self.sourceLanguageTable rowViewAtRow:i makeIfNecessary:NO];
                [cell.Label setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:[FontSize integerValue]]];
                [cell.Label setNeedsLayout:YES];
                
                cell = [self.targetLanguageTable rowViewAtRow:i makeIfNecessary:NO];
                [cell.Label setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:[FontSize integerValue]]];
                [cell.Label setNeedsLayout:YES];
            }
        
         }];
}


#pragma mark - Table Views

-(NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    
    STLanguageCell *Cell = [tableView makeViewWithIdentifier:@"languageCell" owner:self];
    
    [Cell setIndex:row];
    
    [Cell.Label setTextColor:[NSColor blackColor]];
    
    if(tableView == self.sourceLanguageTable) {
        if(self.ViewModel.sourceLanguages.count > row)
            [Cell.Label setStringValue:[self.ViewModel.sourceLanguages objectAtIndex:row]];
    }
    else if(tableView == self.targetLanguageTable) {
        if(self.ViewModel.targetLanguages.count > row)
            [Cell.Label setStringValue:[self.ViewModel.targetLanguages objectAtIndex:row]];
    }
    
    self.SampleCell = Cell;
    
    return Cell;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return self.LanguageCellHeight.floatValue;
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return NumberOfRows;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    if(notification.object == self.sourceLanguageTable)
        self.ViewModel.sourceSelectedLanguage = [self.ViewModel.sourceLanguages objectAtIndex:[self.sourceLanguageTable selectedRow]];
    else if(notification.object == self.targetLanguageTable)
        self.ViewModel.targetSelectedLanguage = [self.ViewModel.targetLanguages objectAtIndex:[self.targetLanguageTable selectedRow]];
}


@end
