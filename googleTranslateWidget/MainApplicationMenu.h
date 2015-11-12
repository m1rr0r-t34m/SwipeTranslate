//
//  MainApplicationMenu.h
//  googleTranslateWidget
//
//  Created by Andrei on 12/11/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface MainApplicationMenu : NSMenuItem

+(NSMenuItem*)createEditMenu;
+(NSMenuItem*)createFileMenu;


@end
