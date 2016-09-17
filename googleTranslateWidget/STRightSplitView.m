//
//  RightSplitView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STRightSplitView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface STRightSplitView () <NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *sourceTextView;
@property (unsafe_unretained) IBOutlet NSTextView *targetTextView;
@property (weak) IBOutlet NSTextField *placeholderLabel;
@property (weak) IBOutlet NSButton *clearButton;
@property (strong, nonatomic) NSNumber *clearPressed;

@end

@implementation STRightSplitView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        _ViewModel = [STRightSplitViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sourceTextView setDelegate:self];
    
    [self.sourceTextView setTextColor:[NSColor blackColor]];
    [self.sourceTextView setFont:[NSFont fontWithName:@"Helvetica Neue Thin" size:24]];
    
    [self bindViewModel];
    [self setupSourceTextView];
}

- (void)setupSourceTextView {
    
    RACSignal *PlaceholderAlphaSignal =
    [[RACObserve(self.ViewModel, inputText)
        map:^id(NSString *Text) {
            return @(Text.length == 0);
        }]
        distinctUntilChanged];
    
    RAC(self.placeholderLabel, alphaValue) = PlaceholderAlphaSignal;
    
    @weakify(self);
    
    RACSignal *SourceTextViewElasticitySignal =
    [[RACObserve(self.ViewModel, inputText) merge:RACObserve(self, clearPressed)]
     map:^id(id value) {
         @strongify(self);
         
         unsigned long numberOfLines, index, numberOfGlyphs = [self.sourceTextView.layoutManager numberOfGlyphs];
         NSRange lineRange;
         
         for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
             [self.sourceTextView.layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
             index = NSMaxRange(lineRange);
         }
         
         if([self.sourceTextView.string containsString:@"\n"] || numberOfLines > 1)
             return @(NSScrollElasticityAllowed);
         else
             return @(NSScrollElasticityNone);
     }];
    
    RAC(self.sourceTextView.enclosingScrollView, verticalScrollElasticity) = SourceTextViewElasticitySignal;
}

- (void)bindViewModel {
    RAC(self.ViewModel, inputText) = self.sourceTextView.rac_textSignal;
    
    [RACObserve(self.ViewModel, inputText) subscribeNext:^(NSString *ModelText) {
        self.sourceTextView.string = ModelText;
    }];
}

- (IBAction)clearButtonPress:(id)sender {
    [self.ViewModel setInputText:@""];
    self.clearPressed = @(YES);
}

#pragma mark - Text Views


@end
