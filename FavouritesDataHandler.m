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
    [favouritesTable reloadData];
}

-(int)numberOfRowsInTableView:(NSTableView*) tableView{
    if(favouritesData)
        return (int)[favouritesData count];
    else
        return 0;
}
-(void)pushFavouritesArray:(NSMutableArray *)array {
    favouritesData = [[NSMutableArray alloc] initWithArray:array];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex{
    if (tableView == favouritesTable){
        if(favouritesData) {
            NSDictionary *dict = [favouritesData objectAtIndex:rowIndex];
            
            NSData *inputData = [dict objectForKey:@"input"];
            NSData *outputData = [dict objectForKey:@"output"];
            
            NSMutableAttributedString* inputString = [[NSMutableAttributedString alloc] initWithRTFD:inputData
                                                                                       documentAttributes:nil];
            NSMutableAttributedString* outputString = [[NSMutableAttributedString alloc] initWithRTFD:outputData
                                                                                        documentAttributes:nil];

            if(inputString && outputString) {
                NSMutableAttributedString *finalString = [NSMutableAttributedString new];
                [finalString appendAttributedString:inputString];
                [finalString appendAttributedString:outputString];
                return finalString;
            }

                
                
            
        }
        
    }
    
    return nil;
}

@end
