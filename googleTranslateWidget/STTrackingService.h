//
//  STTrackingService.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 28/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STLanguage;

@protocol STTrackingService <NSObject>
- (void)trackLaunchWidget;
- (void)trackOpenSidebar;
- (void)trackTranslationFromLanguage:(STLanguage *)from toLanguage:(STLanguage *)to;
@end
