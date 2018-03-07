//
//  STFavouriteUpdate.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    STFavouriteUpdateTypeInsert,
    STFavouriteUpdateTypeRemove,
    STFavouriteUpdateTypeReload
} STFavouriteUpdateType;

@interface STFavouriteUpdate : NSObject
@property (assign, nonatomic) STFavouriteUpdateType type;
@property (assign, nonatomic) NSInteger index;
+ (instancetype)updateWithType:(STFavouriteUpdateType)type index:(NSInteger)index;
@end
