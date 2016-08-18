//
//  MainViewController.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "MainViewController.h"
#import "STLanguageCell.h"
#import "NSTextView+Ready.h"

#define LanguageCellHeight 50
#define PlaceholderInputText @"Input some text"

@interface MainViewController () <NSTextViewDelegate>

@property (weak) IBOutlet NSTableView *sourceLanguageTableView;
@property (weak) IBOutlet NSTableView *targetLanguageTableView;
@property (weak) IBOutlet NSLayoutConstraint *sourceLanguageTableViewHeight;
@property (unsafe_unretained) IBOutlet NSTextView *SourceTextView;

@property (strong, nonatomic) NSValue *SelectedRange;



@end

@implementation MainViewController

-(instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        self.ViewModel = [MainViewControllerModel new];

    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sourceLanguageTableView setDelegate:self];
    [self.sourceLanguageTableView setDataSource:self];
    
    [self.targetLanguageTableView setDelegate:self];
    [self.targetLanguageTableView setDataSource:self];
    
    [self.SourceTextView setDelegate:self];
    
    [self.sourceLanguageTableView reloadData];
    [self.targetLanguageTableView reloadData];
    
    [self bindAll];
}





- (void) bindAll {
    
    @weakify(self);
    
    [[[[RACSignal
        merge:@[RACObserve(self.view, frame), RACObserve(self.view, bounds)]]
        map:^(NSValue *value) {
            return @(CGRectGetHeight([value rectValue]));
        }]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
            
            [self.sourceLanguageTableViewHeight setConstant:[Height floatValue]/2];
        }];
    
    
    
    [[RACObserve(self.sourceLanguageTableViewHeight, constant)
        distinctUntilChanged]
        subscribeNext:^(NSNumber *Height) {
            @strongify(self);
         
            [self.sourceLanguageTableView reloadData];
            [self.targetLanguageTableView reloadData];
        }];
    
    
    
    
    [[[self.SourceTextView.rac_textSignal
        filter:^BOOL(NSString *Text) {
            return Text.length == 0;
        }]
        map:^id(NSString *Text) {
            return PlaceholderInputText;
        }]
        subscribeNext:^(NSString *Text) {
            @strongify(self);
            [self.SourceTextView setString:PlaceholderInputText];
            [self.SourceTextView setTextColor:[NSColor grayColor]];
            [self.SourceTextView setSelectedRange:NSMakeRange(0, 0)];
        }];
    
    
    [[[[[self.SourceTextView.rac_textSignal
        map:^id(NSString *Text) {
           return @(Text.length == 0 || [Text isEqualToString:PlaceholderInputText]);
        }]
        distinctUntilChanged]
        skip:1]
        filter:^BOOL(NSNumber *Placeholded) {
            return ![Placeholded boolValue];
        }]
        subscribeNext:^(NSNumber *Placeholded) {
            @strongify(self);
            
            [self.SourceTextView setTextColor:[NSColor blackColor]];
            [self.SourceTextView setString:[self.SourceTextView.string substringFromIndex:PlaceholderInputText.length]];
        }];
    
    
    

}



-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    STLanguageCell *cell = [tableView makeViewWithIdentifier:@"languageCell" owner:self];
    [cell.Label setTextColor:[NSColor blackColor]];
    
    [cell.Label setStringValue:@"English"];
    
    if(tableView == self.sourceLanguageTableView) {
        if(self.ViewModel.sourceLanguages.count > row)
            [cell.Label setStringValue:[self.ViewModel.sourceLanguages objectAtIndex:row]];
    }
    else if(tableView == self.targetLanguageTableView) {
        if(self.ViewModel.targetLanguages.count > row)
            [cell.Label setStringValue:[self.ViewModel.targetLanguages objectAtIndex:row]];
    }
    
    
    
    return cell;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if(tableView == self.sourceLanguageTableView || tableView == self.targetLanguageTableView)
        return (NSUInteger)self.sourceLanguageTableViewHeight.constant/LanguageCellHeight;
    
    
    return 0;
}



- (NSRange)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange {
    if(aTextView == self.SourceTextView && [aTextView.string isEqualToString:PlaceholderInputText])
        return NSMakeRange(0, 0);
    
    return newSelectedCharRange;

}

@end
