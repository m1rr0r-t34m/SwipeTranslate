//
//  STApiKeyService.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 23/02/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@class STLanguage;

@protocol STAPIService <NSObject>
- (RACSignal *)translationForText:(NSString *)text fromLanguage:(STLanguage *)source toLanguage:(STLanguage *)target;
- (RACSignal *)definitionForText:(NSString *)text fromLanguage:(STLanguage *)source toLanguage:(STLanguage *)target;
@end
