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

@interface STRightSplitView () <NSTextViewDelegate, NSTableViewDataSource, NSTableViewDelegate>
@property (strong) IBOutlet NSButton *favouriteButton;
@property (unsafe_unretained) IBOutlet NSTextView *sourceTextView;
@property (unsafe_unretained) IBOutlet NSTextView *targetTextView;
@property (weak) IBOutlet NSTextField *placeholderLabel;
@property (weak) IBOutlet NSButton *clearButton;
@property (strong, nonatomic) NSNumber *clearPressed;
@property (strong) IBOutlet NSView *favouritesContainer;
@property (strong) IBOutlet NSLayoutConstraint *favouritesContainerRight;
@property (strong) IBOutlet NSTableView *favouritesTableView;
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
    

    self.view.acceptsTouchEvents = YES;
    self.view.wantsRestingTouches = YES;
    self.view.allowedTouchTypes = NSTouchTypeDirect | NSTouchTypeIndirect;
    [self.sourceTextView setDelegate:self];
    
    [self.sourceTextView setTextColor:[NSColor blackColor]];
    [self.sourceTextView setFont:[NSFont fontWithName:@"Helvetica Neue Thin" size:24]];
    
    [self bindViewModel];
    [self setupSourceTextView];
    [self setupFavouritesMenu];
    
    self.favouritesTableView.backgroundColor = [NSColor clearColor];
    self.favouritesTableView.enclosingScrollView.backgroundColor = [NSColor clearColor];
    [self.favouritesTableView setFocusRingType:NSFocusRingTypeNone];
    [self.favouritesTableView setRefusesFirstResponder:YES];
    self.favouritesContainer.layer.zPosition = 1;
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.viewModel.favouriteViewModels.count;
}
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    return self.viewModel.favouriteViewModels[row];
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

- (IBAction)favouriteButtonPress:(id)sender {
    [self.viewModel saveFavouriteTranslation];
}
@end
