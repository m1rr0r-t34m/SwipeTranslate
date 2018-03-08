//
//  STLanguageMenu.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STLanguagesService.h"

@class RACSignal;
@interface STLanguageMenu : NSMenu
@property (strong, nonatomic) RACSignal *selectSignal;
- (instancetype)initWithLanguagesService:(id <STLanguagesService>)service;
@end