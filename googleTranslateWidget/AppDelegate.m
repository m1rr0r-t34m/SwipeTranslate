//
//  AppDelegate.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "AppDelegate.h"
#import "STMainApplicationMenu.h"


@implementation AppDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [NSApp.mainMenu addItem:[STMainApplicationMenu editMenu]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"NSApplicationCrashOnExceptions": @YES }];
}
@end
