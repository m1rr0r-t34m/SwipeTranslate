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

@synthesize  dataObject;
@synthesize tableView;

-(void)awakeFromNib{
    dataObject = [NSMutableArray arrayWithArray:@[@"Finnish", @"English", @"Russian", @"Latin", @"French"]];
    [tableView reloadData];
}

-(int)numberOfRowsInTableView:(NSTableView *)tableView {
    return (int)[self.dataObject count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex {
    return [dataObject objectAtIndex:rowIndex];
}

- (NSCell *)tableView:(NSTableView *)tableView
dataCellForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row{

    NSCell *sourceLanguageHeaderCell = [NSCell new];
    sourceLanguageHeaderCell.selectable = FALSE;
    sourceLanguageHeaderCell.alignment = NSRightTextAlignment;
    sourceLanguageHeaderCell.stringValue = @"test";
    return sourceLanguageHeaderCell;
    
}


@end