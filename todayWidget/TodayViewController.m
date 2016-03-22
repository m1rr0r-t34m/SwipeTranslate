//
//  TodayViewController.m
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "TodayViewController.h"
#import "RequestHandler.h"
#import <NotificationCenter/NotificationCenter.h>


@interface delegateAppDelegate : NSObject <NSApplicationDelegate, NSTextViewDelegate> {
    NSWindow *window;
    
}

@end


@implementation TodayViewController
-(void)clearAutoLanguage {
    [_sourceSegmentedButton setLabel:@"Ⓐ Detect" forSegment:1];
    _autoLanguage=nil;
    [self saveAutoLanguage];
}
-(void)clearOutput {
    
    [_outputText setString:@""];
    [self clearAutoLanguage];
    [_dictionaryHandler cancelCurrentSession];
    [_translateHandler cancelCurrentSession];
    _clearTextButton.hidden = YES;
}
-(void)saveDefaultText {
    [_localDefaults setInputText:[_inputText string]];
    [_localDefaults setOutputText:[_outputText string]];
}
-(void)saveLanguages {
    NSMutableArray *sArray=[[NSMutableArray alloc] initWithArray:[_localDefaults sourceLanguages]];
    NSMutableArray *tArray=[[NSMutableArray alloc] initWithArray:[_localDefaults targetLanguages]];
    
    for(int i=2;i<4;i++) {
        [sArray replaceObjectAtIndex:i-2 withObject:[_sourceSegmentedButton labelForSegment:i]];
    }
    for(int i=1;i<4;i++) {
        [tArray replaceObjectAtIndex:i-1 withObject:[_targetSegmentedButton labelForSegment:i]];
    }
    
    [_localDefaults setSourceLanguages:sArray];
    [_localDefaults setTargetLanguages:tArray];
}
-(void)saveChosenLanguages {
    
    if(!(_sourceSegmentedButton.selectedSegment == 1)) {
        [_localDefaults setSourceSelection:[_sourceSegmentedButton labelForSegment:[_sourceSegmentedButton selectedSegment]]];
    }
    
      [_localDefaults setTargetSelection:[_targetSegmentedButton labelForSegment:[_targetSegmentedButton selectedSegment]]];
}
-(void)saveAutoLanguage {
    [_localDefaults setAutoLanguage:_autoLanguage];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _translatedText=[NSString new];
    
    _localDefaults=[SavedInfo localDefaults];


    for (int i = 2; i < 4; i++) {
        [_sourceSegmentedButton setLabel:[[_localDefaults sourceLanguages] objectAtIndex:i-2] forSegment:i];
    }
    
    for (int i = 1; i < 4; i++) {
        [_targetSegmentedButton setLabel:[[_localDefaults targetLanguages] objectAtIndex:i-1] forSegment:i];
    }
    
    if(![_localDefaults autoPushed]) {
        [_sourceSegmentedButton tryToPushNewSourceLanguage:[_localDefaults sourceSelection]];
        [self clearAutoLanguage];
    }
    else {
        [_sourceSegmentedButton setSelectedSegment:1];
        if([_localDefaults hasAutoLanguage])
            [_sourceSegmentedButton setLabel:[NSString stringWithFormat: @"Ⓐ > (%@)",[_localDefaults autoLanguage]] forSegment:1];
        else
            [self clearAutoLanguage];
    }
    
    [_targetSegmentedButton tryToPushNewTargetLanguage:[_localDefaults targetSelection]];
    
        

    [_inputText setString:[_localDefaults inputText]];
    [_outputText setString:[_localDefaults outputText]];
    
    
    
    
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
    
    //Create request handlers
    _translateHandler = [RequestHandler NewTranslateRequest];
        [_translateHandler setDelegate:self];
    _dictionaryHandler = [RequestHandler NewDictionaryRequest];
        [_dictionaryHandler setDelegate:self];
    
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
        [self startRequst];
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
    if([sender selectedSegment]!=1) {
        [self clearAutoLanguage];
        [self saveChosenLanguages];
        [_localDefaults setAutoPushed:NO];
    }
    
    else
        [_localDefaults setAutoPushed:YES];
    
    //Update languages
    [self updateLanguageModel];
    
    
    //Perform request
    if(![_inputText isEmpty])
        [self startRequst];
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
        [self startRequst];


    
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
        
        if(![_inputText isEmpty]) {
            [self startRequst];
        }
        
    }
    else if(_autoLanguage)
    {
        [_sourceSegmentedButton tryToPushNewSourceLanguage:_tLanguage];
        [_targetSegmentedButton tryToPushNewTargetLanguage:_autoLanguage];
        
        [self updateLanguageModel];
        [self clearAutoLanguage];
        
        if(![_inputText isEmpty]) {
            [self startRequst];

        }
        
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


-(void)startRequst {
    [_dictionaryHandler cancelCurrentSession];
    [_translateHandler cancelCurrentSession];
    [self performTranslateRequest];
    
}
- (void)performTranslateRequest{
    [_translateHandler performRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
}
-(void)receiveTranslateResponse:(NSArray *)data {
    
    if([_sLanguage isEqualToString:@"Auto"]) {
        _autoLanguage = [NSString new];
        _autoLanguage = [data objectAtIndex:0];
        if(_autoLanguage&&_autoLanguage.length>0) {
            [self saveAutoLanguage];
            [_localDefaults setAutoLanguage:_autoLanguage];
            [_sourceSegmentedButton setLabel:[NSString stringWithFormat: @"Ⓐ > (%@)", _autoLanguage] forSegment:1];
        }
    }
    
    _translatedText = [data objectAtIndex:1];
    [self performDictionaryRequest];
}
-(void)performDictionaryRequest {
    
    if([_sLanguage isEqualToString:@"Auto" ]) {
        if(_autoLanguage&&_autoLanguage.length>0)
            [_dictionaryHandler performRequestForSourceLanguage:_autoLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
        else {
            [_outputText setString:_translatedText];
            [self saveDefaultText];
            return;
        }
    }
    else
        [_dictionaryHandler performRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
}


-(void)receiveDictionaryResponse:(NSArray *)data {
    
    NSDictionary *receivedData=(NSDictionary *)data[0];
    NSString *inputWord=[receivedData objectForKey:@"text"];
    NSAttributedString *outputText=[NSAttributedString new];
    
    if([inputWord length]>0) {
        outputText=[Parser outputStringForWidgetAppDictionary:receivedData];
        [[_outputText textStorage] setAttributedString:outputText];
    }
    else
        [_outputText setString:_translatedText];
    
    [self saveDefaultText];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
    
    
}

@end