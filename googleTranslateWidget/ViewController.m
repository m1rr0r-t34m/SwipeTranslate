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
    NSString *textForDirections = [NSString new];
    textForDirections = [NSString stringWithFormat:@"To use \r\r Open the notification center \r Click the Edit button at the bottom\r Find the tTranslator from the right menu \r Press the green + button near it \r\r Now you can translate fast"];
    
    [_directionsLabel setStringValue:textForDirections];
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
