//
//  STLanguageCellModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 30/03/2017.
//  Copyright © 2017 Mark Vasiv. All rights reserved.
//

#import "STLanguageCellModel.h"
#import "STLanguage.h"
@implementation STLanguageCellModel
- (instancetype)initWithLanguage:(STLanguage *)language {
    if (self = [super init]) {
        _language = language;
        _title = language.title;
    }
    
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    STLanguageCellModel *copy = [[STLanguageCellModel allocWithZone:zone] init];
    copy.language = [self.language copy];
    copy.title = [self.title copy];
    copy.selected = self.selected;
    
    return copy;
}
@end
