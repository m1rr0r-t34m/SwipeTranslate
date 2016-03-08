//
//  FavouritesDataHandler.m
//  googleTranslateWidget
//
//  Created by Andrei on 11/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "FavouritesDataHandler.h"

@implementation FavouritesDataHandler


-(void)awakeFromNib{
    [_favouritesTable reloadData];
}


-(NSInteger)numberOfRowsInTableView:(NSTableView*) tableView{
    if(favouritesData)
        return (NSInteger)[favouritesData count];
    else
        return 0;
}
-(void)pushFavouritesArray:(NSMutableArray *)array {
    favouritesData = [[NSMutableArray alloc] initWithArray:array];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _favouritesTable){
        
        NSDictionary *dict = [favouritesData objectAtIndex:row];
        
        
        //Determening styles for both textViews in the table
        
        NSFont *inputStyleFont = [NSFont systemFontOfSize:18 weight:NSFontWeightLight];
        NSFont *outputStyleFont = [NSFont systemFontOfSize:14 weight:NSFontWeightLight];
        
        NSDictionary *inputStyle = @{NSFontAttributeName : inputStyleFont};
        NSDictionary *outputStyle = @{NSFontAttributeName : outputStyleFont,NSForegroundColorAttributeName : [NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:1]};
        
        //Extracting attributed strings from data storage

        
        NSMutableAttributedString* input = [[NSMutableAttributedString alloc] initWithRTFD:[dict objectForKey:@"input"]
                                                                               documentAttributes:nil];

        
        NSMutableAttributedString* output = [[NSMutableAttributedString alloc] initWithRTFD:[dict objectForKey:@"output"]
                                                                        documentAttributes:nil];
        
        //Removing unwanted returns from outpur string
        

        NSString *replacementString = [[NSString alloc] initWithString:output.string] ;
        replacementString = [replacementString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
        [output replaceCharactersInRange:NSMakeRange(0, [replacementString length]) withString:replacementString];
        
        //Applying attributes
        
        
        [input setAttributes:inputStyle range:NSMakeRange(0, [input length])];
        [output setAttributes:outputStyle range:NSMakeRange(0, [output length])];

       //Building up a view for the table cell
        
        
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 50)];
        [view setWantsLayer:YES];
        
        
        NSTextField *result = [[NSTextField alloc] initWithFrame:NSMakeRect(15, 30, 285, 20)];
        NSTextField *result2 = [[NSTextField alloc] initWithFrame:NSMakeRect(15, 10, 285, 20)];
        
        
        [result setDrawsBackground:NO];
        [result setBordered:NO];
        [result2 setDrawsBackground:NO];
        [result2 setBordered:NO];
        
        [result setEditable:false];
        [result2 setEditable:false];
        [result setSelectable:false];
        [result2 setSelectable:false];
        
        [result setAttributedStringValue:input];
        [result2 setAttributedStringValue:output];
        
        //Create a remove button
        
        NSButton *removeButton = [NSButton new];
        [removeButton setFrame:NSMakeRect(260, 30, 20, 20)];
        [removeButton setTitle:@"X"];
        [removeButton setBordered:NO];
        [removeButton setTag:row];
        [removeButton setTarget:self];
        [removeButton setAction:@selector(removeTableRow:)];
        
        [view setSubviews:@[result,result2, removeButton]];
        [view setNeedsDisplay:YES];

        
        return view;
        
    
    }
    return nil;
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    int index=(int)[[notification object] selectedRow];
    
    if([notification object]==_favouritesTable) {
        
        [_delegate favouritesTableSelectionDidChange:index];
     /*   NSTextField *secondField = [[[_favouritesTable viewAtColumn:0 row:index makeIfNecessary:NO] subviews] objectAtIndex:1];
        
        //Update color of selected textFiled text
        NSFont *outputStyleFont = [NSFont systemFontOfSize:14 weight:NSFontWeightLight];
        NSDictionary *outputStyle = @{NSFontAttributeName : outputStyleFont,NSForegroundColorAttributeName : [NSColor whiteColor]};
        
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[secondField stringValue] attributes:outputStyle];
       
        
        [secondField setAttributedStringValue:string];*/
        
        

        
    }
}

//Remove a table row with animation

-(void)removeTableRow:(id)sender {
    
    [CATransaction begin];
    
    [_favouritesTable beginUpdates];
    
    [CATransaction setCompletionBlock: ^{
        [self.favouritesTable reloadData];
    }];
    
    [_favouritesTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:[sender tag]] withAnimation:NSTableViewAnimationSlideRight];
    
    [_favouritesTable endUpdates];
    
    [CATransaction commit];
    
    [favouritesData removeObjectAtIndex:[sender tag]];
    [_delegate deleteFavouritesTableEntry:[sender tag]];
}

@end
