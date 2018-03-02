//
//  STTranslationService.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@class STLanguage;

@protocol STTranslationService <NSObject>
- (RACSignal *)translationForText:(NSString *)text fromLanguage:(STLanguage *)source toLanguage:(STLanguage *)target;
@end
