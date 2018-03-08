//
//  STMainApplicationMenu.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 08/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class RACSignal;

@interface STMainApplicationMenu : NSMenuItem
+ (instancetype)editMenu;
+ (instancetype)fileMenuWithTarget:(id)target
                   openBarSelector:(SEL)open
              openBarEnabledSignal:(RACSignal *)openEnabled
           saveTranslationSelector:(SEL)save
      saveTranslationEnabledSignal:(RACSignal *)saveEnabled;
@end
