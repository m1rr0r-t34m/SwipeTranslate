//
//  LanguageSuggestionMenu.h
//  googleTranslateWidget
//
//  Created by Andrei on 25/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface LanguageSuggestionMenu : NSMenu

+(NSMenu*)createMenuWithAction:(NSString*)action andSender:(id)sender;

@end
