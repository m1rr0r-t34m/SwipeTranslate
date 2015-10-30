//
//  ViewController.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController


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
    
  
}

-(void)viewWillAppear{
    //Make window view without a toolbar and with controls inside
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.titlebarAppearsTransparent = YES;
    self.view.window.styleMask |= NSFullSizeContentViewWindowMask;
    [_sourceLanguageTable reloadData];
    [_targetLanguageTable reloadData];
    
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
    
}
-(void)targetLanguageTableSelectionDidChange:(NSString *)index {
    [_targetLanguage setStringValue:index];
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
    NSArray *arrayOfLanguages=[[NSArray alloc ]initWithObjects:@"English",@"Russian",@"Egyptian", nil];
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
        NSLog(@"%@",arrayOfPossibleOutputs);
    
    
    
}

@end
