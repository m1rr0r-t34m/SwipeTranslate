//
//  STFavouriteCell.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STFavouriteCellModel;

@interface STFavouriteCell : NSTableRowView
- (void)fillWithModel:(STFavouriteCellModel *)model;
@end
