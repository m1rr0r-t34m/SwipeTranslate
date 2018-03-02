//
//  STLanguagesService.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STLanguage;

@protocol STLanguagesService <NSObject>
- (NSArray *)alphabet;
- (NSArray <STLanguage *> *)allLanguages;
- (NSArray<STLanguage *> *)languagesForLetter:(NSString *)letter;
- (NSString *)keyForLanguage:(NSString *)language;
- (NSString *)languageForKey:(NSString *)key;
- (STLanguage *)autoLanguage;
- (NSArray<STLanguage *> *)randomLanguagesExcluding:(NSArray <STLanguage *> *)excludingArray withCount:(NSUInteger)count;
@end
