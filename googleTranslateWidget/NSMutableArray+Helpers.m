//
//  NSMutableArray+Helpers.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "NSMutableArray+Helpers.h"

@implementation NSMutableArray (Helpers)
- (void)replaceElementAtIndex:(NSUInteger)firstIndex withElementAtIndex:(NSUInteger)secondIndex {
    NSAssert(self.count > firstIndex, @"Out of bounds index");
    NSAssert(self.count > secondIndex, @"Out of bounds index");
    
    id firstObject = [self objectAtIndex:firstIndex];
    id secondObject = [self objectAtIndex:secondIndex];
    
    [self removeObjectAtIndex:firstIndex];
    [self insertObject:secondObject atIndex:firstIndex];
    
    [self removeObjectAtIndex:secondIndex];
    [self insertObject:firstObject atIndex:secondIndex];
}
@end
