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
@property (readonly, strong, nonatomic) id <STServices> services;
@property (readonly, strong, nonatomic) RACSignal *dataReloadSignal;
@property (readonly, strong, nonatomic) NSArray <STLanguageCellModel *> *sourceLanguages;
@property (readonly, strong, nonatomic) NSArray <STLanguageCellModel *> *targetLanguages;
@property (readonly, strong, nonatomic) NSString *sourceSelectedTitle;
@property (readonly, strong, nonatomic) NSString *targetSelectedTitle;
@property (readonly, assign, nonatomic) BOOL autoLanguageSelected;
@property (assign, nonatomic) CGFloat rowHeight;
@property (assign, nonatomic) NSUInteger visibleRowsCount;


- (instancetype)initWithMainViewModel:(STMainViewModel *)mainViewModel;
- (void)setSourceSelectedIndex:(NSInteger)index;
- (void)setTargetSelectedIndex:(NSInteger)index;
- (void)setSourceSelectedLanguage:(STLanguage *)language;
- (void)setTargetSelectedLanguage:(STLanguage *)language;
- (void)switchAutoButton;
- (void)switchLanguages;
@end
