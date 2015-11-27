//
//  ValidativeTextView.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTextView (ValidateTextView)
-(BOOL)isEmpty;
-(BOOL)isWhiteSpace;
-(NSUInteger)countWords;

@end
