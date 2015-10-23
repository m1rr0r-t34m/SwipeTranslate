//
//  DataSource.h
//  googleTranslateWidget
//
//  Created by Andrei on 23/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface DataSource : NSArrayController{
    IBOutlet NSTableView* tableView;
    NSMutableArray* dataObject;
}

@property  NSMutableArray* dataObject;
@property  NSTableView* tableView;

-(int)numberOfRowsInTableView:(NSTableView*) tableView;
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex;
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;



@end
