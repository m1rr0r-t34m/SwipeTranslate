//
//  TodayViewController.m
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>


@interface delegateAppDelegate : NSObject <NSApplicationDelegate, NSTextViewDelegate> {
    NSWindow *window;
}
@end

@implementation TodayViewController

-(void)clearAutoLanguage {
    _autoLanguageTitle=nil;
    [_sourceSegmentedButton setLabel:@"Ⓐ Detect" forSegment:1];
    [self saveAutoLanguage];
}
-(void)clearOutput {
    
    [_outputText setString:@""];
    [self clearAutoLanguage];
    _clearTextButton.hidden = YES;
}
-(void)saveDefaultText {
    [SavedInfo setInputText:[_inputText string]];
    [SavedInfo setOutputText:[_outputText string]];
}
-(void)saveLanguages {
    NSMutableArray *sArray=[[NSMutableArray alloc] initWithCapacity:2];
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithCapacity:3];
    
    for (int i = 2; i < 4; i++) {
        [sArray addObject:[_sourceSegmentedButton labelForSegment:i]];
    }
    for (int i = 1; i < 4; i++) {
        [tArray addObject:[_targetSegmentedButton labelForSegment:i]];
        
    }
    
    [SavedInfo setSourceLanguages:sArray];
    [SavedInfo setTargetLanguages:tArray];
}
-(void)saveChosenLanguages {
    [SavedInfo setSourceSelection:[_sourceSegmentedButton selectedSegment]];
    [SavedInfo setTargetSelection:[_targetSegmentedButton selectedSegment]];
}
-(void)saveAutoLanguage {
    [SavedInfo setAutoLanguage:_autoLanguageTitle];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if([SavedInfo hasLanguages]) {
        //Update labels for segmented buttons
        for (int i = 2; i < 4; i++) {
            [_sourceSegmentedButton setLabel:[[SavedInfo sourceLanguages] objectAtIndex:i-2] forSegment:i];
        }
        
        for (int i = 1; i < 4; i++) {
            [_targetSegmentedButton setLabel:[[SavedInfo targetLanguages] objectAtIndex:i-1] forSegment:i];
        }
    }
    if([SavedInfo hasChosenLanguages]) {
        //Update selection of segmented buttons
        [_sourceSegmentedButton setSelectedSegment:[SavedInfo sourceSelection]];
        [_targetSegmentedButton setSelectedSegment:[SavedInfo targetSelection]];
    }
        
    if([SavedInfo hasDefaultText]) {
        //Update input and output text values
        [_inputText setString:[SavedInfo inputText]];
        [_outputText setString:[SavedInfo outputText]];
    }
    if([SavedInfo hasAutoLanguage]) {
        //Update Auto language
        if([_sourceSegmentedButton selectedSegment]==1&&[SavedInfo autoLanguage]) {
            [_sourceSegmentedButton setLabel:[NSString stringWithFormat: @"Ⓐ > (%@)",[SavedInfo autoLanguage]] forSegment:1];
        }
        else
            [self clearAutoLanguage];
    }
    else
        [self clearAutoLanguage];
    
    
    
    //Set input and output text view margins
    [_inputText setTextContainerInset:NSMakeSize(10.0, 0.0)];
    [_outputText setTextContainerInset:NSMakeSize(10.0, 0.0)];
    
    //Set input and output text color settings
    if([[self view]isKindOfClass:[WidgetView class]]){
        [_inputText setTextColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
        [_outputText setTextColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
        [_inputText setInsertionPointColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    }
    
    
    //Create pop up menus
    [_sourceSegmentedButton setMenu:_sourceLanguageMenu forSegment:(NSInteger)0];
    _sourceLanguageMenu = [PopupMenu createMenuWithAction:@"sourceTabDropDownClick:"andSender:self];
    
    [_targetSegmentedButton setMenu:_targetLanguageMenu forSegment:(NSInteger)0];
    _targetLanguageMenu = [PopupMenu createMenuWithAction:@"targetTabDropDownClick:"andSender:self];
    
    
    
    //Update clear button dislaying
    if ([[_inputText string]  isEqual: @""])
        _clearTextButton.hidden = YES;
    
    
    
    //Update source and target language values
    [self updateLanguageModel];
    
}

- (void)viewWillAppear {
    //set this view controller delegate for selectors windowDidResignKey and windowDidMove
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignKey:) name:NSWindowDidResignKeyNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidMove:) name:NSWindowDidMoveNotification object:self.view.window];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidMove:(NSNotification *)notification {
    //If window did move (scroll in a today center) close menus
    if(_sourceLanguageMenu)
        [ _sourceLanguageMenu cancelTracking];
    if(_targetLanguageMenu)
        [ _targetLanguageMenu cancelTracking];
    
}

- (void)windowDidResignKey:(NSNotification *)notification {
    //If window did resign key (close today center) close menus
    if(_sourceLanguageMenu)
        [ _sourceLanguageMenu cancelTracking];
    if(_targetLanguageMenu)
        [ _targetLanguageMenu cancelTracking];
    
}

- (void)textDidChange:(NSNotification *)notification{
    
    if(!(_inputText.isWhiteSpace||_inputText.isEmpty)) {
        _clearTextButton.hidden=NO;
        [self performGoogleRequest];
    }
    else if(_inputText.isEmpty) {
        [self clearOutput];
    }
    else if(_inputText.isWhiteSpace) {
        [self clearOutput];
        _clearTextButton.hidden=NO;
    }
    
    [self saveDefaultText];
    [self saveAutoLanguage];
}

- (IBAction)sourceTabClick:(id)sender {
    //Pop up menu if clicked on last button
    if([sender selectedSegment]==0){
        [_sourceLanguageMenu popUpMenuPositioningItem:nil atLocation:[_sourceSegmentedButton calculateMenuOrigin] inView:_widgetMainView];
        
        //Update selected segment to sLanguage to avoid bug with clicking outside menu frame
        //If some error, select first segment
        if([_sourceSegmentedButton indexForSegmentWithLabel:_sLanguage]!=-1)
            [_sourceSegmentedButton setSelectedSegment:[_sourceSegmentedButton indexForSegmentWithLabel:_sLanguage]];
        else
            [_sourceSegmentedButton setSelectedSegment:1];
    }
    //Clear Auto element title if clicked on different button
    if([sender selectedSegment]!=1)
        [self clearAutoLanguage];
    
    //Update languages
    [self updateLanguageModel];
    
    
    //Perform request
    if(![_inputText isEmpty])
        [self performGoogleRequest];
    
    //Save new selection to defaults
    [self saveChosenLanguages];
    
}

- (IBAction)targetTabClick:(id)sender {
    //Pop up menu if clicked on last button
    if([sender selectedSegment]==0){
        [_targetLanguageMenu popUpMenuPositioningItem:nil atLocation:[_targetSegmentedButton calculateMenuOrigin] inView:_widgetMainView];
        
        //Update selected segment to tLanguage to avoid bug with clicking outside menu frame
        //If some error, select first segment
        if([_targetSegmentedButton indexForSegmentWithLabel:_tLanguage]!=-1)
            [_targetSegmentedButton setSelectedSegment:[_targetSegmentedButton indexForSegmentWithLabel:_tLanguage]];
        else
            [_targetSegmentedButton setSelectedSegment:1];
        
    }
    //Update languages
    [self updateLanguageModel];
    
    //Perform request
    if(![_inputText isEmpty])
        [self performGoogleRequest];
    
    //Save new selection to defaults
    [self saveChosenLanguages];
    
}

- (void)sourceTabDropDownClick:(id)sender {
    
    //Push clicked menu element language to the button
    [_sourceSegmentedButton tryToPushNewSourceLanguage:[sender title]];
    
    
    [self saveLanguages];
    
    //Update source language
    [self updateLanguageModel];
}

- (void)targetTabDropDownClick:(id)sender {
    
    //Push clicked menu element language to the button
    [_targetSegmentedButton tryToPushNewTargetLanguage:[sender title]];
    
    [self saveLanguages];
    
    
    //Update target language
    [self updateLanguageModel];
}

- (IBAction)swapButton: (id)sender {
    
    if(![_sLanguage isEqualToString:@"Auto"]) {
        
        [_sourceSegmentedButton tryToPushNewSourceLanguage:_tLanguage];
        [_targetSegmentedButton tryToPushNewTargetLanguage:_sLanguage];
        
        [self updateLanguageModel];
        
        if(![_inputText isEmpty])
            [self performGoogleRequest];
    }
    else if(_autoLanguageTitle)
    {
        [_sourceSegmentedButton tryToPushNewSourceLanguage:_tLanguage];
        [_targetSegmentedButton tryToPushNewTargetLanguage:_autoLanguageTitle];
        
        [self updateLanguageModel];
        [self clearAutoLanguage];
        
        if(![_inputText isEmpty])
            [self performGoogleRequest];
        
    }
    
    [self saveLanguages];
    [self saveChosenLanguages];
}

- (IBAction)clearText:(id)sender {
    [_inputText setString:@""];
    [self clearOutput];
    [self saveDefaultText];
}

- (void)updateLanguageModel {
    if ([_sourceSegmentedButton selectedSegment] == 1)
        _sLanguage = @"Auto";
    
    else
        _sLanguage = [_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]];
    
    _tLanguage = [_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]];
    
}



- (void)performGoogleRequest{
    RequestHandler *handler = [RequestHandler new];
    [handler performRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[_inputText string]sender:self];
}

-(void)processReceivedData:(NSArray *)array {
    
    if([_sLanguage isEqualToString:@"Auto"]) {
        _autoLanguageCode = [NSString new];
        _autoLanguageTitle = [NSString new];
        
        _autoLanguageCode = [array objectAtIndex:0];
        _autoLanguageTitle =  [[NSArray getValuesArray:YES] objectAtIndex:[[NSArray getKeysArray] indexOfObject:_autoLanguageCode]];
        if(_autoLanguageTitle) {
            [_sourceSegmentedButton setLabel:[NSString stringWithFormat: @"Ⓐ > (%@)", _autoLanguageTitle] forSegment:1];
        }
    }
    
    [_outputText setString:[array objectAtIndex:1]];
    [self saveDefaultText];
    [self saveAutoLanguage];
    
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
    
    
}

@end