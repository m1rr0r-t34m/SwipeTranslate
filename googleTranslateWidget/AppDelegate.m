//
//  AppDelegate.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "AppDelegate.h"
#import "iRate.h"

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}
-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    [iRate sharedInstance].previewMode = YES;
}
@end
