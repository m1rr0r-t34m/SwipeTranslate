//
//  MenuContent.h
//  googleTranslateWidget
//
//  Created by Andrei on 14/09/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TodayViewController.h"

@interface subMenuItem : NSMenu

-(NSMenu*)createMenu:(NSString*)actionTarget andSender:(id)sender ;


@end