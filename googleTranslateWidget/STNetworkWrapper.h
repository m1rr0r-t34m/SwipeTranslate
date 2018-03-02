//
//  STNetworkWrapper.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface STNetworkWrapper : NSObject
- (RACSignal *)requestWithURL:(NSString *)baseURL parameters:(NSDictionary *)parameters;
@end
