//
//  STApiKeyServiceImpl.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 23/02/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STAPIService.h"
#import "STParserService.h"

@interface STAPIServiceImpl : NSObject <STAPIService>
- (instancetype)initWithParserService:(id <STParserService>)parserService;
@end
