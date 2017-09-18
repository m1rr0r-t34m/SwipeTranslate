//
//  MainViewController.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class STMainViewModel;


@interface STMainViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (strong, nonatomic) STMainViewModel *viewModel;

@end
