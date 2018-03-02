//
//  STServices.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLanguagesService.h"
#import "STTranslationService.h"
#import "STDatabaseService.h"
#import "STParserService.h"

@protocol STServices <NSObject>
- (id <STLanguagesService>)languagesService;
- (id <STTranslationService>)translationService;
- (id <STDatabaseService>)databaseService;
@end
