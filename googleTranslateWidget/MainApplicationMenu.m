//
//  MainApplicationMenu.m
//  googleTranslateWidget
//
//  Created by Andrei on 12/11/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "MainApplicationMenu.h"

@implementation MainApplicationMenu

+(NSMenuItem*)createEditMenu{
    NSMenuItem *editMenuItem = [[NSMenuItem alloc] initWithTitle:@"Edit" action:NULL keyEquivalent:@""];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
    
    NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"];
    NSMenuItem *pasteItem = [[NSMenuItem alloc] initWithTitle:@"Paste" action:@selector(pasteAsPlainText:) keyEquivalent:@"v"];
    NSMenuItem *cutItem = [[NSMenuItem alloc] initWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"];
    
    [editMenu addItem:copyItem];
    [editMenu addItem:pasteItem];
    [editMenu addItem:cutItem];
    [editMenuItem setSubmenu:editMenu];
    
    return editMenuItem;
}

+(NSMenuItem*)createFileMenuWithLiveTranslateAction:(NSString *)action andSender:(id)sender{
    SEL selector = NSSelectorFromString(action);
    
    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] initWithTitle:@"File" action:NULL keyEquivalent:@""];
    [fileMenuItem setSubmenu: fileMenu];
    NSMenuItem* liveTranslate = [[NSMenuItem alloc] initWithTitle:@"Live Translate" action:selector keyEquivalent:@"l"];
    [liveTranslate setTarget:sender];
    [liveTranslate setState:1];
    [liveTranslate setEnabled:YES];
    [fileMenu addItem: liveTranslate];
    
    return fileMenuItem;
}

@end
