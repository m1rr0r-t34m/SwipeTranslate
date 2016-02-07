//
//  NSMutableSet+TouchSet.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 08/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AppKit;

@interface NSMutableSet (TouchSet)
-(void)touchIntersect:(NSSet *)otherSet;
-(void)touchRemove:(NSSet *)otherSet;
@end
