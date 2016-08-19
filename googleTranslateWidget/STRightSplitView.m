//
//  RightSplitView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STRightSplitView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define PlaceholderInputText @"Input some text"

@interface STRightSplitView () <NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *sourceTextView;
@property (unsafe_unretained) IBOutlet NSTextView *targetTextView;

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
    [self setupSourceTextPlaceholder];
}

- (void) setupSourceTextPlaceholder {
    @weakify(self);
    
    [[[self.sourceTextView.rac_textSignal
        filter:^BOOL(NSString *Text) {
            return Text.length == 0;
        }]
        map:^id(NSString *Text) {
            return PlaceholderInputText;
        }]
        subscribeNext:^(NSString *Text) {
            @strongify(self);
            [self.sourceTextView setString:PlaceholderInputText];
            [self.sourceTextView setTextColor:[NSColor grayColor]];
            [self.sourceTextView setSelectedRange:NSMakeRange(0, 0)];
        }];
    
    [[[[[self.sourceTextView.rac_textSignal
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
         
            [self.sourceTextView setTextColor:[NSColor blackColor]];
            [self.sourceTextView setString:[self.sourceTextView.string substringFromIndex:PlaceholderInputText.length]];
        }];
}

#pragma mark - Text Views

- (NSRange)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange {
    if(aTextView == self.sourceTextView && [aTextView.string isEqualToString:PlaceholderInputText])
        return NSMakeRange(0, 0);
    
    return newSelectedCharRange;
    
}

@end
