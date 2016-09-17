//
//  MainViewController.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STMainViewController.h"

#import "STLeftSplitView.h"
#import "STRightSplitView.h"

@interface STMainViewController () <NSSplitViewDelegate>

@property (strong, nonatomic) STLeftSplitView *leftView;
@property (strong, nonatomic) STRightSplitView *rightView;
@property (weak) IBOutlet NSSplitView *splitView;

@end

@implementation STMainViewController

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        _ViewModel = [STMainViewControllerModel new];
        
    }
    return self;
}


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.splitView setDelegate:self];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self setupFlow];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.titlebarAppearsTransparent = YES;
    self.view.window.styleMask |= NSFullSizeContentViewWindowMask;
    [self.view.window setBackgroundColor:[NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1]];
}

- (void)setupFlow {
    
    RAC(self.ViewModel, sourceText) = [RACObserve(self.rightView.ViewModel, inputText) ignore:nil];
    RAC(self.ViewModel, sourceLanguage) = [RACObserve(self.leftView.ViewModel, sourceSelectedLanguage) ignore:nil];
    RAC(self.ViewModel, targetLanguage) = [RACObserve(self.leftView.ViewModel, targetSelectedLanguage) ignore:nil];
    
    RAC(self.rightView.ViewModel, outputText) = [RACObserve(self.ViewModel, translatedText) ignore:nil];
}


#pragma mark - Split View 
//TODO: setup correctly (check in the app - it's shitty now)
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    return 350;
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    return 180;
}


#pragma mark - Segues
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EmbedLeftView"])
        self.leftView = segue.destinationController;
    else if([segue.identifier isEqualToString:@"EmbedRightView"])
        self.rightView = segue.destinationController;
}

@end
