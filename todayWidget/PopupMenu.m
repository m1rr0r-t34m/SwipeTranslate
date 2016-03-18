//
//  MenuContent.m
//  googleTranslateWidget
//
//  Created by Andrei on 14/09/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopupMenu.h"

@implementation PopupMenu

+(NSMenu*)createMenuWithAction:(NSString *)action andSender:(id)sender {

    //Get target action from parameter
    SEL selector = NSSelectorFromString(action);
    
    
    //Create dictionary for submenus and languages divided alphabetically
    NSMutableDictionary *allTheSubmenus = [[NSMutableDictionary alloc] initWithCapacity:40];
    NSMutableDictionary *allTheLanguages = [[NSMutableDictionary alloc] initWithCapacity:40];
    
    //Create main menu
    NSMenu *outputMenu = [[NSMenu alloc]init];
    [outputMenu setAutoenablesItems:NO];
    
    
    for(int k=0;k<[[NSArray getAlphabetArray] count];k++) {
       
        //Generate items for main menu
        NSMenuItem *outputMenuItem=[outputMenu addItemWithTitle:[[NSArray getAlphabetArray] objectAtIndex:(NSUInteger)k ] action:nil keyEquivalent:@""];
        [outputMenuItem setEnabled:YES];
        
        //Generate languages divided alphabetically
        [allTheLanguages setObject:[[NSArray getValuesArray:NO] getArrayOfLanguagesWithLetter:[[NSArray getAlphabetArray] objectAtIndex:k]] forKey:[[NSArray getAlphabetArray] objectAtIndex:k]];
        
        //Create submenus
        [allTheSubmenus setObject:[[NSMenu alloc]init] forKey:[[NSArray getAlphabetArray] objectAtIndex:k]];
        [[allTheSubmenus objectForKey:[[NSArray getAlphabetArray] objectAtIndex:k]] setAutoenablesItems:NO];
        
        for(int i = 0; i < [[allTheLanguages objectForKey:[[NSArray getAlphabetArray] objectAtIndex:k]] count]; i++) {
           //Generate submenu items
            NSMenuItem *submenuItem = [[allTheSubmenus objectForKey:[[NSArray getAlphabetArray] objectAtIndex:k]] addItemWithTitle:[[allTheLanguages objectForKey:[[NSArray getAlphabetArray] objectAtIndex:k]] objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
            [submenuItem setTarget:sender];
            [submenuItem setEnabled:YES];
        }
        
        //Link submenus to main menu items
        [outputMenu setSubmenu:[allTheSubmenus objectForKey:[[NSArray getAlphabetArray] objectAtIndex:k]] forItem:[outputMenu itemWithTitle:[[NSArray getAlphabetArray] objectAtIndex:k]]];
        
    }
    
    return outputMenu;
}

@end