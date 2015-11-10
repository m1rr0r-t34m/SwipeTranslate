//
//  DataSource.m
//  googleTranslateWidget
//
//  Created by Andrei on 23/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

@implementation DataSource

@synthesize  sourceLanguageList;
@synthesize targetLanguageList;
//@synthesize tableView;

//Data handling methods
-(void)awakeFromNib{
    if (![SavedInfo hasLanguages]){
    sourceLanguageList = [NSMutableArray arrayWithArray:@[@"Finnish", @"English", @"Russian", @"French", @"Latin"]];
    targetLanguageList = [NSMutableArray arrayWithArray:@[@"Finnish", @"English", @"Russian", @"French", @"Latin"]];
    }
    else {
        sourceLanguageList = [[SavedInfo sourceLanguages] mutableCopy];
        targetLanguageList = [[SavedInfo targetLanguages] mutableCopy];
        }
    [sourceTableView reloadData];
    [targetTableView reloadData];
}
//Pushing new languages
-(void)pushNewSourceLanguage:(NSString *)language {
    BOOL isHighlighted = FALSE;
    for (int i = 0; i < [sourceLanguageList count]; i++){
        if ([language isEqualToString:[sourceLanguageList objectAtIndex:i]]){
            [sourceTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:FALSE];
            [sourceTableView reloadData];
            isHighlighted = TRUE;
        }
    }
    if (isHighlighted == FALSE){
    [sourceLanguageList insertObject:language atIndex:0];
    [sourceLanguageList removeObjectAtIndex:5];
    [sourceTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:FALSE];
    [SavedInfo setSourceLanguages:sourceLanguageList];
    [sourceTableView reloadData];
    }
}
-(void)pushNewTargetLanguage:(NSString *)language {
    BOOL isHighlighted = FALSE;
    for (int i = 0; i < [targetLanguageList count]; i++){
        if ([language isEqualToString:[targetLanguageList objectAtIndex:i]]){
            [targetTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:FALSE];
            [targetTableView reloadData];
            isHighlighted = TRUE;
        }
    }
    if (isHighlighted == FALSE){
    [targetLanguageList insertObject:language atIndex:0];
    [targetLanguageList removeObjectAtIndex:5];
    [targetTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:FALSE];
    [SavedInfo setTargetLanguages:targetLanguageList];
    [targetTableView reloadData];
    }
}


//Table delegate methods
-(int)numberOfRowsInTableView:(NSTableView *)tableView {
    return (int)[self.sourceLanguageList count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex {
    if (tableView == sourceTableView)
        return [sourceLanguageList objectAtIndex:rowIndex];
    else if (tableView == targetTableView)
        return [targetLanguageList objectAtIndex:rowIndex];
    else
        return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    int index=(int)[[aNotification object] selectedRow];
    
    if([aNotification object]==sourceTableView)
        [_delegate sourceLanguageTableSelectionDidChange:[sourceLanguageList objectAtIndex:index]];
    else if([aNotification object]==targetTableView)
        [_delegate targetLanguageTableSelectionDidChange:[targetLanguageList objectAtIndex:index]];
}

/*- (NSCell *)tableView:(NSTableView *)tableView
dataCellForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row{
    
    NSCell *sourceLanguageHeaderCell = [NSCell new];
    if (row == 1){
    sourceLanguageHeaderCell.selectable = FALSE;
    sourceLanguageHeaderCell.alignment = NSRightTextAlignment;
    sourceLanguageHeaderCell.stringValue = @"test";
    }
    else
    {
        sourceLanguageHeaderCell.alignment = NSLeftTextAlignment;
        sourceLanguageHeaderCell.stringValue = @"test";
    }
        
        return sourceLanguageHeaderCell;
    
    
}*/


@end