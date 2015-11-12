//
//  ViewController.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController {
    BOOL returnInInputPressed;
    int readyInputLength;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    //Create language menus
    _sourceLanguageMenu = [PopupMenu createMenuWithAction:@"sourceMenuClick:" andSender:self];
    _targetLanguageMenu = [PopupMenu createMenuWithAction:@"targetMenuClick:" andSender:self];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //Remove focus rings from table views
    [_targetLanguageTable setFocusRingType:NSFocusRingTypeNone];
    [_sourceLanguageTable setFocusRingType:NSFocusRingTypeNone];
    [_dataHandler setDelegate:self];
    [_sourceLanguage setDelegate:self];
    [_targetLanguage setDelegate:self];
   

    [[NSApp mainMenu] addItem: [MainApplicationMenu createFileMenu]];
    [[NSApp mainMenu] addItem: [MainApplicationMenu createEditMenu]];
    
    _liveTranslate = [[[[NSApp mainMenu] itemAtIndex:1] submenu] itemAtIndex:0];

    [_sourceLanguageTable setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    [_targetLanguageTable setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    
    [_inputText setDelegate:self];
    [_inputText setReady:YES];
  
    readyInputLength=14;
    
    _translateHandler = [RequestHandler NewTranslateRequest];
    [_translateHandler setDelegate:self];

    _clearTextButton.hidden = YES;
    _requestProgressIndicator.hidden = YES;

}

-(void)viewWillAppear{
    //Make window view without a toolbar and with controls inside
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.titlebarAppearsTransparent = YES;
    self.view.window.styleMask |= NSFullSizeContentViewWindowMask;
    [_sourceLanguageTable reloadData];
    [_targetLanguageTable reloadData];
    [self.view.window setBackgroundColor:[NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    
    
    _sharedDefaults =[SavedInfo sharedDefaults];
    if([_sharedDefaults autoPushed]) {
        [self enableAutoLanguage:self];
        if([_sharedDefaults hasAutoLanguage])
            [_sourceLanguage setStringValue:[_sharedDefaults autoLanguage]];
    }
    
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


- (IBAction)enableAutoLanguage:(id)sender {
    
 
    NSImage *tmp = [_autoLanguageButton image];
    [_autoLanguageButton setImage:[_autoLanguageButton alternateImage]];
    [_autoLanguageButton setAlternateImage:tmp];
    if(sender==self) {
        NSInteger state=[_autoLanguageButton state];
        switch (state) {
            case 0:
                [_autoLanguageButton setState:1];
                
                break;
            case 1:
                [_autoLanguageButton setState:0];
                break;
            default:
                break;
        }
        
    }
    
    if ([_autoLanguageButton state]) {
        _sLanguage = @"Auto";
        [_sharedDefaults setAutoPushed:YES];
        [_sourceLanguageTable deselectRow:[_sourceLanguageTable selectedRow]];
        if(!_inputText.ready)
            [self performRequest];
    }
    else {
        [_sharedDefaults setAutoPushed:NO];
        if([_sourceLanguageTable selectedRow]<0||[_sourceLanguageTable selectedRow]>4)
            [_sourceLanguageTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
    
    
}



//Swap button implementation
- (IBAction)swapButton:(id)sender {
   //Swap selected table cells
    NSString * selectedSource;
    NSString * selectedTarget;
    if([_autoLanguageButton state]) {
        selectedSource = [_sourceLanguage stringValue];
        selectedTarget = _tLanguage;
    }
    else {
        selectedSource = _sLanguage;
        selectedTarget = _tLanguage;

    }
   
    [_dataHandler pushNewSourceLanguage:selectedTarget];
    [_dataHandler pushNewTargetLanguage:selectedSource];
    
}

//Updating tables with new entries
-(void)sourceMenuClick:(id)sender{
    [_dataHandler pushNewSourceLanguage:[sender title]];
}
-(void)targetMenuClick:(id)sender{
    [_dataHandler pushNewTargetLanguage:[sender title]];
}

//Responding to a language table selection
-(void)sourceLanguageTableSelectionDidChange:(NSString *)index {
    [_sourceLanguage setStringValue:index];
    _sLanguage=index;
   if( [_autoLanguageButton state])
       [self enableAutoLanguage:self];
    if(!_inputText.ready&&_sLanguage&&_tLanguage)
        [self performRequest];
    
}
-(void)targetLanguageTableSelectionDidChange:(NSString *)index {
    [_targetLanguage setStringValue:index];
    _tLanguage=index;
    if(!_inputText.ready&&_sLanguage&&_tLanguage)
        [self performRequest];
}

//Creating menu at button
- (IBAction)showSourceMenu:(id)sender {
    [NSMenu popUpContextMenu:_sourceLanguageMenu withEvent:[NSApp currentEvent] forView:sender];
}

- (IBAction)showTargetMenu:(id)sender {
    [NSMenu popUpContextMenu:_targetLanguageMenu withEvent:[NSApp currentEvent] forView:sender];
}

- (IBAction)clearTextButtonAction:(id)sender {
    [_inputText setReady:YES];
    [_outputText setStringValue:@""];
    _clearTextButton.hidden = YES;
}


-(void)controlTextDidChange:(NSNotification *)obj{
    //This should be an array of all available languages
   /* NSArray *arrayOfLanguages=[[NSArray alloc ]initWithObjects:@"English",@"Russian",@"Egyptian", nil];
    NSMutableArray *arrayOfPossibleOutputs=[NSMutableArray new];
    
    NSString *inputString=[NSString new];
    if([obj object]==_sourceLanguage)
        inputString=[_sourceLanguage stringValue];
    
    else if([obj object]==_targetLanguage)
        inputString=[_targetLanguage stringValue];
    

    if(inputString) {
        
        NSString *pattern=[NSString stringWithFormat:@"^%@.*",inputString];
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:pattern
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        
        
        for(int i=0;i<arrayOfLanguages.count;i++){
            
            NSString *string=[arrayOfLanguages objectAtIndex:i];
                
            NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
            
            if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                NSString *substringForFirstMatch = [string substringWithRange:rangeOfFirstMatch];
                [arrayOfPossibleOutputs addObject:string];
            }

            
        }
    
    }
    
    if([arrayOfPossibleOutputs count]==0)
        NSLog(@"Not found");
    else
        NSLog(@"%@",arrayOfPossibleOutputs);*/
    
   
    
    
    
}

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector {
    
    BOOL stat=NO;
    NSUInteger flags = [[NSApp currentEvent] modifierFlags]&NSDeviceIndependentModifierFlagsMask;
    NSUInteger key=[[NSApp currentEvent] keyCode];
    
    if([_liveTranslate state]){
        if(key == 0x24 || key == 0x4C) {
            stat=YES;
            [aTextView insertNewlineIgnoringFieldEditor:self];
        }
    }
    else {
        if(key == 0x24 || key == 0x4C) {
            if(!flags) {
                [self performRequest];
                stat=YES;
            }
            
            else
                if(flags&NSCommandKeyMask) {
                    stat=YES;
                    [aTextView insertNewlineIgnoringFieldEditor:self];
                }
            
        }
        
    }
    
    
    return stat;
}

-(void)textDidChange:(NSNotification *)notification {
    //Counting number of lines
    NSLayoutManager *layoutManager = [_inputText layoutManager];
    unsigned long numberOfLines, index, numberOfGlyphs = [layoutManager numberOfGlyphs];
    NSRange lineRange;
    for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange];
        index = NSMaxRange(lineRange);
    }
    
    
    
    
    //Ready validation
    if(_inputText.ready) {
        if(_inputText.string.length>readyInputLength) {
            [_inputText setReady:NO];
            NSString *userString=[[_inputText string] stringByReplacingCharactersInRange:NSMakeRange(_inputText.string.length-readyInputLength, readyInputLength) withString:@""];
            [_inputText setString:userString];
        }
    }
    else if([_inputText.string isEmpty])
            [_inputText setReady:YES];
    
    
    
    //Input text validation (clear button, requests and scrolling)
    if(!_inputText.ready) {
        //Scrolling validation
        InputScroll *inputScroll =(InputScroll *)[[_inputText superview] superview];
        if([[_inputText string] characterAtIndex:[[_inputText string] length]-1]=='\n'||numberOfLines>1)
            [inputScroll setScrolling:YES];
        else
            [inputScroll setScrolling:NO];
        
        _clearTextButton.hidden = NO;
        if(![[_inputText string] isWhiteSpace]){
            if ([_liveTranslate state])
                [self performRequest];
        }
        else
            [_outputText setStringValue:@""];
        
    }
    else {
        _clearTextButton.hidden = YES;
        [_outputText setStringValue:@""];
    }
    



}

- (NSRange)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange) newSelectedCharRange {
    if(_inputText.ready)
        return NSMakeRange(0, 0);
    else
        return newSelectedCharRange;
}
-(void)performRequest {
    if (_inputText.isEmpty == NO && _inputText.isWhiteSpace == NO){
        _requestProgressIndicator.hidden = NO;
        [_requestProgressIndicator startAnimation:self];
        
        [_translateHandler performRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
    }
}

-(void)receiveTranslateResponse:(NSArray *)data {
    if([_sLanguage isEqualToString:@"Auto" ]) {
        [_sharedDefaults setAutoLanguage:(NSString *)data[0]];
        [_sourceLanguage setStringValue:(NSString *)data[0]];
    }
    if(!_inputText.ready)
        [_outputText setStringValue:(NSString *)data[1]];
    [_requestProgressIndicator stopAnimation:self];
    _requestProgressIndicator.hidden = YES;
}

@end
