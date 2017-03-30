//
//  LeftSplitViewModel.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STLanguageCellModel;
@class STLanguage;
@class RACSignal;

@interface STLeftSplitViewModel : NSObject

@property (strong, nonatomic) RACSignal *dataReloadSignal;
@property (strong, nonatomic) NSArray <STLanguageCellModel *> *sourceLanguages;
@property (strong, nonatomic) NSArray <STLanguageCellModel *> *targetLanguages;

@property (assign, nonatomic) CGFloat rowHeight;
@property (assign, nonatomic) NSUInteger visibleRowsCount;

@property (strong, nonatomic) STLanguage *sourceSelectedLanguage;
@property (strong, nonatomic) STLanguage *targetSelectedLanguage;

- (void)setSourceSelected:(NSInteger)index;
- (void)setTargetSelected:(NSInteger)index;

@end
