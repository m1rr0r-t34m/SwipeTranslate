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
    
    [self setupSourceTextPlaceholder];
    [self setupSourceTextScrolling];
    [self bindViewModel];
}

- (void) setupSourceTextPlaceholder {
    @weakify(self);
    
    [[self.sourceTextView.rac_textSignal
        filter:^BOOL(NSString *Text) {
            @strongify(self);
            return (Text.length == 0 && self.placeholderLabel.alphaValue == 0);
        }]
        subscribeNext:^(NSString *Text) {
            @strongify(self);
            [self.placeholderLabel setAlphaValue:1.0];
        }];
    
    [[self.sourceTextView.rac_textSignal
        filter:^BOOL(NSString *Text) {
            @strongify(self);
            return (Text.length !=0 && self.placeholderLabel.alphaValue != 0);
        }]
        subscribeNext:^(NSString *Text) {
            @strongify(self);
            [self.placeholderLabel setAlphaValue:0.0];
        }];
}

- (void) setupSourceTextScrolling {
    @weakify(self);
    
    [[self.sourceTextView.rac_textSignal merge:RACObserve(self, clearPressed)]
        subscribeNext:^(id x) {
            @strongify(self);
            
            unsigned long numberOfLines, index, numberOfGlyphs = [self.sourceTextView.layoutManager numberOfGlyphs];
            NSRange lineRange;
            
            for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
                (void) [self.sourceTextView.layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
                index = NSMaxRange(lineRange);
            }
            
            if([self.sourceTextView.string containsString:@"\n"] || numberOfLines > 1)
                [self.sourceTextView.enclosingScrollView setVerticalScrollElasticity:NSScrollElasticityAllowed];
            else
                [self.sourceTextView.enclosingScrollView setVerticalScrollElasticity:NSScrollElasticityNone];
        }];
    

}

-(void)bindViewModel {
    RAC(self.ViewModel, inputText) = self.sourceTextView.rac_textSignal;
    
}
- (IBAction)clearButtonPress:(id)sender {
    [self.sourceTextView setString:@""];
    self.clearPressed = @(YES);
    
}

#pragma mark - Text Views


@end
