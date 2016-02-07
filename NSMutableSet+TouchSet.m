//
//  NSMutableSet+TouchSet.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 08/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "NSMutableSet+TouchSet.h"

@implementation NSMutableSet (TouchSet)
-(void)touchIntersect:(NSSet *)otherSet {
    NSMutableSet *newSet=[NSMutableSet new];
    for (NSTouch *selfTouch in self) {
        for (NSTouch *otherTouch in otherSet) {
            if([selfTouch.identity isEqual:otherTouch.identity])
                [newSet addObject:selfTouch];
        }
    }
    
    [self removeAllObjects];
    [self unionSet:newSet];
    
}
-(void)touchRemove:(NSSet *)otherSet{
    NSMutableSet *newSet=[NSMutableSet new];
    for (NSTouch *selfTouch in self) {
        for (NSTouch *otherTouch in otherSet) {
            if([selfTouch.identity isEqual:otherTouch.identity])
                [newSet addObject:selfTouch];
        }
    }
    
    [self minusSet:newSet];
}
@end
