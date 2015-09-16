//
//  MenuContent.m
//  googleTranslateWidget
//
//  Created by Andrei on 14/09/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuContent.h"

@implementation subMenuItem

-(NSMenu*)createMenuWithAction:(NSString *)action andSender:(id)sender {
    
    //Initialize alphabet array and languages arrays
    NSArray *alphaLang = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"P", @"R", @"S", @"T", @"U", @"V", @"W", @"Y", @"Z"];
    NSArray *languages = @[@"Afrikaans", @"Albanian", @"Arabic", @"Armenian", @"Azerbaijani",
                      @"Basque", @"Belarusian", @"Bengali", @"Bosnian", @"Bulgarian",
                      @"Catalan", @"Cebuano", @"Chichewa", @"Chinese Simplified", @"Chinese Traditional",
                      @"Croatian", @"Czech", @"Danish", @"Dutch", @"English",
                      @"Esperanto", @"Estonian", @"Filipino", @"Finnish", @"French", @"Galician",
                      @"Georgian", @"German", @"Greek", @"Gujarati", @"Haitian Creole",
                      @"Hausa", @"Hebrew", @"Hindi", @"Hmong", @"Hungarian",
                      @"Icelandic", @"Igbo", @"Indonesian", @"Irish", @"Italian",
                      @"Japanese", @"Javanese", @"Kannada", @"Kazakh", @"Khmer",
                      @"Korean", @"Lao", @"Latin", @"Latvian", @"Lithuanian",
                      @"Macedonian", @"Malagasy", @"Malay", @"Malayalam", @"Maltese",
                      @"Maori", @"Marathi", @"Mongolian", @"Myanmar", @"Nepale",
                      @"Norwegian", @"Persian", @"Polish", @"Portuguese", @"Punjabi", @"Romanian",
                      @"Russian", @"Serbian", @"Sesotho", @"Sinhala", @"Slovak",
                      @"Slovenian", @"Somali", @"Spanish", @"Sudanese", @"Swahili",
                      @"Swedish", @"Tajik", @"Tamil", @"Telugu", @"Thai", @"Turkish",
                      @"Ukrainian", @"Urdu", @"Uzbek", @"Vietnamese", @"Welsh",
                      @"Yiddish", @"Yoruba", @"Zulu"];

    
    //Get target action from parameter
    SEL selector = NSSelectorFromString(action);
    
    //Create dictionary for submenus and languages divided alphabetically
    NSMutableDictionary *allTheSubmenus = [[NSMutableDictionary alloc] initWithCapacity:40];
    NSMutableDictionary *allTheLanguages = [[NSMutableDictionary alloc] initWithCapacity:40];
    
    //Create main menu
    NSMenu *outputMenu = [[NSMenu alloc]init];
    [outputMenu setAutoenablesItems:NO];
    
    //Generate Auto element if it is source language menu
    if([action isEqualToString:@"sourceTabDropDownClick:"]) {
        NSMenuItem *firstOutputMenuItem=[outputMenu addItemWithTitle:@"Auto" action:selector keyEquivalent:@""];
        [firstOutputMenuItem setEnabled:YES];
        [firstOutputMenuItem setTarget:sender];
    }
    
    for(int k=0;k<[alphaLang count];k++) {
       
        //Generate items for main menu
        NSMenuItem *outputMenuItem=[outputMenu addItemWithTitle:[alphaLang objectAtIndex:(NSUInteger)k ] action:nil keyEquivalent:@""];
        [outputMenuItem setEnabled:YES];
        
        //Generate languages divided alphabetically
        [allTheLanguages setObject:[languages getArrayOfLanguagesWithLetter:[alphaLang objectAtIndex:k]] forKey:[alphaLang objectAtIndex:k]];
        
        //Create submenus
        [allTheSubmenus setObject:[[NSMenu alloc]init] forKey:[alphaLang objectAtIndex:k]];
        [[allTheSubmenus objectForKey:[alphaLang objectAtIndex:k]] setAutoenablesItems:NO];
        
        for(int i = 0; i < [[allTheLanguages objectForKey:[alphaLang objectAtIndex:k]] count]; i++) {
           //Generate submenu items
            NSMenuItem *submenuItem = [[allTheSubmenus objectForKey:[alphaLang objectAtIndex:k]] addItemWithTitle:[[allTheLanguages objectForKey:[alphaLang objectAtIndex:k]] objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
            [submenuItem setTarget:sender];
            [submenuItem setEnabled:YES];
        }
        
        //Link submenus to main menu items
        [outputMenu setSubmenu:[allTheSubmenus objectForKey:[alphaLang objectAtIndex:k]] forItem:[outputMenu itemWithTitle:[alphaLang objectAtIndex:k]]];
        
    }
    
    return outputMenu;
}

@end