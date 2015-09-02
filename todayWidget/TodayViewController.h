//
//  TodayViewController.h
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import AppKit;
#import "SeparatedButton.h"





@protocol asynchronousRequests <NSObject>

-(void)didFinishLoadingStuff:(NSData *)stuff;

@end
@interface TodayViewController : NSViewController

@property IBOutlet NSTextField *outputText;



@property IBOutlet NSTextField *inputText;

@property (strong) IBOutlet NSDictionaryController *dictController;

@property NSDictionary *langList;

-(NSDictionary*) createList;

-(IBAction)swapButton: (id)sender;
- (void)controlTextDidChange:(NSNotification *)notification;

@property (weak) IBOutlet NSPopUpButtonCell *sourceLanguagePopUp;
@property (weak) IBOutlet NSPopUpButtonCell *targetLanguagePopUp;


@property (weak) IBOutlet SeparatedButton *sourceSegmentedButton;

@property (strong) IBOutlet NSMenu *sourceLanguageMenu;




@property (strong) IBOutlet NSMenu *targetLanguageMenu;

@property (weak) IBOutlet SeparatedButton *targetSegmentedButton;


@property NSString * sLanguage;
@property NSString * tLanguage;




-(void)sourceTabClick:(id)sender;



@end





