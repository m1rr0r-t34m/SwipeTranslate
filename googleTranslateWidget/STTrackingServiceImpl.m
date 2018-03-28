//
//  STTrackingServiceImpl.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 28/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STTrackingServiceImpl.h"
#import <Mixpanel/Mixpanel.h>

@implementation STTrackingServiceImpl
- (instancetype)init {
    if (self = [super init]) {
        Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:@"bafecdee41e0f93589d4776dd9115ae5"];
        [mixpanel identify:mixpanel.distinctId];
    }
    
    return self;
}

- (void)trackLaunchMainApp {
    [self trackAction:@"App Launch"];
}

- (void)trackLaunchWidget {
    [self trackAction:@"Widget Launch"];
}

- (void)trackOpenSidebar {
    [self trackAction:@"Favourites Sidebar Open"];
}

- (void)trackAction:(NSString *)action {
    [[Mixpanel sharedInstance] track:action];
    [Mixpanel.sharedInstance.people increment:action by:@1];
}

@end
