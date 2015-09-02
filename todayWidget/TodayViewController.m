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


void runOnMainQueueWithoutDeadlocking(void (^block)(void))  //This function will add a command on the main thread to execute instantly
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}


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
    
   
    runOnMainQueueWithoutDeadlocking(^{
        
    
        self.outputText.stringValue=newWord;
   
    });
}




- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
    
}




-(IBAction)swapButton: (id)sender {
    
    NSInteger SwapSpace;
    SwapSpace = [_sourceSegmentedButton selectedSegment];
    [_sourceSegmentedButton setSelectedSegment:[_targetSegmentedButton selectedSegment]];
    [_targetSegmentedButton setSelectedSegment:SwapSpace];
    
    
    _sLanguage = [[self createLanguages] valueForKey:[_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]]];
    _tLanguage = [[self createLanguages] valueForKey:[_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]]];
    
    _inputText.stringValue = _outputText.stringValue;
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[_inputText stringValue] Sender:self];
    
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [_sourceLanguageMenu setAutoenablesItems:NO];
    [_targetLanguageMenu setAutoenablesItems:NO];
    

    _requestHandler=[[GoogleRequest alloc] init];
 
    
  
    
        for(int a=0;a<[[[self createLanguages] allKeys] count];a++) {
        NSMenuItem *item=[ _sourceLanguageMenu addItemWithTitle:[[[self createLanguages] allKeys] objectAtIndex:(NSUInteger)a ] action:@selector(sourceTabDropDownClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    
  

    
    for(int a=0;a<[[[self createLanguages] allKeys] count];a++) {
        NSMenuItem *item=[ _targetLanguageMenu addItemWithTitle:[[[self createLanguages] allKeys]objectAtIndex:(NSUInteger)a ] action:@selector(targetTabDropDownClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    

    [_sourceSegmentedButton setMenu:_sourceLanguageMenu forSegment:(NSInteger)3];
    [_targetSegmentedButton setMenu:_targetLanguageMenu forSegment:(NSInteger)3];
    
    
    
    
}
-(NSDictionary *)createLanguages {
    NSArray *keys = @[@"English", @"Russian", @"Finnish", @"Ukrainian"];
    NSArray *values = @[@"en", @"ru", @"fi", @"uk"];
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}


-(void)controlTextDidChange:(NSNotification *)notification {
    _sLanguage = [[self createLanguages] valueForKey:[_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]]];
    _tLanguage = [[self createLanguages] valueForKey:[_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]]];
    
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
}

- (IBAction)sourceTabClick:(id)sender {
    _sLanguage = [[self createLanguages] valueForKey:[_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]]];
    _tLanguage = [[self createLanguages] valueForKey:[_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]]];
    
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[_inputText stringValue] Sender:self];
}

- (IBAction)targetTabClick:(id)sender {
    _sLanguage = [[self createLanguages] valueForKey:[_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]]];
    _tLanguage = [[self createLanguages] valueForKey:[_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]]];
    
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[_inputText stringValue] Sender:self];
}
@end







