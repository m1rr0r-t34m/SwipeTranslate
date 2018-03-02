//
//  STParserServiceImpl.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 19/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STParserService.h"
#import "STLanguagesService.h"

@interface STParserServiceImpl : NSObject <STParserService>
- (instancetype)initWithLanguageService:(id <STLanguagesService>)service;
@end
