//
//  TodayViewController.m
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "TodayViewController.h"
#import "GoogleRequest.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property GoogleRequest* requestHandler;

@end

@implementation TodayViewController





- (void)didFinishLoadingStuff:(NSData *)stuff {
    NSString *strData = [[NSString alloc]initWithData:stuff encoding:NSUTF8StringEncoding];
    int startNewWord = 4,endNewWord=0;
    for(int i=4;i<[strData length];i++) {
        if([[strData substringWithRange:NSMakeRange(i,1)] isEqual:@"\""]) {
            endNewWord=i;
            break;
        }
    }
    NSString *newWord=[strData substringWithRange:NSMakeRange(startNewWord, endNewWord-startNewWord)];
    _outputText.stringValue=newWord;
}




- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
    
}




-(IBAction)swapButton: (id)sender {
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_sourceLanguageMenu setAutoenablesItems:NO];
    [_targetLanguageMenu setAutoenablesItems:NO];
    
  /*list for source*/
    
        for(int a=0;a<[[_languagesDictionary allKeys] count];a++) {
        NSMenuItem *item=[ _sourceLanguageMenu addItemWithTitle:[[_languagesDictionary allKeys]objectAtIndex:(NSUInteger)a ] action:@selector(sourceTabClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    
  /*list for target*/

    
    for(int a=0;a<[[_languagesDictionary allKeys] count];a++) {
        NSMenuItem *item=[ _targetLanguageMenu addItemWithTitle:[[_languagesDictionary allKeys]objectAtIndex:(NSUInteger)a ] action:@selector(targetTabClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    

    [_sourceSegmentedButton setMenu:_sourceLanguageMenu forSegment:(NSInteger)3];
    [_targetSegmentedButton setMenu:_targetLanguageMenu forSegment:(NSInteger)3];
    
    _requestHandler=[[GoogleRequest alloc] init];
    
    NSArray *keys = @[@"English", @"Russian", @"Finnish", @"Ukrainian"];
    NSArray *values = @[@"en", @"ru", @"fi", @"ua"];
    _languagesDictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
}



-(void)controlTextDidChange:(NSNotification *)notification {
    _sLanguage = [_languagesDictionary valueForKey:[_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]]];
    _tLanguage = [_languagesDictionary valueForKey:[_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]]];
    
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[_inputText stringValue] Sender:self];
    
}






- (void)sourceTabDropDownClick:(id)sender {
    
    if ([[_sourceSegmentedButton labelForSegment:0] isEqualToString: [sender title]]) {
        [_sourceSegmentedButton setSelectedSegment:(NSInteger)0];
    }
    else if([[_sourceSegmentedButton labelForSegment:1] isEqualToString: [sender title]]) {
        [_sourceSegmentedButton setSelectedSegment:(NSInteger)1];
    }
    else if([[_sourceSegmentedButton labelForSegment:2] isEqualToString: [sender title]]) {
        [_sourceSegmentedButton setSelectedSegment:(NSInteger)2];
    }
    else {
        [_sourceSegmentedButton pushNewChosenLanguage:[sender title]];
        
    }
    
}
- (void)targetTabDropDownClick:(id)sender {
    if ([[_targetSegmentedButton labelForSegment:0] isEqualToString: [sender title]]) {
        [_targetSegmentedButton setSelectedSegment:(NSInteger)0];
    }
    else if([[_targetSegmentedButton labelForSegment:1] isEqualToString: [sender title]]) {
        [_targetSegmentedButton setSelectedSegment:(NSInteger)1];
    }
    else if([[_targetSegmentedButton labelForSegment:2] isEqualToString: [sender title]]) {
        [_targetSegmentedButton setSelectedSegment:(NSInteger)2];
    }
    else {
        [_targetSegmentedButton pushNewChosenLanguage:[sender title]];
        
    }
    _tLanguage = [_languagesDictionary valueForKey:[_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]]];
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[_inputText stringValue] Sender:self];
}

- (IBAction)sourceTabClick:(id)sender {
    _sLanguage = [_languagesDictionary valueForKey:[_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]]];
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[_inputText stringValue] Sender:self];
}

- (IBAction)targetTabClick:(id)sender {
    _tLanguage = [_languagesDictionary valueForKey:[_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]]];
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[_inputText stringValue] Sender:self];
}
@end







