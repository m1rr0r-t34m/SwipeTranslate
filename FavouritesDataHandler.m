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
    _initialData = [[NSMutableArray alloc] initWithArray:@[@"Good evening", @"Добрый вечер", @"I am a dispatch", @"Я диспетчер"]] ;
    [favouritesTable reloadData];
}

-(int)numberOfRowsInTableView:(NSTableView*) tableView{
        return (int)[self.initialData count];
}


-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)rowIndex{
    if (tableView == favouritesTable){
        
        NSLog(@"%@", [_initialData objectAtIndex:rowIndex]);
        return [_initialData objectAtIndex:rowIndex];
    }
    else
        NSLog(@"FAIL");
        return nil;
}

@end
