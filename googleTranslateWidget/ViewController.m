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
    NSString *textForDirections = @"To use \r\r Open the notification center \r Click the Edit button at the bottom\r Find the Swipe Translate from the right menu \r Press the green + button near it \r\r Now you can translate fast";
    
    [_directionsLabel setStringValue:textForDirections];

    [[self view] setWantsLayer:YES];
    [[self view].layer setBackgroundColor:[[NSColor colorWithCalibratedRed:0.79 green:0.79 blue:0.79 alpha:1] CGColor]];
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
