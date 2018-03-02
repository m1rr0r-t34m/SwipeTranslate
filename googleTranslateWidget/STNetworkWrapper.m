//
//  STNetworkWrapper.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STNetworkWrapper.h"
#import <ReactiveObjC.h>
#import <AFNetworking.h>

@interface STNetworkWrapper()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation STNetworkWrapper
- (instancetype)init {
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager new];
        _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    }
    
    return self;
}

- (RACSignal *)requestWithURL:(NSString *)baseURL parameters:(NSDictionary *)parameters {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        __block NSURLSessionDataTask *task = [self.manager GET:baseURL
                                            parameters:parameters
                                              progress:nil
                                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                                   [subscriber sendNext:responseObject];
                                               }
                                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                   NSLog(@"STNetworkWrapper failed to perform request: %@", error);
                                                   [subscriber sendError:error];
                                               }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
@end
