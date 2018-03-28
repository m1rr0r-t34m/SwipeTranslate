//
//  STTrackingServiceImpl.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 28/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STTrackingServiceImpl.h"
#import <Mixpanel/Mixpanel.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "STLanguage.h"

@implementation STTrackingServiceImpl
- (instancetype)init {
    if (self = [super init]) {
        Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:@"bafecdee41e0f93589d4776dd9115ae5"];
        [mixpanel identify:mixpanel.distinctId];
        [Fabric with:@[[Crashlytics class]]];
    }
    
    return self;
}

- (void)trackLaunchWidget {
    [self trackAction:@"Widget Launch" withAttributes:nil];
}

- (void)trackOpenSidebar {
    [self trackAction:@"Favourites Sidebar Open" withAttributes:nil];
}

- (void)trackTranslationFromLanguage:(STLanguage *)from toLanguage:(STLanguage *)to {
    [self trackAction:@"Translation" withAttributes:@{@"Source Language" : from.title, @"Target Language" : to.title}];
}

- (void)trackAction:(NSString *)action withAttributes:(NSDictionary *)attributes {
    if (attributes) {
        [[Mixpanel sharedInstance] track:action properties:attributes];
    } else {
        [[Mixpanel sharedInstance] track:action];
    }
    [Mixpanel.sharedInstance.people increment:action by:@1];
}

@end
