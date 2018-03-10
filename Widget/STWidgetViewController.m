//
//  STWidgetViewController.m
//  Widget
//
//  Created by Mark Vasiv on 09/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STWidgetViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "STWidgetViewModel.h"
#import <ReactiveObjC.h>
#import "STLanguage.h"
#import "STLanguageMenu.h"

@interface STWidgetViewController () <NCWidgetProviding>
@property (strong) IBOutlet NSSegmentedControl *sourceSegmentedControl;
@property (strong) IBOutlet NSSegmentedControl *targetSegmentedControl;
@property (strong) IBOutlet NSButton *swapButton;
@property (strong) IBOutlet NSTextView *inputTextView;
@property (strong) IBOutlet NSTextView *outputTextView;
@property (strong, nonatomic) STWidgetViewModel *viewModel;
@property (strong, nonatomic) STLanguageMenu *sourceLanguageMenu;
@property (strong, nonatomic) STLanguageMenu *targetLanguageMenu;
@end

@implementation STWidgetViewController
#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [STWidgetViewModel new];
    
    [self setupMenus];
    [self bindViewModel];
    
    self.sourceSegmentedControl.target = self;
    self.sourceSegmentedControl.action = @selector(sourcePressed:);
    
    self.targetSegmentedControl.target = self;
    self.targetSegmentedControl.action = @selector(targetPressed:);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidMove:) name:NSWindowDidMoveNotification object:self.view.window];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup
- (void)setupMenus {
    self.sourceLanguageMenu = [[STLanguageMenu alloc] initWithLanguagesService:self.viewModel.languagesService];
    self.targetLanguageMenu = [[STLanguageMenu alloc] initWithLanguagesService:self.viewModel.languagesService];
    
    @weakify(self);
    [self.sourceLanguageMenu.selectSignal subscribeNext:^(STLanguage *language) {
        @strongify(self);
        [self.viewModel selectSourceLanguage:language];
    }];
    
    [self.targetLanguageMenu.selectSignal subscribeNext:^(STLanguage *language) {
        @strongify(self);
        [self.viewModel selectTargetLanguage:language];
    }];
}

- (void)bindViewModel {
    @weakify(self);
    [RACObserve(self.viewModel, sourceLanguages) subscribeNext:^(NSArray <STLanguage *> *models) {
        @strongify(self);
        NSString *autoString = @"Ⓐ Detect";
        if (self.viewModel.detectedLanguage) {
            autoString = [NSString stringWithFormat:@"Ⓐ > (%@)", self.viewModel.detectedLanguage.title];
        }
        [self.sourceSegmentedControl setLabel:autoString forSegment:1];
        [self.sourceSegmentedControl setLabel:models[0].title forSegment:2];
        [self.sourceSegmentedControl setLabel:models[1].title forSegment:3];
    }];
    
    [RACObserve(self.viewModel, detectedLanguage) subscribeNext:^(STLanguage *language) {
        @strongify(self);
        NSString *autoString = @"Ⓐ Detect";
        if (language) {
            autoString = [NSString stringWithFormat:@"Ⓐ > (%@)", self.viewModel.detectedLanguage.title];
        }
        [self.sourceSegmentedControl setLabel:autoString forSegment:1];
    }];
    
    [RACObserve(self.viewModel, targetLanguages) subscribeNext:^(NSArray <STLanguage *> *models) {
        @strongify(self);
        [self.targetSegmentedControl setLabel:models[0].title forSegment:1];
        [self.targetSegmentedControl setLabel:models[1].title forSegment:2];
        [self.targetSegmentedControl setLabel:models[2].title forSegment:3];
    }];
    
    [RACObserve(self.viewModel, sourceSelectedIndex) subscribeNext:^(NSNumber *index) {
        @strongify(self);
        self.sourceSegmentedControl.selectedSegment = index.integerValue;
    }];
    
    [RACObserve(self.viewModel, targetSelectedIndex) subscribeNext:^(NSNumber *index) {
        @strongify(self);
        self.targetSegmentedControl.selectedSegment = index.integerValue;
    }];
    
    [[RACObserve(self.viewModel, inputText) distinctUntilChanged] subscribeNext:^(NSString *text) {
        @strongify(self);
        if (![self.inputTextView.string isEqual:text]) {
            if (!text) {
                self.inputTextView.string = @"";
            } else {
                self.inputTextView.string = text;
            }
        }
    }];
    
    [[RACObserve(self.viewModel, outputText) ignore:nil] subscribeNext:^(NSAttributedString *modelText) {
        @strongify(self);
        self.outputTextView.textStorage.attributedString = modelText;
    }];
    
    [[[self.inputTextView.rac_textSignal skip:1] distinctUntilChanged] subscribeNext:^(NSString *text) {
        @strongify(self);
        [self.viewModel updateInputText:text];
    }];
}

#pragma mark - Language selection
- (void)sourcePressed:(NSSegmentedControl *)sender {
    if (sender.selectedSegment == 0) {
        sender.selectedSegment = self.viewModel.sourceSelectedIndex;
        [NSMenu popUpContextMenu:self.sourceLanguageMenu withEvent:NSApp.currentEvent forView:self.sourceSegmentedControl.subviews[0]];
    } else {
        [self.viewModel selectSourceIndex:sender.selectedSegment];
    }
}

- (void)targetPressed:(NSSegmentedControl *)sender {
    if (sender.selectedSegment == 0) {
        sender.selectedSegment = self.viewModel.targetSelectedIndex;
        [NSMenu popUpContextMenu:self.targetLanguageMenu withEvent:NSApp.currentEvent forView:self.targetSegmentedControl.subviews[0]];
    } else {
        [self.viewModel selectTargetIndex:sender.selectedSegment];
    }
}

- (IBAction)swapButtonPress:(id)sender {
    [self.viewModel switchLanguages];
}

#pragma mark - Cleanup
- (void)windowDidMove:(NSNotification *)notification {
    //If window did move (scroll in a today center) close menus
    [self closeMenus];
}

- (void)windowDidResignKey:(NSNotification *)notification {
    //If window did resign key (close today center) close menus
    [self closeMenus];
}

- (void)closeMenus {
    [self.sourceLanguageMenu cancelTracking];
    [self.targetLanguageMenu cancelTracking];
}
@end

