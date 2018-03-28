//
//  STTrackingService.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 28/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STTrackingService <NSObject>
- (void)trackLaunchMainApp;
- (void)trackLaunchWidget;
- (void)trackOpenSidebar;
@end
