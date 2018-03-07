//
//  STFavouriteUpdate.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STFavouriteUpdate.h"

@implementation STFavouriteUpdate
+ (instancetype)updateWithType:(STFavouriteUpdateType)type index:(NSInteger)index {
    STFavouriteUpdate *instance = [STFavouriteUpdate new];
    instance.type = type;
    instance.index = index;
    return instance;
}
@end
