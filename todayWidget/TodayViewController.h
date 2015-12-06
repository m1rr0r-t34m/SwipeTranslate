//
//  TodayViewController.h
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SeparatedButton.h"
#import "LanguagesStorage.h"
#import "PopupMenu.h"

#import "WidgetView.h"
#import "ValidateTextView.h"
#import "SavedInfo.h"
#import "../googleTranslateWidget/RequestReceiver.h"

@class RequestHandler;
@interface TodayViewController : NSViewController <ResponseReceiver>
//Outlets from view

@property (strong) IBOutlet NSView *widgetMainView;

@property (strong) IBOutlet NSTextView *inputText;
@property (strong) IBOutlet NSTextView *outputText;


@property (weak) IBOutlet SeparatedButton *sourceSegmentedButton;
@property (weak) IBOutlet SeparatedButton *targetSegmentedButton;

@property  IBOutlet NSMenu *sourceLanguageMenu;
@property  IBOutlet NSMenu *targetLanguageMenu;

@property (strong) IBOutlet NSButton *clearTextButton;

//Properties for storing data
@property NSArray* languages;
@property NSString * sLanguage;
@property NSString * tLanguage;
@property NSArray* alphaLang;
@property NSString* autoLanguageCode;
@property NSString* autoLanguageTitle;
@property SavedInfo *sharedDefaults;
@property SavedInfo *localDefaults;
@property RequestHandler *translateHandler;
@property RequestHandler *dictionaryHandler;


//IBActions and other methods to handle actions from view
- (IBAction)sourceTabClick:(id)sender;
- (IBAction)targetTabClick:(id)sender;
- (IBAction)swapButton: (id)sender;
- (void)sourceTabDropDownClick:(id)sender;
- (void)targetTabDropDownClick:(id)sender;
- (void)textDidChange:(NSNotification *)notification;
- (IBAction)clearText:(id)sender;


//Methods for managing data
-(void)updateLanguageModel;
-(void)performTranslateRequest;
-(void)performDictionaryRequest;

@end