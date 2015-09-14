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

-(NSMenu*)createMenu:(NSString*)actionTarget{
    
    //Initialize alphabet array and languages arrays, which are separated between letters
    
    NSArray *alphaLang = [[NSArray alloc]init];
    
    alphaLang = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"P", @"R", @"S", @"T", @"U", @"V", @"W", @"Y", @"Z", nil];
    
    NSArray *languagesForA = [[NSArray alloc]init];
    languagesForA = [NSArray arrayWithObjects:@"Afrikaans", @"Albanian", @"Arabic", @"Armenian", @"Azerbaijani", nil];
    
    NSArray *languagesForB = [[NSArray alloc]init];
    languagesForB = [NSArray arrayWithObjects:@"Basque", @"Belarusian", @"Bengali", @"Bosnian", @"Bulgarian", nil];
    
    NSArray *languagesForC = [[NSArray alloc]init];
    languagesForC = [NSArray arrayWithObjects:@"Catalan", @"Cebuano", @"Chichewa", @"Chinese Simplified", @"Chinese Traditional",
                     @"Croatian", @"Czech", nil];
    
    NSArray *languagesForD = [[NSArray alloc]init];
    languagesForD = [NSArray arrayWithObjects:@"Danish", @"Dutch", nil];
    
    NSArray *languagesForE = [[NSArray alloc]init];
    languagesForE = [NSArray arrayWithObjects: @"English",@"Esperanto", @"Estonian", @"Filipino", @"Finnish", nil];
    
    NSArray *languagesForF = [[NSArray alloc]init];
    languagesForF = [NSArray arrayWithObjects:@"French", nil];
    
    NSArray *languagesForG = [[NSArray alloc]init];
    languagesForG = [NSArray arrayWithObjects:@"Galician", @"Georgian", @"German", @"Greek", @"Gujarati", nil];
    
    NSArray *languagesForH = [[NSArray alloc]init];
    languagesForH = [NSArray arrayWithObjects: @"Haitian Creole", @"Hausa", @"Hebrew", @"Hindi", @"Hmong", @"Hungarian", nil];
    
    NSArray *languagesForI = [[NSArray alloc]init];
    languagesForI = [NSArray arrayWithObjects:@"Icelandic", @"Igbo", @"Indonesian", @"Irish", @"Italian", nil];
    
    NSArray *languagesForJ = [[NSArray alloc]init];
    languagesForJ = [NSArray arrayWithObjects:@"Japanese", @"Javanese", nil];
    
    NSArray *languagesForK = [[NSArray alloc]init];
    languagesForK = [NSArray arrayWithObjects:@"Kannada", @"Kazakh", @"Khmer", @"Korean", nil];
    
    NSArray *languagesForL = [[NSArray alloc]init];
    languagesForL = [NSArray arrayWithObjects:@"Lao", @"Latin", @"Latvian", @"Lithuanian", nil];
    
    NSArray *languagesForM = [[NSArray alloc]init];
    languagesForM = [NSArray arrayWithObjects:@"Macedonian", @"Malagasy", @"Malay", @"Malayalam", @"Maltese", @"Maori", @"Marathi", @"Mongolian", @"Myanmar", nil];
    
    NSArray *languagesForN = [[NSArray alloc]init];
    languagesForN = [NSArray arrayWithObjects: @"Nepale", @"Norwegian",  nil];
    
    NSArray *languagesForP = [[NSArray alloc]init];
    languagesForP = [NSArray arrayWithObjects:@"Persian", @"Polish", @"Portuguese", @"Punjabi",  nil];
    
    NSArray *languagesForR = [[NSArray alloc]init];
    languagesForR = [NSArray arrayWithObjects:@"Romanian", @"Russian", nil];
    
    NSArray *languagesForS = [[NSArray alloc]init];
    languagesForS = [NSArray arrayWithObjects:@"Serbian", @"Sesotho", @"Sinhala", @"Slovak", @"Slovenian", @"Somali", @"Spanish", @"Sudanese", @"Swahili", @"Swedish", nil];
    
    NSArray *languagesForT = [[NSArray alloc]init];
    languagesForT = [NSArray arrayWithObjects:@"Tajik", @"Tamil", @"Telugu", @"Thai", @"Turkish", nil];
    
    NSArray *languagesForU = [[NSArray alloc]init];
    languagesForU = [NSArray arrayWithObjects:@"Ukrainian", @"Urdu", @"Uzbek",  nil];
    
    NSArray *languagesForV = [[NSArray alloc]init];
    languagesForV = [NSArray arrayWithObjects:@"Vietnamese",  nil];
    
    NSArray *languagesForW = [[NSArray alloc]init];
    languagesForW = [NSArray arrayWithObjects:@"Welsh", nil];
    
    NSArray *languagesForY = [[NSArray alloc]init];
    languagesForY = [NSArray arrayWithObjects:@"Yiddish", @"Yoruba", nil];
    
    NSArray *languagesForZ = [[NSArray alloc]init];
    languagesForZ  = [NSArray arrayWithObjects:@"Zulu"  , nil];
    
    //Create submenus for alphabet letters
    
    SEL selector = NSSelectorFromString(actionTarget);
    
    
    NSMenu *letterAmenu = [[NSMenu alloc]init];
    [letterAmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForA count]; i++) {
        NSMenuItem *item = [letterAmenu addItemWithTitle:[languagesForA objectAtIndex:(NSUInteger)i] action:@selector(sourceTabDropDownClick:) keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterBmenu = [[NSMenu alloc]init];
    [letterBmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForB count]; i++) {
        NSMenuItem *item = [letterBmenu addItemWithTitle:[languagesForB objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterCmenu = [[NSMenu alloc]init];
    [letterCmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForC count]; i++) {
        NSMenuItem *item = [letterCmenu addItemWithTitle:[languagesForC objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterDmenu = [[NSMenu alloc]init];
    [letterDmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForD count]; i++) {
        NSMenuItem *item = [letterDmenu addItemWithTitle:[languagesForD objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterEmenu = [[NSMenu alloc]init];
    [letterEmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForE count]; i++) {
        NSMenuItem *item = [letterEmenu addItemWithTitle:[languagesForE objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterFmenu = [[NSMenu alloc]init];
    [letterFmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForF count]; i++) {
        NSMenuItem *item = [letterFmenu addItemWithTitle:[languagesForF objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterGmenu = [[NSMenu alloc]init];
    [letterGmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForG count]; i++) {
        NSMenuItem *item = [letterGmenu addItemWithTitle:[languagesForG objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterHmenu = [[NSMenu alloc]init];
    [letterHmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForH count]; i++) {
        NSMenuItem *item = [letterHmenu addItemWithTitle:[languagesForH objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterImenu = [[NSMenu alloc]init];
    [letterImenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForI count]; i++) {
        NSMenuItem *item = [letterImenu addItemWithTitle:[languagesForI objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterJmenu = [[NSMenu alloc]init];
    [letterJmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForJ count]; i++) {
        NSMenuItem *item = [letterJmenu addItemWithTitle:[languagesForJ objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterKmenu = [[NSMenu alloc]init];
    [letterKmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForK count]; i++) {
        NSMenuItem *item = [letterKmenu addItemWithTitle:[languagesForK objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterLmenu = [[NSMenu alloc]init];
    [letterLmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForL count]; i++) {
        NSMenuItem *item = [letterLmenu addItemWithTitle:[languagesForL objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterMmenu = [[NSMenu alloc]init];
    [letterMmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForM count]; i++) {
        NSMenuItem *item = [letterMmenu addItemWithTitle:[languagesForM objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterNmenu = [[NSMenu alloc]init];
    [letterNmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForN count]; i++) {
        NSMenuItem *item = [letterNmenu addItemWithTitle:[languagesForN objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterPmenu = [[NSMenu alloc]init];
    [letterPmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForP count]; i++) {
        NSMenuItem *item = [letterPmenu addItemWithTitle:[languagesForP objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterRmenu = [[NSMenu alloc]init];
    [letterRmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForR count]; i++) {
        NSMenuItem *item = [letterRmenu addItemWithTitle:[languagesForR objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterSmenu = [[NSMenu alloc]init];
    [letterSmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForS count]; i++) {
        NSMenuItem *item = [letterSmenu addItemWithTitle:[languagesForS objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterTmenu = [[NSMenu alloc]init];
    [letterTmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForT count]; i++) {
        NSMenuItem *item = [letterTmenu addItemWithTitle:[languagesForT objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterUmenu = [[NSMenu alloc]init];
    [letterUmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForU count]; i++) {
        NSMenuItem *item = [letterUmenu addItemWithTitle:[languagesForU objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterVmenu = [[NSMenu alloc]init];
    [letterVmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForV count]; i++) {
        NSMenuItem *item = [letterVmenu addItemWithTitle:[languagesForV objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterWmenu = [[NSMenu alloc]init];
    [letterWmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForW count]; i++) {
        NSMenuItem *item = [letterWmenu addItemWithTitle:[languagesForW objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterYmenu = [[NSMenu alloc]init];
    [letterYmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForY count]; i++) {
        NSMenuItem *item = [letterYmenu addItemWithTitle:[languagesForY objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    NSMenu *letterZmenu = [[NSMenu alloc]init];
    [letterZmenu setAutoenablesItems:NO];
    for(int i = 0; i < [languagesForZ count]; i++) {
        NSMenuItem *item = [letterZmenu addItemWithTitle:[languagesForZ objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    
    NSMenu *outputMenu = [[NSMenu alloc]init];
    [outputMenu setAutoenablesItems:NO];
    
    for(int a=0;a<[alphaLang count];a++) {
        NSMenuItem *item=[outputMenu addItemWithTitle:[alphaLang objectAtIndex:(NSUInteger)a ] action:nil keyEquivalent:@""];
        [item setTarget:self];
        [item setEnabled:YES];
    }
    [outputMenu setSubmenu:letterAmenu forItem:[outputMenu itemWithTitle:@"A"]];
 
    [outputMenu setSubmenu:letterBmenu forItem:[outputMenu itemWithTitle:@"B"]];
    [outputMenu setSubmenu:letterCmenu forItem:[outputMenu itemWithTitle:@"C"]];
    [outputMenu setSubmenu:letterDmenu forItem:[outputMenu itemWithTitle:@"D"]];
    [outputMenu setSubmenu:letterEmenu forItem:[outputMenu itemWithTitle:@"E"]];
    [outputMenu setSubmenu:letterFmenu forItem:[outputMenu itemWithTitle:@"F"]];
    [outputMenu setSubmenu:letterGmenu forItem:[outputMenu itemWithTitle:@"G"]];
    [outputMenu setSubmenu:letterHmenu forItem:[outputMenu itemWithTitle:@"H"]];
    [outputMenu setSubmenu:letterImenu forItem:[outputMenu itemWithTitle:@"I"]];
    [outputMenu setSubmenu:letterJmenu forItem:[outputMenu itemWithTitle:@"J"]];
    [outputMenu setSubmenu:letterKmenu forItem:[outputMenu itemWithTitle:@"K"]];
    [outputMenu setSubmenu:letterLmenu forItem:[outputMenu itemWithTitle:@"L"]];
    [outputMenu setSubmenu:letterMmenu forItem:[outputMenu itemWithTitle:@"M"]];
    [outputMenu setSubmenu:letterNmenu forItem:[outputMenu itemWithTitle:@"N"]];
    [outputMenu setSubmenu:letterPmenu forItem:[outputMenu itemWithTitle:@"P"]];
    [outputMenu setSubmenu:letterRmenu forItem:[outputMenu itemWithTitle:@"R"]];
    [outputMenu setSubmenu:letterSmenu forItem:[outputMenu itemWithTitle:@"S"]];
    [outputMenu setSubmenu:letterTmenu forItem:[outputMenu itemWithTitle:@"T"]];
    [outputMenu setSubmenu:letterUmenu forItem:[outputMenu itemWithTitle:@"U"]];
    [outputMenu setSubmenu:letterVmenu forItem:[outputMenu itemWithTitle:@"V"]];
    [outputMenu setSubmenu:letterWmenu forItem:[outputMenu itemWithTitle:@"W"]];
    [outputMenu setSubmenu:letterYmenu forItem:[outputMenu itemWithTitle:@"Y"]];
    [outputMenu setSubmenu:letterZmenu forItem:[outputMenu itemWithTitle:@"Z"]];
   
    return outputMenu;
   
    
}

@end