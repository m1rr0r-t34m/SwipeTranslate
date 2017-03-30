//
//  STLanguageCellModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 30/03/2017.
//  Copyright © 2017 Mark Vasiv. All rights reserved.
//

#import "STLanguageCellModel.h"

@implementation STLanguageCellModel
- (instancetype)initWithLanguage:(STLanguage *)language Title:(NSString *)title {
    if (self = [super init]) {
        _language = language;
        _title = title;
    }
    
    return self;
}
@end
