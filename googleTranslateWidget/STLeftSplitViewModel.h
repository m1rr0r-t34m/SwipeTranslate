//
//  LeftSplitViewModel.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STServices.h"

@class STLanguageCellModel;
@class STLanguage;
@class RACSignal;
@class STTranslation;
@class STMainViewModel;

@interface STLeftSplitViewModel : NSObject
@property (strong, nonatomic) RACSignal *dataReloadSignal;
@property (strong, nonatomic) NSArray <STLanguageCellModel *> *sourceLanguages;
@property (strong, nonatomic) NSArray <STLanguageCellModel *> *targetLanguages;
@property (strong, nonatomic) STLanguage *sourceSelectedLanguage;
@property (strong, nonatomic) STLanguage *targetSelectedLanguage;
@property (strong, nonatomic) NSString *sourceSelectedTitle;
@property (strong, nonatomic) NSString *targetSelectedTitle;
@property (assign, nonatomic) CGFloat rowHeight;
@property (assign, nonatomic) NSUInteger visibleRowsCount;
@property (strong, nonatomic) id <STServices> services;
@property (strong, nonatomic) STTranslation *lastTranslation;
- (instancetype)initWithMainViewModel:(STMainViewModel *)mainViewModel;
- (void)setSourceSelected:(NSInteger)index;
- (void)setTargetSelected:(NSInteger)index;
- (void)switchAutoButton;
- (void)pushSourceLanguage:(STLanguage *)language;
- (void)pushTargetLanguage:(STLanguage *)language;
- (void)switchLanguages;
@end
