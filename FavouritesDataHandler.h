//
//  FavouritesDataHandler.h
//  googleTranslateWidget
//
//  Created by Andrei on 11/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "FavouritesHandlerDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface FavouritesDataHandler : NSObject <NSTableViewDelegate, NSTableViewDataSource>{
   // IBOutlet NSTableView *favouritesTable;
    NSMutableArray *favouritesData;
    IBOutlet NSButton *starButton;
}

//@property NSArray *favouritesArray;
@property (weak) id<FavouritesHandlerDelegate>delegate;
@property NSTableView *favouritesTable;

-(void)pushFavouritesArray:(NSMutableArray *)array;
@end
