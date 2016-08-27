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

-(instancetype)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
        self.ViewModel = [STMainViewControllerModel new];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.splitView setDelegate:self];
    
    
}

- (void) setupSplitResize {
//    @weakify(self);
//    [[[[RACSignal
//        merge:@[RACObserve(self.leftView.view, frame), RACObserve(self.leftView.view, bounds)]]
//        map:^(NSValue *value) {
//           return @(CGRectGetWidth([value rectValue]));
//        }]
//        distinctUntilChanged]
//        subscribeNext:^(NSNumber *Width) {
//            @strongify(self);
//            
////            if(Width.floatValue >= 300) {
////                [self.splitView setPosition:300 ofDividerAtIndex:0];
////            }
////            
////            if(Width.floatValue <= 250) {
////                [self.splitView setPosition:250 ofDividerAtIndex:0];
////            }
//         
//    }];
    
    
    

}

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
