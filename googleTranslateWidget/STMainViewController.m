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

#import "STTranslationManager.h"
#import "STLanguages.h"

@interface STMainViewController () <NSSplitViewDelegate>

@property (strong, nonatomic) STLeftSplitView *leftView;
@property (strong, nonatomic) STRightSplitView *rightView;
@property (weak) IBOutlet NSSplitView *splitView;

@end

@implementation STMainViewController

#pragma mark - Initialization

-(instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        _ViewModel = [STMainViewControllerModel new];
        
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.splitView setDelegate:self];
    
    //TODO: SMTHG MORE CLEVER??
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupFlow];
    });
    
    
    
}

-(void)setupFlow {
    
    [[[RACSignal combineLatest:@[
        [[RACObserve(self.rightView.ViewModel, inputText) ignore:nil] ignore:@""],
        [RACObserve(self.leftView.ViewModel, sourceSelectedLanguage) ignore:nil],
        [RACObserve(self.leftView.ViewModel, targetSelectedLanguage) ignore:nil]]]
            filter:^BOOL(RACTuple *tuple) {
                RACTupleUnpack(NSString *text, NSString *sourceLang, NSString *targetLang) = tuple;
                return (text.length && sourceLang.length && targetLang.length);
            }]
            subscribeNext:^(RACTuple *tuple) {
                RACTupleUnpack(NSString *text, NSString *sourceLang, NSString *targetLang) = tuple;
                
                NSString *sourceLangKey = [LanguageKeys objectAtIndex:[Languages indexOfObject:sourceLang]];
                NSString *targetLangKey = [LanguageKeys objectAtIndex:[Languages indexOfObject:targetLang]];
                
                
                [[STTranslationManager Manager] getTranslationForString:text SourceLanguage:sourceLangKey AndTargetLanguage:targetLangKey];
            }];
    
}

#pragma mark - Split View 
-(CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    return 350;
}
-(CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    return 180;
}


#pragma mark - Segues
-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EmbedLeftView"])
        self.leftView = segue.destinationController;
    else if([segue.identifier isEqualToString:@"EmbedRightView"])
        self.rightView = segue.destinationController;
}

@end
