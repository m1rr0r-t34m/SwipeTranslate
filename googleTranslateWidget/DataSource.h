//
//  DataSource.h
//  googleTranslateWidget
//
//  Created by Andrei on 23/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "DataSourceDelegate.h"

@interface DataSource : NSObject{
    IBOutlet NSTableView* targetTableView;
    IBOutlet NSTableView* sourceTableView; 
    NSMutableArray* dataObject;
}

@property(readwrite, assign) id<DataSourceDelegate>delegate;
@property  NSMutableArray* sourceLanguageList;
@property NSMutableArray* targetLanguageList; 
//@property  NSTableView* tableView;

-(int)numberOfRowsInTableView:(NSTableView*) tableView;
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex;
//- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
-(void)pushNewTargetLanguage:(NSString *)language;
-(void)pushNewSourceLanguage:(NSString *)language;


@end
