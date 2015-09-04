//
//  SeparatedButton.h
//  
//
//  Created by Mark Vasiv on 02/09/15.
//
//

#import <Cocoa/Cocoa.h>

@interface SeparatedButton : NSSegmentedControl
-(void)pushNewChosenLanguage:(NSString *)language;
-(int)indexForSegmentWithLabel:(NSString *)label;
-(void)tryToPushNewLanguage:(NSString *)language;
-(NSPoint)calculateMenuOrigin;
@end
