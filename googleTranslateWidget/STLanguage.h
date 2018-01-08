//
//  STLanguage.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 30/03/2017.
//  Copyright © 2017 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STLanguage : NSObject <NSCopying, NSCoding>
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *key;
- (instancetype)initWithKey:(NSString *)key andTitle:(NSString *)title;
@end
