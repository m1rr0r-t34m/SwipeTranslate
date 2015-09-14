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

-(NSMenu*)createMenu:(NSString*)actionTarget andSender:(id)sender{
    
    //Initialize alphabet array and languages arrays, which are separated between letters
    
    NSArray *alphaLang = [[NSArray alloc]init];
    
    alphaLang = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"P", @"R", @"S", @"T", @"U", @"V", @"W", @"Y", @"Z", nil];
    
    NSArray *languagesForA = [[NSArray alloc]init];
    languagesForA = [NSArray arrayWithObjects:@"Afrikaans", @"Albanian", @"Arabic", @"Armenian", @"Azerbaijani", nil];
    
    NSArray *languagesForB = [[NSArray alloc]init];
    languagesForB = [NSArray arrayWithObjects:@"Basque", @"Belarusian", @"Bengali", @"Bosnian", @"Bulgarian", nil];
    
    NSArray *languagesForC = [[NSArray alloc]init];
    languagesForC = [NSArray arrayWithObjects:@"Catalan", @"Cebuano", @"Chichewa", @"Chinese Simplified", @"Chinese Traditional", @"Croatian", @"Czech", nil];
    
    NSArray *languagesForD = [[NSArray alloc]init];
    languagesForD = [NSArray arrayWithObjects:@"Danish", @"Dutch", nil];
    
    NSArray *languagesForE = [[NSArray alloc]init];
    languagesForE = [NSArray arrayWithObjects: @"English",@"Esperanto", @"Estonian", nil];
    
    NSArray *languagesForF = [[NSArray alloc]init];
    languagesForF = [NSArray arrayWithObjects:@"Filipino",@"Finnish", @"French", nil];
    
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
    
    
    NSMutableDictionary *allTheSubmenus = [[NSMutableDictionary alloc] initWithCapacity:40];
    NSMutableDictionary *allTheLanguages = [[NSMutableDictionary alloc] initWithCapacity:40];
    
    NSMenu *letterAmenu = [[NSMenu alloc]init];
    NSMenu *letterBmenu = [[NSMenu alloc]init];
    NSMenu *letterCmenu = [[NSMenu alloc]init];
    NSMenu *letterDmenu = [[NSMenu alloc]init];
    NSMenu *letterEmenu = [[NSMenu alloc]init];
    NSMenu *letterFmenu = [[NSMenu alloc]init];
    NSMenu *letterGmenu = [[NSMenu alloc]init];
    NSMenu *letterHmenu = [[NSMenu alloc]init];
    NSMenu *letterImenu = [[NSMenu alloc]init];
    NSMenu *letterJmenu = [[NSMenu alloc]init];
    NSMenu *letterKmenu = [[NSMenu alloc]init];
    NSMenu *letterLmenu = [[NSMenu alloc]init];
    NSMenu *letterMmenu = [[NSMenu alloc]init];
    NSMenu *letterNmenu = [[NSMenu alloc]init];
    NSMenu *letterPmenu = [[NSMenu alloc]init];
    NSMenu *letterRmenu = [[NSMenu alloc]init];
    NSMenu *letterSmenu = [[NSMenu alloc]init];
    NSMenu *letterTmenu = [[NSMenu alloc]init];
    NSMenu *letterUmenu = [[NSMenu alloc]init];
    NSMenu *letterVmenu = [[NSMenu alloc]init];
    NSMenu *letterWmenu = [[NSMenu alloc]init];
    NSMenu *letterYmenu = [[NSMenu alloc]init];
    NSMenu *letterZmenu = [[NSMenu alloc]init];
    
    NSMenu *outputMenu = [[NSMenu alloc]init];
    [outputMenu setAutoenablesItems:NO];
    
    for(int a=0;a<[alphaLang count];a++) {
        NSMenuItem *item=[outputMenu addItemWithTitle:[alphaLang objectAtIndex:(NSUInteger)a ] action:nil keyEquivalent:@""];
        [item setTarget:sender];
        [item setEnabled:YES];
    }
    
    
    [allTheSubmenus setObject:letterAmenu forKey:@"A"];
    [allTheSubmenus setObject:letterBmenu forKey:@"B"];
    [allTheSubmenus setObject:letterCmenu forKey:@"C"];
    [allTheSubmenus setObject:letterDmenu forKey:@"D"];
    [allTheSubmenus setObject:letterEmenu forKey:@"E"];
    [allTheSubmenus setObject:letterFmenu forKey:@"F"];
    [allTheSubmenus setObject:letterGmenu forKey:@"G"];
    [allTheSubmenus setObject:letterHmenu forKey:@"H"];
    [allTheSubmenus setObject:letterImenu forKey:@"I"];
    [allTheSubmenus setObject:letterJmenu forKey:@"J"];
    [allTheSubmenus setObject:letterKmenu forKey:@"K"];
    [allTheSubmenus setObject:letterLmenu forKey:@"L"];
    [allTheSubmenus setObject:letterMmenu forKey:@"M"];
    [allTheSubmenus setObject:letterNmenu forKey:@"N"];
    [allTheSubmenus setObject:letterPmenu forKey:@"P"];
    [allTheSubmenus setObject:letterRmenu forKey:@"R"];
    [allTheSubmenus setObject:letterSmenu forKey:@"S"];
    [allTheSubmenus setObject:letterTmenu forKey:@"T"];
    [allTheSubmenus setObject:letterUmenu forKey:@"U"];
    [allTheSubmenus setObject:letterVmenu forKey:@"V"];
    [allTheSubmenus setObject:letterWmenu forKey:@"W"];
    [allTheSubmenus setObject:letterYmenu forKey:@"Y"];
    [allTheSubmenus setObject:letterZmenu forKey:@"Z"];
    
    [allTheLanguages setObject:languagesForA forKey:@"A"];
    [allTheLanguages setObject:languagesForB forKey:@"B"];
    [allTheLanguages setObject:languagesForC forKey:@"C"];
    [allTheLanguages setObject:languagesForD forKey:@"D"];
    [allTheLanguages setObject:languagesForE forKey:@"E"];
    [allTheLanguages setObject:languagesForF forKey:@"F"];
    [allTheLanguages setObject:languagesForG forKey:@"G"];
    [allTheLanguages setObject:languagesForH forKey:@"H"];
    [allTheLanguages setObject:languagesForI forKey:@"I"];
    [allTheLanguages setObject:languagesForJ forKey:@"J"];
    [allTheLanguages setObject:languagesForK forKey:@"K"];
    [allTheLanguages setObject:languagesForL forKey:@"L"];
    [allTheLanguages setObject:languagesForM forKey:@"M"];
    [allTheLanguages setObject:languagesForN forKey:@"N"];
    [allTheLanguages setObject:languagesForP forKey:@"P"];
    [allTheLanguages setObject:languagesForR forKey:@"R"];
    [allTheLanguages setObject:languagesForS forKey:@"S"];
    [allTheLanguages setObject:languagesForT forKey:@"T"];
    [allTheLanguages setObject:languagesForU forKey:@"U"];
    [allTheLanguages setObject:languagesForV forKey:@"V"];
    [allTheLanguages setObject:languagesForW forKey:@"W"];
    [allTheLanguages setObject:languagesForY forKey:@"Y"];
    [allTheLanguages setObject:languagesForZ forKey:@"Z"];
    
    
    for(int k=0;k<[alphaLang count];k++) {
        [[allTheSubmenus objectForKey:[alphaLang objectAtIndex:k]] setAutoenablesItems:NO];
        for(int i = 0; i < [[allTheLanguages objectForKey:[alphaLang objectAtIndex:k]] count]; i++) {
            NSMenuItem *item = [[allTheSubmenus objectForKey:[alphaLang objectAtIndex:k]] addItemWithTitle:[[allTheLanguages objectForKey:[alphaLang objectAtIndex:k]] objectAtIndex:(NSUInteger)i] action:selector keyEquivalent:@""];
            [item setTarget:sender];
            [item setEnabled:YES];
        }
        
    }
    
    for(int k=0;k<[alphaLang count];k++){
        [outputMenu setSubmenu:[allTheSubmenus objectForKey:[alphaLang objectAtIndex:k]] forItem:[outputMenu itemWithTitle:[alphaLang objectAtIndex:k]]];
    }
    
   
    return outputMenu;
   
    
}

@end