//
//  Parser.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Parser.h"
#import "TodayViewController.h"

@interface Parser : NSObject
+(NSString *)ParseAutoCode:(NSData *)data;
+(NSString *)ParseAuto:(NSData *)data;
+(NSString *)ParseGeneral:(NSData *)data;
+(NSString *)ParseBody:(NSString *)strData;

@end
