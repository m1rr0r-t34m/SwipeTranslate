//
//  RightSplitView.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STRightSplitView.h"
#import <ReactiveObjC.h>
#import "STDraggableView.h"
#import "STSidebarAnimator.h"
#import <QuartzCore/CAMediaTimingFunction.h>

@interface STRightSplitView () <NSTextViewDelegate>
@property (unsafe_unretained) IBOutlet NSTextView *sourceTextView;
@property (unsafe_unretained) IBOutlet NSTextView *targetTextView;
@property (weak) IBOutlet NSTextField *placeholderLabel;
@property (weak) IBOutlet NSButton *clearButton;
@property (strong, nonatomic) NSNumber *clearPressed;
@property (strong) IBOutlet NSView *favouritesContainer;
@property (strong) IBOutlet NSLayoutConstraint *favouritesContainerRight;
@property (strong, nonatomic) STSidebarAnimator *sidebarAnimator;
@end

static CGFloat leftFavouritesMenuConstant = -100;
static CGFloat rightFavouritesMenuConstant = -400;

@implementation STRightSplitView
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        _viewModel = [STRightSplitViewModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.favouritesContainer.wantsLayer = YES;
    self.favouritesContainer.layer.backgroundColor = [NSColor greenColor].CGColor;
    self.view.acceptsTouchEvents = YES;
    self.view.wantsRestingTouches = YES;
    self.view.allowedTouchTypes = NSTouchTypeDirect | NSTouchTypeIndirect;
    [self.sourceTextView setDelegate:self];
    
    [self.sourceTextView setTextColor:[NSColor blackColor]];
    [self.sourceTextView setFont:[NSFont fontWithName:@"Helvetica Neue Thin" size:24]];
    
    [self bindViewModel];
    [self setupSourceTextView];
    [self setupFavouritesMenu];
}

- (void)setupSourceTextView {
    
    RACSignal *PlaceholderAlphaSignal =
    [[RACObserve(self.viewModel, inputText)
        map:^id(NSString *Text) {
            return @(Text.length == 0);
        }]
        distinctUntilChanged];
    
    RAC(self.placeholderLabel, alphaValue) = PlaceholderAlphaSignal;
    
    @weakify(self);
    
    RACSignal *SourceTextViewElasticitySignal =
    [[RACObserve(self.viewModel, inputText) merge:RACObserve(self, clearPressed)]
     map:^id(id value) {
         @strongify(self);
         
         unsigned long numberOfLines, index, numberOfGlyphs = [self.sourceTextView.layoutManager numberOfGlyphs];
         NSRange lineRange;
         
         for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
             [self.sourceTextView.layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
             index = NSMaxRange(lineRange);
         }
         
         if([self.sourceTextView.string containsString:@"\n"] || numberOfLines > 1) {
             return @(NSScrollElasticityAllowed);
         } else {
             return @(NSScrollElasticityNone);
         }
     }];
    
    RAC(self.sourceTextView.enclosingScrollView, verticalScrollElasticity) = SourceTextViewElasticitySignal;
}

- (void)bindViewModel {
    RAC(self.viewModel, inputText) = self.sourceTextView.rac_textSignal;
    
    @weakify(self);
    [[RACObserve(self.viewModel, outputText) ignore:nil] subscribeNext:^(NSAttributedString *modelText) {
        @strongify(self);
        self.targetTextView.textStorage.attributedString = modelText;
    }];
}

- (void)setupFavouritesMenu {
    self.favouritesContainerRight.constant = rightFavouritesMenuConstant;
    self.sidebarAnimator = [[STSidebarAnimator alloc] initWithDraggableView:(STDraggableView *)self.view
                                                            rightConstraint:rightFavouritesMenuConstant
                                                             leftConstraint:leftFavouritesMenuConstant
                                                        andCurrentCostraint:self.favouritesContainerRight.constant];
    
    @weakify(self);
    [self.sidebarAnimator.updateSignal subscribeNext:^(STSidebarAnimatorUpdate *update) {
        @strongify(self);

        self.favouritesContainerRight.constant = update.constant;
        
        if (!update.animated) {
            [self.view layoutSubtreeIfNeeded];
        } else {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                context.allowsImplicitAnimation = YES;
                context.duration = update.duration;
                context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [self.view layoutSubtreeIfNeeded];
            } completionHandler:nil];
        }
    }];
}

- (IBAction)clearButtonPress:(id)sender {
    [self.viewModel setInputText:@""];
    self.clearPressed = @(YES);
}
@end
