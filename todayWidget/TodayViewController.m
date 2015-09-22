//
//  TodayViewController.m
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@implementation TodayViewController

- (void)awakeFromNib {
    [super viewDidLoad];
    
    
    _externalURL =[NSMutableString new];
    //Set helper elements invisible
    [_openExternalLinkButton setAlphaValue:0.0];
    [_outPutTextHideBox setAlphaValue:0.0];
    
    //Set main element visible
    _outputText.hidden=NO;
    
    _targetButtonDefaultValues = [NSMutableDictionary new];
    _sourceButtonDefaultValues = [NSMutableDictionary new];
    
    //Set input text view margins
    [_inputText setTextContainerInset:NSMakeSize(10.0, 0.0)];
    [_outputText setTextContainerInset:NSMakeSize(10.0, 0.0)];
    
  
    //Initialize menu layouts
    PopupMenu* menuLayoutWithSubmenus = [[PopupMenu alloc]init];
    
   
    [_sourceSegmentedButton setMenu:_sourceLanguageMenu forSegment:(NSInteger)0];
    _sourceLanguageMenu = [menuLayoutWithSubmenus createMenuWithAction:@"sourceTabDropDownClick:"andSender:self];
    
  
    [_targetSegmentedButton setMenu:_targetLanguageMenu forSegment:(NSInteger)0];
    _targetLanguageMenu = [menuLayoutWithSubmenus createMenuWithAction:@"targetTabDropDownClick:"andSender:self];
    

    //Define labels for the buttons
    
    NSDictionary *sourceDefault = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"sourceDefault"];
    NSDictionary *targetDefault = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"targetDefault"];
    
    if (sourceDefault != nil){
        for (int i = 2; i < 4; i++) {
            [_sourceSegmentedButton setLabel:[sourceDefault valueForKey:[NSString stringWithFormat:@"%d",i]]  forSegment:i];
            }
        }
    if (targetDefault != nil) {
        for (int i = 1; i < 4; i++){
            [_targetSegmentedButton setLabel:[targetDefault valueForKey:[NSString stringWithFormat:@"%d",i]] forSegment:i];
        }
    }
    //Set default selection for buttons if exists
    NSInteger defaultSourceSelecion, defaultTargetSelection;
    defaultSourceSelecion = [[NSUserDefaults standardUserDefaults] integerForKey:@"sourceDefaultSelection"];
    defaultTargetSelection = [[NSUserDefaults standardUserDefaults] integerForKey:@"targetDefaultSelection"];
    
    if (defaultSourceSelecion)
        [_sourceSegmentedButton setSelectedSegment:defaultSourceSelecion];
    if (defaultTargetSelection)
        [_targetSegmentedButton setSelectedSegment:defaultTargetSelection];
    
    //Set default text field values
    NSString *defaultInput = [[NSUserDefaults standardUserDefaults] stringForKey:@"defaultInput"];
    NSString *defaultOutput = [[NSUserDefaults standardUserDefaults] stringForKey:@"defaultOutput"];
    if (defaultInput){
        [_inputText setString:defaultInput];
        runOnMainQueueWithoutDeadlocking(^{
            [_outputText setString:defaultOutput];
        
        });
    }
    //Show or hide clear text button, depending on the input text
    if ([[_inputText string]  isEqual: @""])
        _clearTextButton.hidden = YES;
    
    //Assign initial source and target language values
    [self updateTargetLanguage];
    [self updateSourceLanguage];
    
    [_inputText setTextColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    [_outputText setTextColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    [_inputText setInsertionPointColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    
}

-(void)viewWillAppear {
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

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);

    
}

- (void)receivedResponseFromRequest:(NSData *)data {
    //Convert received data to NSString using NSUTF8StringEncoding
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    //Retrieve language from Auto
        if([_sLanguage isEqualToString:@"Auto"]){
        _autoLanguageCode = [NSString new];
        _autoLanguageTitle = [NSString new];
        _autoLanguageCode = [strData parseAutoForLanguage];
           
            _autoLanguageTitle =  [[NSArray getValuesArray:YES] objectAtIndex:[[NSArray getKeysArray] indexOfObject:_autoLanguageCode]];;
        strData=[strData parseFirstDiveForAuto];
    }
        else
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
    if([sender selectedSegment]==0){
        [_sourceLanguageMenu popUpMenuPositioningItem:nil atLocation:[_sourceSegmentedButton calculateMenuOrigin] inView:_widgetMainView];
        
        //Update selected segment to sLanguage to avoid bug with clicking outside menu frame
        //If some error, select first segment
        if([_sourceSegmentedButton indexForSegmentWithLabel:_sLanguage]!=-1)
            [_sourceSegmentedButton setSelectedSegment:[_sourceSegmentedButton indexForSegmentWithLabel:_sLanguage]];
        else
            [_sourceSegmentedButton setSelectedSegment:1];
    }
    
    //Update languages
    [self updateTargetLanguage];
    [self updateSourceLanguage];
    
    //Perform request
    if(![[[_inputText textStorage] string] isEqualToString:@""])
        [self performGoogleRequest];
    
    //Save new selection to defaults
    _sourceDefaultSelection = [NSNumber numberWithInteger:[_sourceSegmentedButton selectedSegment]];
    [[NSUserDefaults standardUserDefaults] setObject:_sourceDefaultSelection forKey:@"sourceDefaultSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    [self updateSourceLanguage];
    [self updateTargetLanguage];
    
    //Perform request
    if(![[[_inputText textStorage] string] isEqualToString:@""])
        [self performGoogleRequest];
    
    
    //Save new selection to defaults
    _targetDefaultSelection = [NSNumber numberWithInteger:[_targetSegmentedButton selectedSegment]];
    [[NSUserDefaults standardUserDefaults] setObject:_targetDefaultSelection forKey:@"targetDefaultSelection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)prepareForExternalTranslate:(NSURLRequest *)request {
   
    //Prepare URL string and arrange view
    NSString *translatedURL=[NSString stringWithFormat:@"https://translate.googleusercontent.com/translate_c?act=url&depth=1&hl=en&ie=UTF8&prev=_t&rurl=translate.google.com&sl=%@&tl=%@&u=%@",[[NSArray getKeysArray] objectAtIndex: [[NSArray getValuesArray:YES] indexOfObject:_sLanguage]],[[NSArray getKeysArray] objectAtIndex: [[NSArray getValuesArray:YES] indexOfObject:_tLanguage]],[request.URL absoluteString]];
    
    runOnMainQueueWithoutDeadlocking(^{
        [self displayLinkToExternalResource];
        [_externalURL setString:translatedURL];
    });
   
    
}
-(void)displayLinkToExternalResource {
    
    //Hide main element
    _outputText.hidden=YES;
    
    //Fade in helper elements
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 1;
        _outPutTextHideBox.animator.alphaValue = 1;
        _openExternalLinkButton.animator.alphaValue=1;
    }
                        completionHandler:^{
                            //_outPutTextHideBox.alphaValue = 1;
                        }];


}

- (IBAction)openExternalLink:(id)sender {
    //Open defaut browser
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:_externalURL]];
}

-(void)sendTestRequest:(NSURLRequest *)request{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *receivedData, NSError *error) {
        if (!error)
            [self prepareForExternalTranslate: request];
    }];

}
-(void)textDidChange:(NSNotification *)notification{
  
    //Set helper element invisible
    [_openExternalLinkButton setAlphaValue:0.0];
    [_outPutTextHideBox setAlphaValue:0.0];
    
    //Set main element visible
    _outputText.hidden=NO;
    
    //Show the clear text button
    if (![[_inputText string]  isEqual: @""])
        _clearTextButton.hidden = NO;
    else
        _clearTextButton.hidden = YES;

    //Check if user provided a link to the input
    NSArray *requests=[RequestHandler getRequestsForExternalURL:[[[_inputText textStorage] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if(requests)
    {
        for(int i=0;i<requests.count;i++){
            [self sendTestRequest:[requests objectAtIndex:i]];
        }
    }
    
    //Update detected language for Auto section
    if (_autoLanguageTitle == nil && [_sourceSegmentedButton selectedSegment] == 1)
        [_sourceSegmentedButton setLabel:@"ⒶDetect" forSegment:1];
    
    else if ([_sourceSegmentedButton selectedSegment] == 1)
        [_sourceSegmentedButton setLabel:[NSString stringWithFormat: @"Ⓐ > (%@)", _autoLanguageTitle] forSegment:1];
    
    //If whitespace string output nothing
    if([[[_inputText textStorage]string]isEqualToString:@""])
        [self setOutputValue:@""];
    else if([[[_inputText textStorage] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        [self setOutputValue:@""];
    else {
        //If there is a quote, delete it and place cursor
        NSRange searchRange = [[[_inputText textStorage] string] rangeOfString:@"\""];
        if (searchRange.location != NSNotFound)
        {
            [_inputText setString:[[[_inputText textStorage] string] stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
            [_inputText setSelectedRange:NSMakeRange(searchRange.location,0) ];
        }
        //Then perform a request
        [self performGoogleRequest];
        _defaultInputText = [[_inputText textStorage] string];
        [[NSUserDefaults standardUserDefaults] setObject:_defaultInputText forKey:@"defaultInput"];
    }
    if ([[_outputText textStorage] string]) {
        _defaultOutputText = [[_outputText textStorage]string];
        [[NSUserDefaults standardUserDefaults] setObject:_defaultOutputText forKey:@"defaultOutput"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)sourceTabDropDownClick:(id)sender {
    //Push clicked menu element language to the button

    [_sourceSegmentedButton tryToPushNewSourceLanguage:[sender title]];
    
    //Update default values for button
    
    for (int i = 2; i < 4; i++) {
        
        [_sourceButtonDefaultValues setObject:[_sourceSegmentedButton labelForSegment:i] forKey:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_sourceButtonDefaultValues forKey:@"sourceDefault"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Update source language
    [self updateSourceLanguage];
}

- (void)targetTabDropDownClick:(id)sender {
    //Push clicked menu element language to the button
    [_targetSegmentedButton tryToPushNewTargetLanguage:[sender title]];
    
    //Update default values for button
    
    for (int i = 1; i < 4; i++) {
        
        [_targetButtonDefaultValues setValue:[_targetSegmentedButton labelForSegment:i] forKey:[NSString stringWithFormat:@"%d",i]];
       
    }

    [[NSUserDefaults standardUserDefaults] setObject:_targetButtonDefaultValues forKey:@"targetDefault"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //Update target language
    [self updateTargetLanguage];
}

-(IBAction)swapButton: (id)sender {
    
    //Swap languages if source language is not Auto
    if(![_sLanguage isEqualToString:@"Auto"]) {
        //Swap source language and target language buttons values
            [_sourceSegmentedButton tryToPushNewSourceLanguage:_tLanguage];
            [_targetSegmentedButton tryToPushNewTargetLanguage:_sLanguage];
        
        ////Update languages and perform request
        [self updateTargetLanguage];
        [self updateSourceLanguage];
        
        if(![[[_inputText textStorage] string] isEqualToString:@""])
            [self performGoogleRequest];
    }
    //Swap if Auto
    else
    {
        [_sourceSegmentedButton tryToPushNewSourceLanguage:_tLanguage];
        [_targetSegmentedButton tryToPushNewTargetLanguage:_autoLanguageTitle];
     
        [self updateTargetLanguage];
        [self updateSourceLanguage];
    }
}

- (IBAction)clearText:(id)sender {
    [_inputText setString:@""];
    _clearTextButton.hidden = YES;
}

-(void)updateSourceLanguage{
    if ([_sourceSegmentedButton selectedSegment] == 1)
        _sLanguage = @"Auto";
    else
        _sLanguage = [_sourceSegmentedButton labelForSegment: [_sourceSegmentedButton selectedSegment]];
}

-(void)updateTargetLanguage{
    _tLanguage = [_targetSegmentedButton labelForSegment: [_targetSegmentedButton selectedSegment]];
}

-(void)performGoogleRequest{
    
    
    NSURLRequest *request=[RequestHandler getRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[[_inputText textStorage] string]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *receivedData, NSError *error) {
        if (!error)
        {
            [self receivedResponseFromRequest:receivedData];
            
        }
    }];

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







