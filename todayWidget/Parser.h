//
//  Parser.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodayViewController.h"

@interface Parser : NSObject
+(NSString *)Text:(NSData *)data;
+(NSString *)AutoLanguage:(NSData *)data;
+(NSDictionary *)Dictionary:(NSData *)data;
@end
