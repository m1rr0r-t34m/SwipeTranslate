//
//  STTranslationServiceImpl.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTranslationService.h"
#import "STAPIService.h"
#import "STTrackingService.h"

@interface STTranslationServiceImpl : NSObject <STTranslationService>
- (instancetype)initWithAPIService:(id <STAPIService>)apiService trackingService:(id <STTrackingService>)trackingService;
@end
