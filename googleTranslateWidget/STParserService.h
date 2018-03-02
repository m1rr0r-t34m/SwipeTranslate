//
//  STParserService.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 19/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@protocol STParserService <NSObject>
- (RACSignal *)translationForRawData:(NSDictionary *)rawData;
- (RACSignal *)definitionForRawData:(NSDictionary *)rawData;
@end
