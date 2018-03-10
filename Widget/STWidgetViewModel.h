//
//  STWidgetViewModel.h
//  Widget
//
//  Created by Mark Vasiv on 10/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STLanguagesService.h"

@class STLanguage;

@interface STWidgetViewModel : NSObject
@property (readonly, strong, nonatomic) NSArray <STLanguage *> *sourceLanguages;
@property (readonly, strong, nonatomic) NSArray <STLanguage *> *targetLanguages;
@property (readonly, assign, nonatomic) NSInteger sourceSelectedIndex;
@property (readonly, assign, nonatomic) NSInteger targetSelectedIndex;
@property (readonly, strong, nonatomic) NSString *inputText;
@property (readonly, strong, nonatomic) NSAttributedString *outputText;
@property (readonly, strong, nonatomic) id <STLanguagesService> languagesService;
@property (readonly, strong, nonatomic) STLanguage *detectedLanguage;
#pragma mark - User initiated
- (void)selectSourceIndex:(NSInteger)index;
- (void)selectTargetIndex:(NSInteger)index;
- (void)selectSourceLanguage:(STLanguage *)language;
- (void)selectTargetLanguage:(STLanguage *)language;
- (void)updateInputText:(NSString *)text;
- (void)switchLanguages;
@end
