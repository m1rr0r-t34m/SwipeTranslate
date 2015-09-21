//
//  SeparatedButton.h
//  
//
//  Created by Mark Vasiv on 02/09/15.
//
//

#import <Cocoa/Cocoa.h>

@interface SeparatedButton : NSSegmentedControl
-(void)pushNewChosenTargetLanguage:(NSString *)language;
-(void)pushNewChosenSourceLanguage:(NSString *)language;
-(int)indexForSegmentWithLabel:(NSString *)label;
-(void)tryToPushNewSourceLanguage:(NSString *)language;
-(void)tryToPushNewTargetLanguage:(NSString *)language;
-(NSPoint)calculateMenuOrigin;
@end
