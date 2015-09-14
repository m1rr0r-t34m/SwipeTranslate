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

    NSString* firstElement=[self labelForSegment:(NSInteger)1];
    NSString* secondElement=[self labelForSegment:(NSInteger)2];
    [self setLabel:language forSegment:1];
    [self setLabel:firstElement forSegment:2];
    [self setLabel:secondElement forSegment:3];
    [self setSelectedSegment:(NSInteger)1];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(int)indexForSegmentWithLabel:(NSString *)label {
    for (int i = 0; i < [self segmentCount]; i++)
    {
        if ([[self labelForSegment:i] isEqualToString:label])
        {
            return i;
        }
    }
    return -1;
}
-(void)tryToPushNewLanguage:(NSString *)language {
    //If clicked menu element language is already in segmented button, select this segment
    //If not, push this element to segmented button
    int selectedIndex=[self indexForSegmentWithLabel:language];
    if(selectedIndex!=-1)
        [self setSelectedSegment:selectedIndex];
    else
        [self pushNewChosenLanguage:language];
}
-(NSPoint)calculateMenuOrigin {
    NSPoint menuOrigin = [self frame].origin;
    menuOrigin.x = NSMaxX([self frame]) - NSMaxX([self frame]);
    return menuOrigin;
}
@end
