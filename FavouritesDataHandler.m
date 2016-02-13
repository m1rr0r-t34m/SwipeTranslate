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

        
        NSMutableAttributedString* input = [[NSMutableAttributedString alloc] initWithRTFD:[dict objectForKey:@"input"]
                                                                               documentAttributes:nil];
        NSAttributedString* output = [[NSMutableAttributedString alloc] initWithRTFD:[dict objectForKey:@"output"]
                                                                              documentAttributes:nil];
        
        

       /* NSMutableDictionary *styles = [NSMutableDictionary new];
        [styles setObject:[NSFont systemFontOfSize:16.0 weight:NSFontWeightLight] forKey:NSFontAttributeName];
        
        NSMutableAttributedString *outputString = [[NSMutableAttributedString alloc] initWithString:[output stringByReplacingOccurrencesOfString:@"\r" withString:@" "] attributes:styles];*/
        

       // [string repla]
        
        
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 100)];

        

        NSTextField *result = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 50, 300, 50)];
        NSTextField *result2 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 50)];
        
        [result setAttributedStringValue:input];
        [result2 setAttributedStringValue:output];

        [view setSubviews:@[result,result2]];
        [view setNeedsDisplay:YES];

        
        return view;
        
    
    }
    return nil;
}

@end
