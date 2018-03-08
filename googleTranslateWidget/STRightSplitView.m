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
#import <QuartzCore/CATransaction.h>
#import "STFavouriteUpdate.h"

@interface STRightSplitView () <NSTextViewDelegate, NSTableViewDataSource, NSTableViewDelegate>
@property (strong) IBOutlet NSProgressIndicator *activityIndicator;
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
    
    self.favouritesTableView.target = self;
    self.favouritesTableView.action = @selector(handleTableViewTap);
}

#pragma mark - Setup
- (void)setupSourceTextView {
    RACSignal *placeholderAlphaSignal = [[RACObserve(self.viewModel, inputText) map:^id(NSString *Text) {
        return @(Text.length == 0);
    }] distinctUntilChanged];
    
    RAC(self.placeholderLabel, alphaValue) = placeholderAlphaSignal;
    
    @weakify(self);
    
    RACSignal *sourceTextViewElasticitySignal =
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
    
    RAC(self.sourceTextView.enclosingScrollView, verticalScrollElasticity) = sourceTextViewElasticitySignal;
}

- (void)setupFavouritesMenu {
    self.favouritesContainerRight.constant = rightFavouritesMenuConstant;
    
    self.favouritesTableView.refusesFirstResponder = YES;
    self.favouritesTableView.focusRingType = NSFocusRingTypeNone;
    self.favouritesContainer.wantsLayer = YES;
    self.favouritesContainer.layer.backgroundColor = [NSColor grayColor].CGColor;
    self.favouritesContainer.layer.zPosition = 1;
    
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

- (void)bindViewModel {
    @weakify(self);
    [[self.sourceTextView.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString *text) {
        @strongify(self);
        [self.viewModel setSourceText:text];
        [self.favouritesTableView deselectAll:nil];
    }];
    
    [[[RACObserve(self.viewModel, inputText) ignore:nil] distinctUntilChanged] subscribeNext:^(NSString *text) {
        @strongify(self);
        if (![text isEqual:self.sourceTextView.string]) {
            self.sourceTextView.string = text;
        }
    }];
    
    [[RACObserve(self.viewModel, outputText) ignore:nil] subscribeNext:^(NSAttributedString *modelText) {
        @strongify(self);
        self.targetTextView.textStorage.attributedString = modelText;
    }];
    
    RAC(self.favouriteButton, hidden) = [RACObserve(self.viewModel, canSaveOrRemoveCurrentTranslation) not];
    RAC(self.favouriteButton, image) = [RACObserve(self.viewModel, currentTranslationIsSaved) map:^id (NSNumber *saved) {
        if (saved.boolValue) {
            return [NSImage imageNamed:@"FavouritesButtonPressed"];
        } else {
            return [NSImage imageNamed:@"FavouritesButton"];
        }
    }];
    
    [RACObserve(self.viewModel, currentTranslationIsSaved) subscribeNext:^(NSNumber *saved) {
        @strongify(self);
        if (saved.boolValue) {
            NSInteger index = [self.viewModel indexOfCurrentTranslation];
            if (index != -1) {
                [self.favouritesTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
            }
        } else {
            [self.favouritesTableView deselectAll:nil];
        }
    }];
    
    [RACObserve(self.viewModel, translating) subscribeNext:^(NSNumber *translating) {
        @strongify(self);
        if (translating.boolValue) {
            [self.activityIndicator startAnimation:nil];
        } else {
            [self.activityIndicator stopAnimation:nil];
        }
        self.activityIndicator.hidden = !translating.boolValue;
    }];
    
    [self.viewModel.favouritesUpdateSignal subscribeNext:^(STFavouriteUpdate *update) {
        @strongify(self);
        if (update.type == STFavouriteUpdateTypeReload) {
            [self.favouritesTableView reloadData];
        } else {
            [CATransaction begin];
            [self.favouritesTableView beginUpdates];
            
            if (update.type == STFavouriteUpdateTypeRemove) {
                [self.favouritesTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:update.index] withAnimation:NSTableViewAnimationSlideRight];
            } else {
                [self.favouritesTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:update.index] withAnimation:NSTableViewAnimationSlideDown | NSTableViewAnimationEffectFade];
            }
            
            [self.favouritesTableView endUpdates];
            [CATransaction commit];
        }
    }];
}

#pragma mark - Favourites table view
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.viewModel.favouriteViewModels.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return self.viewModel.favouriteViewModels[row];
}

- (void)handleTableViewTap {
    NSInteger index = self.favouritesTableView.clickedRow;
    
    if (index == -1 && self.viewModel.favouritesSelectedIndex == -1) {
        //Do nothing
    } else if (index == self.viewModel.favouritesSelectedIndex || index == -1) {
        [self.favouritesTableView deselectAll:nil];
        [self.viewModel showSavedTranslation:-1];
    } else {
        [self.viewModel showSavedTranslation:index];
    }
}

#pragma mark - Button press
- (IBAction)clearButtonPress:(id)sender {
    [self.viewModel setInputText:@""];
    self.clearPressed = @(YES);
}

- (IBAction)favouriteButtonPress:(id)sender {
    [self.viewModel saveOrRemoveCurrentTranslation];
}
@end
