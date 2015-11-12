//
//  InputTextView.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 01/11/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InputScroll.h"

@interface InputTextView : NSTextView
@property (readwrite) BOOL open;
@property (readwrite) BOOL ready;
@property BOOL commandKeyPressed;
-(void)fold;
-(void)unfold;
@end
