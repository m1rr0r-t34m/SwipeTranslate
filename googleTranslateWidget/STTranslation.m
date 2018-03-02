//
//  STTranslation.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 21/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STTranslation.h"
#import "STParserResult.h"

@implementation STTranslation
+ (instancetype)emptyTranslation {
    STTranslation *translation = [STTranslation new];
    translation.parserResult = [STParserResult new];
    return translation;
}
@end
