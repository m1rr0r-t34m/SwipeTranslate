//
//  InnerScroll.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 25/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "InnerScroll.h"

@implementation InnerScroll

-(void)scrollWheel:(NSEvent *)theEvent {
    [[self nextResponder] scrollWheel:theEvent];
}

@end
