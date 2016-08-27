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

#define LanguageCellHeight 50

@interface STLeftSplitView () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *sourceLanguageTable;
@property (weak) IBOutlet NSTableView *targetLanguageTable;
@property (weak) IBOutlet NSLayoutConstraint *sourceLanguageTableHeight;

@end

@implementation STLeftSplitView

#pragma mark - Initialization

-(instancetype)initWithCoder:(NSCoder *)coder {
    if(self  = [super initWithCoder:coder]) {
        self.ViewModel = [STLeftSplitViewModel new];
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
    
    [[[[RACSignal
        merge:@[RACObserve(self.view, frame), RACObserve(self.view, bounds)]]
        map:^(NSValue *value) {
           return @(CGRectGetHeight([value rectValue]));
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
            [self.sourceLanguageTableHeight setConstant:[Height floatValue]*0.4];
        }];
    
    [[RACObserve(self.sourceLanguageTableHeight, constant)
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
         
            [self.sourceLanguageTable reloadData];
            [self.targetLanguageTable reloadData];
        }];
}


#pragma mark - Table Views

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    STLanguageCell *cell = [tableView makeViewWithIdentifier:@"languageCell" owner:self];
    [cell.Label setTextColor:[NSColor blackColor]];
    
    [cell.Label setStringValue:@"English"];
    
    if(tableView == self.sourceLanguageTable) {
        if(self.ViewModel.sourceLanguages.count > row)
            [cell.Label setStringValue:[self.ViewModel.sourceLanguages objectAtIndex:row]];
    }
    else if(tableView == self.targetLanguageTable) {
        if(self.ViewModel.targetLanguages.count > row)
            [cell.Label setStringValue:[self.ViewModel.targetLanguages objectAtIndex:row]];
    }
    
    
    
    return cell;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if(tableView == self.sourceLanguageTable || tableView == self.targetLanguageTable)
        return (NSUInteger)self.sourceLanguageTableHeight.constant/LanguageCellHeight;
    
    
    return 0;
}

@end
