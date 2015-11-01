//
//  InputScroll.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 31/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "InputScroll.h"

@implementation InputScroll

-(void)scrollWheel:(NSEvent *)theEvent {
    if(self.scrolling)
        [super scrollWheel:theEvent];
}

@end
