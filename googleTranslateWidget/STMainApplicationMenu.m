//
//  STMainApplicationMenu.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 08/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STMainApplicationMenu.h"
#import <ReactiveObjC.h>

@implementation STMainApplicationMenu
+ (instancetype)editMenu {
    STMainApplicationMenu *editMenuItem = [[super alloc] initWithTitle:@"Edit" action:NULL keyEquivalent:@""];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
    
    STMainApplicationMenu *copyItem = [[super alloc] initWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"];
    STMainApplicationMenu *pasteItem = [[super alloc] initWithTitle:@"Paste" action:@selector(pasteAsPlainText:) keyEquivalent:@"v"];
    STMainApplicationMenu *cutItem = [[super alloc] initWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"];
    STMainApplicationMenu *selectAllItem = [[super alloc] initWithTitle:@"Select all" action:@selector(selectAll:) keyEquivalent:@"a"];
    
    [editMenu addItem:copyItem];
    [editMenu addItem:pasteItem];
    [editMenu addItem:cutItem];
    [editMenu addItem:selectAllItem];
    [editMenuItem setSubmenu:editMenu];
    
    return editMenuItem;
}

+ (instancetype)fileMenuWithTarget:(id)target
                   openBarSelector:(SEL)open
              openBarEnabledSignal:(RACSignal *)openEnabled
           saveTranslationSelector:(SEL)save
      saveTranslationEnabledSignal:(RACSignal *)saveEnabled {
    
    STMainApplicationMenu *fileMenuItem = [[super alloc] initWithTitle:@"File" action:NULL keyEquivalent:@""];
    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
    
    STMainApplicationMenu *favouritesSidebar = [[super alloc] initWithTitle:@"Show Favourites" action:open keyEquivalent:@"f"];
    STMainApplicationMenu *starButtonMenu = [[super alloc] initWithTitle:@"Save to Favourites" action:save keyEquivalent:@"s"];
    
    fileMenu.autoenablesItems = NO;
    
    favouritesSidebar.state = 0;
    favouritesSidebar.target = target;
    RAC(favouritesSidebar, enabled) = openEnabled;
    
    starButtonMenu.state = 0;
    starButtonMenu.target = target;
    RAC(starButtonMenu, enabled) = saveEnabled;
    
    [fileMenu addItem:favouritesSidebar];
    [fileMenu addItem:starButtonMenu];
    [fileMenuItem setSubmenu:fileMenu];
    
    return fileMenuItem;
}
@end
