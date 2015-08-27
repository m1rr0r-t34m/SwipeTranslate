//
//  TodayViewController.h
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GoogleRequest.h"


@interface TodayViewController : NSViewController

@property IBOutlet NSTextField *outputText;
@property IBOutlet NSTextField *inputText;


-(IBAction)swapButton: (id)sender;


@end
