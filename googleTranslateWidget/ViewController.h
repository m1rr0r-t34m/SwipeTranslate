//
//  ViewController.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SeparatedButton.h"
#import "Parser.h"
#import "LanguagesStorage.h"
#import "PopupMenu.h"
#import "RequestHandler.h"
#import "DataSource.h"
#import "DataSourceDelegate.h"
#import "ValidateString.h"
#import "InputTextView.h"
#import "RequestReceiver.h"

@interface ViewController : NSViewController<DataSourceDelegate, ResponseReceiver, NSTextFieldDelegate, NSTextViewDelegate>

//Outlets from View
@property (strong) IBOutlet NSTextField *sourceLanguage;
@property (strong) IBOutlet NSTextField *targetLanguage;
@property (strong) IBOutlet NSButton *autoLanguageButton;
@property (strong) IBOutlet NSTableView *sourceLanguageTable;
@property (strong) IBOutlet NSTableView *targetLanguageTable;
@property (strong) IBOutlet DataSource *dataHandler;
@property (strong) IBOutlet NSView *rightSplittedView;
@property (strong) IBOutlet InputTextView *inputText;
@property (strong) IBOutlet NSTextField *outputText;




//Actions from View
- (IBAction)enableLiveTranslate:(id)sender;
- (IBAction)enableAutoLanguage:(id)sender;
- (IBAction)swapButton:(id)sender;
- (IBAction)showSourceMenu:(id)sender;
- (IBAction)showTargetMenu:(id)sender;

//Methods
-(void)sourceMenuClick:(id)sender;
-(void)targetMenuClick:(id)sender;

//Storing data properties
@property NSString* sLanguage;
@property NSString* tLanguage;

//Menu properties
@property NSMenu *sourceLanguageMenu;
@property NSMenu *targetLanguageMenu;

@end

