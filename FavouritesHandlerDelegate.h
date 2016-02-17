//
//  FavouritesHandlerDelegate.h
//  googleTranslateWidget
//
//  Created by Andrei on 17/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol FavouritesHandlerDelegate < NSObject >
-(void)favouritesTableSelectionDidChange:(int)index;
@end
