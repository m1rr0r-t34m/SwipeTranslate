//
//  TodayViewController.h
//  todayWidget
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


@interface TodayViewController : NSViewController

//Outlets from view
@property (strong) IBOutlet NSView *widgetMainView;

@property (strong) IBOutlet NSTextView *inputText;
@property (strong) IBOutlet NSTextView *outputText;


@property (weak) IBOutlet SeparatedButton *sourceSegmentedButton;
@property (weak) IBOutlet SeparatedButton *targetSegmentedButton;

@property  IBOutlet NSMenu *sourceLanguageMenu;
@property  IBOutlet NSMenu *targetLanguageMenu;


//Properties for storing data
@property NSArray* languages;
@property NSString * sLanguage;
@property NSString * tLanguage;
@property NSArray* alphaLang;
@property NSString* autoLanguageCode;
@property NSString* autoLanguageTitle;
@property BOOL textIsValidURL;

//IBActions and other methods to handle actions from view
- (IBAction)sourceTabClick:(id)sender;
- (IBAction)targetTabClick:(id)sender;
- (IBAction)swapButton: (id)sender;
- (void)sourceTabDropDownClick:(id)sender;
- (void)targetTabDropDownClick:(id)sender;
- (void)textDidChange:(NSNotification *)notification;


//Methods for managing data
-(void)updateSourceLanguage;
-(void)updateTargetLanguage;
-(void)performGoogleRequest;
-(void)setOutputValue:(NSString *)value;
- (void)receivedResponseFromRequest:(NSData *)data;
-(void)prepareForExternalTranslate:(NSURLRequest *)request;

//Preferences
@property NSMutableDictionary* sourceButtonDefaultValues;
@property NSMutableDictionary* targetButtonDefaultValues;
@property NSNumber* sourceDefaultSelection;
@property NSNumber* targetDefaultSelection;
@property NSString* defaultInputText;
@property NSString* defaultOutputText;


@end





