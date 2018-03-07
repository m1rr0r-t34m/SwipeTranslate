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
#import "STMainViewModel.h"

static CGFloat leftSplitViewWidth = 255;

@interface STMainViewController () <NSSplitViewDelegate>
@property (strong, nonatomic) STLeftSplitView *leftView;
@property (strong, nonatomic) STRightSplitView *rightView;
@property (assign, nonatomic) BOOL leftSplitHidden;
@property (weak) IBOutlet NSSplitView *splitView;
@end

@implementation STMainViewController
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _viewModel = [STMainViewModel new];
    }
    
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.splitView setDelegate:self];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.titlebarAppearsTransparent = YES;
    self.view.window.styleMask |= NSFullSizeContentViewWindowMask;
    self.view.window.backgroundColor = [NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1];
}

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize {
    CGFloat dividerThickness = [sender dividerThickness];
    NSRect leftRect = [[[sender subviews] objectAtIndex:0] frame];
    NSRect rightRect = [[[sender subviews] objectAtIndex:1] frame];
    NSRect newFrame = [sender frame];
    
    leftRect.size.height = newFrame.size.height;
    leftRect.origin = NSMakePoint(0, 0);
    
    if(newFrame.size.width < leftSplitViewWidth * 2) {
        leftRect.size.width = 0;
        self.leftSplitHidden = YES;
    } else {
        leftRect.size.width = leftSplitViewWidth;
        self.leftSplitHidden = NO;
    }
    
    rightRect.size.width = newFrame.size.width - leftRect.size.width - dividerThickness;
    rightRect.size.height = newFrame.size.height;
    rightRect.origin.x = leftRect.size.width + dividerThickness;
    
    [[[sender subviews] objectAtIndex:0] setFrame:leftRect];
    [[[sender subviews] objectAtIndex:1] setFrame:rightRect];
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex {
    
    if (self.leftSplitHidden) {
        return 0;
    } else {
        return leftSplitViewWidth;
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EmbedLeftView"]) {
        self.leftView = segue.destinationController;
        self.leftView.viewModel = [[STLeftSplitViewModel alloc] initWithMainViewModel:self.viewModel];
    }
    else if([segue.identifier isEqualToString:@"EmbedRightView"]) {
        self.rightView = segue.destinationController;
        self.rightView.viewModel = [[STRightSplitViewModel alloc] initWithMainViewModel:self.viewModel];
    }
    
}

@end
