//
//  LeftSplitViewModel.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STLeftSplitViewModel : NSObject

@property (strong, nonatomic) NSArray *sourceLanguages;
@property (strong, nonatomic) NSArray *targetLanguages;

@property (strong, nonatomic) NSString *sourceSelectedLanguageKey;
@property (strong, nonatomic) NSString *targetSelectedLanguageKey;

@property (strong, nonatomic) NSString *sourceSelectedLanguage;
@property (strong, nonatomic) NSString *targetSelectedLanguage;

- (void)setSourceSelected:(NSInteger)index;
- (void)setTargetSelected:(NSInteger)index;

@end
