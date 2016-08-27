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

#define NumberOfRows 10
#define NSTableViewHeightBug 32

@interface STLeftSplitView () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *sourceLanguageTable;
@property (weak) IBOutlet NSTableView *targetLanguageTable;
@property (weak) IBOutlet NSLayoutConstraint *sourceLanguageTableHeight;
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
    [self setupViewResizes];

    
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
    
    [[[[RACObserve(self.view, frame)
        map:^(NSValue *value) {
           return @(CGRectGetHeight([value rectValue]));
        }]
        distinctUntilChanged] deliverOnMainThread]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
//            NSRect rect = self.sourceLanguageTableScroll.frame;
//            
//            rect.size.height = [Height floatValue]*0.4;
//            [self.sourceLanguageTableScroll setFrame:rect];
            
            
//            [self.sourceLanguageTableHeight setConstant:[Height floatValue]*0.4];
//            [self.sourceLanguageTableScroll setNeedsLayout:YES];
            //[self.sourceLanguageTable setNeedsLayout:YES];
        }];
    
    [[[RACObserve(self.sourceLanguageTableScroll, frame)
        map:^id(NSValue *frameValue) {
            return @(CGRectGetHeight([frameValue rectValue]));
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
            self.LanguageCellHeight = @((Height.floatValue - NSTableViewHeightBug)/NumberOfRows);
            
            
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
             return @(roundf(Height.floatValue/2));
         }]
         distinctUntilChanged]
         filter:^BOOL(NSNumber *FontSize) {
            
             CGFloat cellHeight = self.SampleCell.frame.size.height;
             CGFloat previousFontSize = self.SampleCell.Label.font.pointSize;
            
            //return (previousFontSize > 0.7 * cellHeight || previousFontSize < 0.4*cellHeight);
            return YES;
         }]
         subscribeNext:^(NSNumber *FontSize) {
            for(int i =0;i<NumberOfRows;i++) {
                STLanguageCell *cell = [self.sourceLanguageTable viewAtColumn:0 row:i makeIfNecessary:NO];
                [cell.Label setFont:[NSFont fontWithName:@"Helvetica Neue Thin" size:[FontSize integerValue]]];
            }
        
         
         
         //        // Cell.Label.transform = CGAffineTransformScale(Cell.Label.transform, 0.25, 0.25);
         //
         //         CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"frame"];
         //
         //         fadeAnim.fromValue = [NSValue valueWithRect:Cell.layer.frame];
         //
         //         NSRect cellRect = Cell.layer.frame;
         //         cellRect.size.height = FontSize.integerValue;
         //
         //         fadeAnim.toValue = [NSValue valueWithRect:cellRect];
         //         fadeAnim.duration = 0.2;
         //         [Cell.layer addAnimation:fadeAnim forKey:@"frame"];
         //
         //         // Change the actual data value in the layer to the final value.
         //         Cell.Label.layer.frame =cellRect;
         
         
         
         
     }];
    
    
}


#pragma mark - Table Views


-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    STLanguageCell *Cell = [tableView makeViewWithIdentifier:@"languageCell" owner:self];
    

    [Cell.Label setTextColor:[NSColor blackColor]];
    
    [Cell.Label setStringValue:@"English"];
    
    
    
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
    if(tableView == self.sourceLanguageTable || tableView == self.targetLanguageTable)
        return NumberOfRows;
    
    return 0;
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    if(notification.object == self.sourceLanguageTable)
        self.ViewModel.sourceSelectedLanguage = [self.ViewModel.sourceLanguages objectAtIndex:[self.sourceLanguageTable selectedRow]];
    else if(notification.object == self.targetLanguageTable)
        self.ViewModel.targetSelectedLanguage = [self.ViewModel.targetLanguages objectAtIndex:[self.targetLanguageTable selectedRow]];
}

@end
