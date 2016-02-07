
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
    _localDefaults =[SavedInfo localDefaults];
    
    
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
    _dictionaryHandler=[RequestHandler NewDictionaryRequest];
    [_dictionaryHandler setDelegate:self];
    
    _clearTextButton.hidden = YES;
    _requestProgressIndicator.hidden = YES;
    
    _translateText=[NSAttributedString new];
    
    [_favouritesView setWantsLayer:YES];
    _favouritesView.layer.backgroundColor = [NSColor grayColor].CGColor;
    
    [self.view setAcceptsTouchEvents:YES];
    
    _initialTouches=[NSMutableArray new];
    
    
}

-(void)viewWillAppear{
    //Make window view without a toolbar and with controls inside
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.titlebarAppearsTransparent = YES;
    self.view.window.styleMask |= NSFullSizeContentViewWindowMask;
    [_sourceLanguageTable reloadData];
    [_targetLanguageTable reloadData];
    [self.view.window setBackgroundColor:[NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
    
    if([_localDefaults autoPushed]) {
        [self enableAutoLanguage:self];
        if([_localDefaults hasAutoLanguage])
            [_sourceLanguage setStringValue:[_localDefaults autoLanguage]];
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
        [_localDefaults setAutoPushed:YES];
        [_sourceLanguageTable deselectRow:[_sourceLanguageTable selectedRow]];
        if(!_inputText.ready)
            [self startRequest];
        
        
    }
    else {
        [_localDefaults setAutoPushed:NO];
        if([_sourceLanguageTable selectedRow]<0||[_sourceLanguageTable selectedRow]>4) {
            [_dataHandler pushNewSourceLanguage:[_sourceLanguage stringValue]];
        }
        //[_sourceLanguageTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
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
        [self startRequest];
    
}
-(void)targetLanguageTableSelectionDidChange:(NSString *)index {
    [_targetLanguage setStringValue:index];
    _tLanguage=index;
    if(!_inputText.ready&&_sLanguage&&_tLanguage)
        [self startRequest];
    
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
    [_outputText setString:@""];
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
                [self startRequest];
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
    else if([_inputText isEmpty]) {
        [_translateHandler cancelCurrentSession];
        [_dictionaryHandler cancelCurrentSession];
        [_requestProgressIndicator stopAnimation:self];
        _requestProgressIndicator.hidden = YES;
        [_inputText setReady:YES];
    }
    
    
    
    
    //Input text validation (clear button, requests and scrolling)
    if(!_inputText.ready) {
        //Scrolling validation
        InputScroll *inputScroll =(InputScroll *)[[_inputText superview] superview];
        if([[_inputText string] characterAtIndex:[[_inputText string] length]-1]=='\n'||numberOfLines>1)
            [inputScroll setScrolling:YES];
        else
            [inputScroll setScrolling:NO];
        
        _clearTextButton.hidden = NO;
        if(![_inputText isWhiteSpace]){
            if ([_liveTranslate state])
                [self startRequest];
        }
        else
            [_outputText setString:@""];
        
    }
    else {
        _clearTextButton.hidden = YES;
        [_outputText setString:@""];
    }
    
    
    
}



- (NSRange)textView:(NSTextView *)aTextView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange) newSelectedCharRange {
    if(_inputText.ready)
        return NSMakeRange(0, 0);
    else
        return newSelectedCharRange;
}
-(void)performTranslateRequest {
    [_translateHandler performRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
    _requestProgressIndicator.hidden = NO;
    [_requestProgressIndicator startAnimation:self];
    
}
-(void)receiveTranslateResponse:(NSArray *)data {
    
    NSFont *translateResponseFont = [NSFont systemFontOfSize:16.0];
    NSDictionary *translateResponseFontAttributes = @{NSFontAttributeName : translateResponseFont};
    _translateText = [[NSAttributedString alloc]initWithString: (NSString *)data[1] attributes:translateResponseFontAttributes];
    
    if([_sLanguage isEqualToString:@"Auto" ]) {
        _autoLanguage=(NSString *)data[0];
        if(_autoLanguage&&_autoLanguage.length>0) {
            [_localDefaults setAutoLanguage:_autoLanguage];
            [_sourceLanguage setStringValue:_autoLanguage];
        }
    }
    
    _requestProgressIndicator.hidden = YES;
    [_requestProgressIndicator stopAnimation:self];
    
    [self performDictionaryRequest];
}
-(void)performDictionaryRequest {
    
    
    if(![_sLanguage isEqualToString:@"Auto" ])
        [_dictionaryHandler performRequestForSourceLanguage:_sLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
    
    else {
        if(_autoLanguage&&_autoLanguage.length>0)
            [_dictionaryHandler performRequestForSourceLanguage:_autoLanguage TargetLanguage:_tLanguage Text:[_inputText string]];
        else {
            [[_outputText textStorage] setAttributedString:_translateText];
            return;
        }
    }
    
    
    
    _requestProgressIndicator.hidden = NO;
    [_requestProgressIndicator startAnimation:self];
}


-(void)receiveDictionaryResponse:(NSArray *)data {
    
    NSDictionary *receivedData=(NSDictionary *)data[0];
    NSString *inputWord=[receivedData objectForKey:@"text"];
    
    if([inputWord length]>0)
        [[_outputText textStorage] setAttributedString:[Parser outputStringForMainAppDictionary:receivedData]];
    else
        [[_outputText textStorage] setAttributedString:_translateText];
    
    [_requestProgressIndicator stopAnimation:self];
    _requestProgressIndicator.hidden = YES;
}






-(void)startRequest {
    [_translateHandler cancelCurrentSession];
    [_dictionaryHandler cancelCurrentSession];
    _translateText=[[NSAttributedString alloc] initWithString:@""];
    _autoLanguage=@"";
    [self performTranslateRequest];
}


- (void)touchesBeganWithEvent:(NSEvent *)event {
    
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:self.view];
    if (touches.count == 2) {
        NSArray *array = [touches allObjects];
        [_initialTouches insertObject:[array objectAtIndex:0] atIndex:0];
        [_initialTouches insertObject:[array objectAtIndex:1] atIndex:1];
    } else if(touches.count>2) {
        // More than 2 touches. Only track 2.
        if(_initialTouches)
            [_initialTouches removeAllObjects];
        
    }
    
}
- (void)touchesMovedWithEvent:(NSEvent *)event{
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:self.view];
    if (touches.count == 2) {
        
        NSArray *array = [touches allObjects];
        NSTouch *currentTouch = [array objectAtIndex:0];
        
        if(_initialTouches.count==2) {
            
            
            NSTouch *initialTouch = [_initialTouches objectAtIndex:0];
            
            CGFloat firstDelta;
            CGFloat secondDelta;
            
            if([currentTouch.identity isEqual:initialTouch.identity]) {
                firstDelta = currentTouch.normalizedPosition.x-initialTouch.normalizedPosition.x;
                
                currentTouch = [array objectAtIndex:1];
                initialTouch = [_initialTouches objectAtIndex:1];
                
                secondDelta = currentTouch.normalizedPosition.x-initialTouch.normalizedPosition.x;
            }
            else {
                currentTouch = [array objectAtIndex:1];
                firstDelta = currentTouch.normalizedPosition.x-initialTouch.normalizedPosition.x;
                
                currentTouch = [array objectAtIndex:0];
                initialTouch = [_initialTouches objectAtIndex:1];
                
                secondDelta = currentTouch.normalizedPosition.x-initialTouch.normalizedPosition.x;
            }
            if(firstDelta!=0||secondDelta!=0){
                NSLog(@"Moved right, delta1: %f, delta2: %f",firstDelta,secondDelta);
                [_favouritesView changeOrigin:((firstDelta+secondDelta)/2)*3000];
            }
            /* else if(firstDelta<0&&secondDelta<0){
             NSLog(@"Moved left, delta1: %f, delta2: %f",firstDelta,secondDelta);
             }*/
            
            [_initialTouches insertObject:[array objectAtIndex:0] atIndex:0];
            [_initialTouches insertObject:[array objectAtIndex:1] atIndex:1];
        }
        else {
            [_initialTouches removeAllObjects];
            [_initialTouches insertObject:array[0] atIndex:0];
            [_initialTouches insertObject:array[1] atIndex:1];
        }
    }
}
- (void)touchesEndedWithEvent:(NSEvent *)event{
    NSSet *endedTouches = [event touchesMatchingPhase:NSTouchPhaseEnded inView:self.view];
    NSSet *initialSet=[[NSSet alloc] initWithArray:_initialTouches];
    
    if(_initialTouches.count>0) {
        [endedTouches intersectsSet:initialSet];
        if(endedTouches.count==2){
            NSLog(@"lol");
            [_initialTouches removeAllObjects];
            [_favouritesView checkState];
        }
        else if(endedTouches.count==1){
            if(_initialTouches.count==1){
                NSLog(@"lol");
                [_initialTouches removeAllObjects];
                [_favouritesView checkState];
            } else if(_initialTouches.count==2){
                NSArray *array=[initialSet allObjects];
                NSTouch *detectedTouch=[array objectAtIndex:0];
                NSTouch *secondTouch=[_initialTouches objectAtIndex:1];
                
                if([secondTouch.identity isEqual:detectedTouch])
                    [_initialTouches removeLastObject];
                else {
                    [_initialTouches removeAllObjects];
                    [_initialTouches addObject:secondTouch];
                }
                
            }
        }
    }
}
- (void)touchesCancelledWithEvent:(NSEvent *)event{
    if(_initialTouches)
        [_initialTouches removeAllObjects];
}

@end

