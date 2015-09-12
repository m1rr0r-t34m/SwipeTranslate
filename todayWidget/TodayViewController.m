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

- (void)awakeFromNib {
    [super viewDidLoad];
    
    _targetButtonDefaultValues = [[NSMutableDictionary alloc]init];
    _sourceButtonDefaultValues = [[NSMutableDictionary alloc]init];
    //Initialize requestHandler
    _requestHandler=[[GoogleRequest alloc] init];
    
    //Initialize languages array
    _languages = [NSArray arrayWithObjects:@"English", @"Russian", @"Finnish", @"Ukrainian",@"Chinese Simplified", nil];
    
    
    //Generate menu elelements for source language button
    [_sourceLanguageMenu setAutoenablesItems:NO];
    
    for(int a=0;a<[_languages count];a++) {
        NSMenuItem *item=[ _sourceLanguageMenu addItemWithTitle:[_languages objectAtIndex:(NSUInteger)a ] action:@selector(sourceTabDropDownClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    
    
    //Define labels for the buttons 
    
    NSDictionary *sourceDefault = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"sourceDefault"];
    NSDictionary *targetDefault = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"targetDefault"];
    
    if (sourceDefault != nil){
        
        for (int i = 0; i < 3; i++) {
            [_sourceSegmentedButton setLabel:[sourceDefault valueForKey:[NSString stringWithFormat:@"%d",i]]  forSegment:i];
                                            
        }
        
    }
        
    else
    [_sourceSegmentedButton setMenu:_sourceLanguageMenu forSegment:(NSInteger)3];
   
    
    if (targetDefault != nil) {
        
        for (int i = 0; i < 3; i++){
            [_targetSegmentedButton setLabel:[targetDefault valueForKey:[NSString stringWithFormat:@"%d",i]] forSegment:i];
            }
        
    }
    else
    [_targetLanguageMenu setAutoenablesItems:NO];
    
    for(int a=0;a<[_languages count];a++) {
        NSMenuItem *item=[ _targetLanguageMenu addItemWithTitle:[_languages objectAtIndex:(NSUInteger)a ] action:@selector(targetTabDropDownClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    
    [_targetSegmentedButton setMenu:_targetLanguageMenu forSegment:(NSInteger)3];
    
    //Set default selection for buttons if exists
    NSInteger defaultSourceSelecion, defaultTargetSelection;
    defaultSourceSelecion = [[NSUserDefaults standardUserDefaults] integerForKey:@"sourceDefaultSelection"];
    defaultTargetSelection = [[NSUserDefaults standardUserDefaults] integerForKey:@"targetDefaultSelection"];
    
    if (defaultSourceSelecion)
        [_sourceSegmentedButton setSelectedSegment:defaultSourceSelecion];
    if (defaultTargetSelection)
        [_targetSegmentedButton setSelectedSegment:defaultTargetSelection];
        
    
    
    //Assign initial source and target language values
    [self updateTargetLanguage];
    [self updateSourceLanguage];
    
    [_inputText setTextColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    [_outputText setTextColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    [_inputText setInsertionPointColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
    
}

- (void)receivedResponseFromRequest:(NSData *)data {
    //Convert received data to NSString using NSUTF8StringEncoding
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    strData=[strData parseFirstDive];
    NSInteger numberOfLines=[strData numberOfLines];
    NSString *outputString=[[NSString alloc] init];
    
    
    while(numberOfLines){
        NSString *strLine=[[NSString alloc]init];
        strLine=[strData parseSecondDive];
        if([strLine length]!=[strData length])
            strData=[strData substringWithRange:NSMakeRange([strLine length]+1, [strData length]-[strLine length]-1)];
        strLine=[strLine parseThirdDive];
        
        outputString =[outputString stringByAppendingString:strLine];
        numberOfLines--;
    }
    
    //Make end of line siymbols visible by NSTextView
    outputString=[outputString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    outputString=[outputString stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r"];
    
    //Write translated text to the output
    [self setOutputValue:outputString];
}

- (IBAction)sourceTabClick:(id)sender {
    //Pop up menu if clicked on last button
    if([sender selectedSegment]==3){
        [_sourceLanguageMenu popUpMenuPositioningItem:nil atLocation:[_sourceSegmentedButton calculateMenuOrigin] inView:_widgetMainView];
        
        //Update selected segment to sLanguage to avoid bug with clicking outside menu frame
        //If some error, select first segment
        if([_sourceSegmentedButton indexForSegmentWithLabel:_sLanguage]!=-1)
            [_sourceSegmentedButton setSelectedSegment:[_sourceSegmentedButton indexForSegmentWithLabel:_sLanguage]];
        else
            [_sourceSegmentedButton setSelectedSegment:0];
    }
    //Update languages
    [self updateTargetLanguage];
    [self updateSourceLanguage];
    
    //Perform request
    if(![[[_inputText textStorage] string] isEqualToString:@""])
        [self performGoogleRequest];
    
    _sourceDefaultSelection = [NSNumber numberWithInteger:[_sourceSegmentedButton selectedSegment]];
    [[NSUserDefaults standardUserDefaults] setObject:_sourceDefaultSelection forKey:@"sourceDefaultSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)targetTabClick:(id)sender {
    //Pop up menu if clicked on last button
    if([sender selectedSegment]==3){
        [_targetLanguageMenu popUpMenuPositioningItem:nil atLocation:[_targetSegmentedButton calculateMenuOrigin] inView:_widgetMainView];
        
        //Update selected segment to tLanguage to avoid bug with clicking outside menu frame
        //If some error, select first segment
        if([_targetSegmentedButton indexForSegmentWithLabel:_tLanguage]!=-1)
            [_targetSegmentedButton setSelectedSegment:[_targetSegmentedButton indexForSegmentWithLabel:_tLanguage]];
        else
            [_targetSegmentedButton setSelectedSegment:0];
        
    }
    //Update languages
    [self updateSourceLanguage];
    [self updateTargetLanguage];
    
    //Perform request
    if(![[[_inputText textStorage] string] isEqualToString:@""])
        [self performGoogleRequest];
    
    //Update defaults
    
    _targetDefaultSelection = [NSNumber numberWithInteger:[_targetSegmentedButton selectedSegment]];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_targetDefaultSelection forKey:@"targetDefaultSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)textDidChange:(NSNotification *)notification{
    //Perform request
    if([[[_inputText textStorage] string] isEqualToString:@""])
        [self setOutputValue:@""];
    else {
        [_inputText setString:[[[_inputText textStorage] string] stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        [self performGoogleRequest];
    }
    
}

- (void)sourceTabDropDownClick:(id)sender {
    //Push clicked menu element language to the button
    [_sourceSegmentedButton tryToPushNewLanguage:[sender title]];
    
    //Update default values for button
    
    for (int i = 0; i < 3; i++) {
        
        [_sourceButtonDefaultValues setObject:[_sourceSegmentedButton labelForSegment:i] forKey:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_sourceButtonDefaultValues forKey:@"sourceDefault"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Update source language
    [self updateSourceLanguage];
}

- (void)targetTabDropDownClick:(id)sender {
    //Push clicked menu element language to the button
    [_targetSegmentedButton tryToPushNewLanguage:[sender title]];
    
    //Update default values for button
    
    for (int i = 0; i < 3; i++) {
        
        [_targetButtonDefaultValues setValue:[_targetSegmentedButton labelForSegment:i] forKey:[NSString stringWithFormat:@"%d",i]];
       
    }

    [[NSUserDefaults standardUserDefaults] setObject:_targetButtonDefaultValues forKey:@"targetDefault"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //Update source language
    [self updateTargetLanguage];
}

-(IBAction)swapButton: (id)sender {
    //Swap source language and target language buttons values
    [_sourceSegmentedButton tryToPushNewLanguage:_tLanguage];
    [_targetSegmentedButton tryToPushNewLanguage:_sLanguage];
    
    ////Update languages and perform request
    [self updateTargetLanguage];
    [self updateSourceLanguage];
    
    if(![[[_inputText textStorage] string] isEqualToString:@""])
        [self performGoogleRequest];
    
}


-(void)updateSourceLanguage{
    _sLanguage = [_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]];
}

-(void)updateTargetLanguage{
    _tLanguage = [_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]];
}

-(void)performGoogleRequest{
    
    [_requestHandler sendRequestWithSourceLanguage: _sLanguage TargetLanguage: _tLanguage Text:[[_inputText textStorage] string] Sender:self];
}
-(void)setOutputValue:(NSString *)value{
    runOnMainQueueWithoutDeadlocking(^{
        [_outputText setString:value];
   });
}

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

@end







