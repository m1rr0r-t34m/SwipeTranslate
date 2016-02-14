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
        
        NSFont *inputStyleFont = [NSFont systemFontOfSize:16 weight:NSFontWeightBold];
        NSFont *outputStyleFont = [NSFont systemFontOfSize:15 weight:NSFontWeightLight];
        
        NSDictionary *inputStyle = @{NSFontAttributeName : inputStyleFont};
        NSDictionary *outputStyle = @{NSFontAttributeName : outputStyleFont};
        
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
        
        
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 60)];
        [view setWantsLayer:YES];
        
        
        NSTextField *result = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 30, 300, 30)];
        NSTextField *result2 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 30)];
        
        [result setDrawsBackground:NO];
        [result setBordered:NO];
        [result2 setDrawsBackground:NO];
        [result2 setBordered:NO];
        
        [result setAttributedStringValue:input];
        [result2 setAttributedStringValue:output];

        [view setSubviews:@[result,result2]];
        [view setNeedsDisplay:YES];

        
        return view;
        
    
    }
    return nil;
}

@end
