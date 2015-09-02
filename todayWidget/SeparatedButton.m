//
//  SeparatedButton.m
//  
//
//  Created by Mark Vasiv on 02/09/15.
//
//

#import "SeparatedButton.h"

@implementation SeparatedButton
-(void)pushNewChosenLanguage:(NSString *)language {

    NSString* firstElement=[self labelForSegment:(NSInteger)0];
    NSString* secondElement=[self labelForSegment:(NSInteger)1];
    [self setLabel:language forSegment:0];
    [self setLabel:firstElement forSegment:1];
    [self setLabel:secondElement forSegment:2];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
