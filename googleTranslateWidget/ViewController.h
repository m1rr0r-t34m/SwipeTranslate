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
#import "InputTextView.h"
#import "ValidateTextView.h"
#import "RequestReceiver.h"
#import "SavedInfo.h"
#import "MainApplicationMenu.h"

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
@property (strong) IBOutlet NSTextView *outputText;
@property (strong) IBOutlet NSButton *clearTextButton;
@property (strong) IBOutlet InputScroll *inputScrollView;
@property (strong) IBOutlet NSProgressIndicator *requestProgressIndicator;


//Actions from View
- (IBAction)enableAutoLanguage:(id)sender;
- (IBAction)swapButton:(id)sender;
- (IBAction)showSourceMenu:(id)sender;
- (IBAction)showTargetMenu:(id)sender;
- (IBAction)clearTextButtonAction:(id)sender;

//Methods
-(void)sourceMenuClick:(id)sender;
-(void)targetMenuClick:(id)sender;

//Storing data properties
@property NSString* sLanguage;
@property NSString* tLanguage;
@property NSString* autoLanguage;
@property SavedInfo *localDefaults;

//Menu properties
@property NSMenu *sourceLanguageMenu;
@property NSMenu *targetLanguageMenu;
@property NSMenuItem *liveTranslate;

@property RequestHandler *translateHandler;
@property RequestHandler *dictionaryHandler;

@end

