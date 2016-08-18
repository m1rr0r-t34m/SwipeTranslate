//
//  MainViewController.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "MainViewController.h"
#import "STLanguageCell.h"

@interface MainViewController ()

@property (weak) IBOutlet NSTableView *sourceLanguageTableView;
@property (weak) IBOutlet NSTableView *targetLanguageTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.sourceLanguageTableView setDelegate:self];
    [self.sourceLanguageTableView setDataSource:self];
    [self.sourceLanguageTableView reloadData];
}

//-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
//    return 50;
//}

//-(NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    
//    STLanguageCell *cell =[NSC new];
//    
//    [cell setStringValue:@"Hello"];
//    [cell setTextColor:[NSColor redColor]];
//    
//    return cell;
//}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    STLanguageCell *cell = [tableView makeViewWithIdentifier:@"languageCell" owner:self];
    
    //[cell setFrame:NSMakeRect(0, 0, 50, 50)];
    NSTextField *field = cell.Label;
    [cell.Label setTextColor:[NSColor redColor]];
    [cell.Label setStringValue:@"MYYY"];
    return cell;
}

//-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    return @"MY";
//}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 5;
}

@end
