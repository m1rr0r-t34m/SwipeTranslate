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

@interface STMainViewController ()

@property (strong, nonatomic) STLeftSplitView *leftView;
@property (strong, nonatomic) STRightSplitView *rightView;

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
    
}

#pragma mark - Segues
-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EmbedLeftView"])
        self.leftView = segue.destinationController;
    else if([segue.identifier isEqualToString:@"EmbedRightView"])
        self.rightView = segue.destinationController;
}

@end
