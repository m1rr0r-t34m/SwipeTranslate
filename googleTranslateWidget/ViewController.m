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
    [_arrayController addObject:@[@"English", @"Russian", @"Finnish", @"French", @"Latin"]];
    
}

-(void)viewWillAppear{
    
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.titlebarAppearsTransparent = YES;
    self.view.window.styleMask |= NSFullSizeContentViewWindowMask;
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}




- (IBAction)enableLiveTranslate:(id)sender {
}

- (IBAction)enableAutoLanguage:(id)sender {
    
    if ([_autoLanguageButton state]) {
        _sLanguage = @"auto";
    }
        
    
}

//Swap button implementation
- (IBAction)swapButton:(id)sender {
    NSString *swapPlace = [NSString new];
    swapPlace = [_sourceLanguage stringValue];
    [_sourceLanguage setStringValue:[_targetLanguage stringValue]];
    [_targetLanguage setStringValue: swapPlace];
}
@end
