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

@end

@implementation STRightSplitView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        self.ViewModel = [STRightSplitViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sourceTextView setDelegate:self];
    
    [self.sourceTextView setTextColor:[NSColor blackColor]];
    [self.sourceTextView setFont:[NSFont fontWithName:@"Helvetica Neue Thin" size:19]];
    
    [self setupSourceTextPlaceholder];
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

#pragma mark - Text Views


@end
