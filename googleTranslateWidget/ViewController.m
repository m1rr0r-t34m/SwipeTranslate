//
//  ViewController.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Setting up the window appearance 
    NSWindow *mainWindow=[[[NSApplication sharedApplication] windows] objectAtIndex:0];
    [mainWindow setBackgroundColor:[NSColor colorWithCalibratedRed:0.18 green:0.18 blue:0.18 alpha:0.98]];
    [mainWindow setOpaque:NO];
    
}

@end
