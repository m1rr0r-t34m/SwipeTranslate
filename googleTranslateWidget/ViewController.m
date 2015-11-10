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
    
    [_sourceLanguageTable setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    [_targetLanguageTable setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    
    
    [_inputText setDelegate:self];

    readyInputLength=14;

    
}

-(void)viewWillAppear{
    //Make window view without a toolbar and with controls inside
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.titlebarAppearsTransparent = YES;
    self.view.window.styleMask |= NSFullSizeContentViewWindowMask;
    [_sourceLanguageTable reloadData];
    [_targetLanguageTable reloadData];
    [self.view.window setBackgroundColor:[NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    [_inputText setReady:YES];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


- (IBAction)enableLiveTranslate:(id)sender {
}

- (IBAction)enableAutoLanguage:(id)sender {
    
    if ([_autoLanguageButton state]) {
        _sLanguage = @"auto";
    }
    NSImage *tmp = [sender image];
    [sender setImage:[sender alternateImage]];
    [sender setAlternateImage:tmp];
        
    
}

//Swap button implementation
- (IBAction)swapButton:(id)sender {
   //Swap selected table cells
    NSInteger selectedSourceRow = [_sourceLanguageTable selectedRow];
    NSInteger selectedTargetRow = [_targetLanguageTable selectedRow];
    [_sourceLanguageTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedTargetRow] byExtendingSelection:FALSE];
    [_targetLanguageTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedSourceRow] byExtendingSelection:FALSE];
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
    
}
-(void)targetLanguageTableSelectionDidChange:(NSString *)index {
    [_targetLanguage setStringValue:index];
    _tLanguage=index;
}

//Creating menu at button
- (IBAction)showSourceMenu:(id)sender {
    [NSMenu popUpContextMenu:_sourceLanguageMenu withEvent:[NSApp currentEvent] forView:sender];
}

- (IBAction)showTargetMenu:(id)sender {
    [NSMenu popUpContextMenu:_targetLanguageMenu withEvent:[NSApp currentEvent] forView:sender];
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

-(void)textDidChange:(NSNotification *)notification {
    //Check if theres more than 1 line in inputText
   /* NSLayoutManager *layoutManager = [_inputText layoutManager];
    unsigned long numberOfLines, index, numberOfGlyphs = [layoutManager numberOfGlyphs];
    NSRange lineRange;
    for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange];
        index = NSMaxRange(lineRange);
    }
    

    if(![[_inputText string] isEmpty]) {
        if([[_inputText string] characterAtIndex:[[_inputText string] length]-1]=='\n')
            returnInInputPressed=YES;
        else
            returnInInputPressed=NO;
    }
    else
        returnInInputPressed=NO;
    
    if(returnInInputPressed&&!_inputText.open)
        [_inputText unfold];
    if(numberOfLines>1&&!_inputText.open)
        [_inputText unfold];
    else if(numberOfLines<2&&_inputText.open&&!returnInInputPressed)
        [_inputText fold]; */
    
    
    
    if(!(_inputText.isWhiteSpace||_inputText.isEmpty||_inputText.ready)) {
        [self performRequest];
    }
    else if(_inputText.ready) {
        if(_inputText.string.length>readyInputLength) {
            [_inputText setReady:NO];
            NSString *userString=[[_inputText string] stringByReplacingCharactersInRange:NSMakeRange(_inputText.string.length-readyInputLength, readyInputLength) withString:@""];
            [_inputText setString:userString];
        }
        
    }
    else if(_inputText.isEmpty) {
        [_outputText setStringValue:@""];
        [_inputText setReady:YES];
    }

    else if(_inputText.isWhiteSpace)
        [_outputText setStringValue:[_inputText string]];

}

- (NSRange)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange) newSelectedCharRange {
    if(_inputText.ready)
        return NSMakeRange(0, 0);
    else
        return newSelectedCharRange;
}
-(void)performRequest {
    RequestHandler *handler = [RequestHandler NewTranslateRequest];
    [handler setDelegate:self];
    [handler performRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
}
-(void)receiveTranslateResponse:(NSArray *)data {
    [_outputText setStringValue:(NSString *)data[1]];
}

@end
