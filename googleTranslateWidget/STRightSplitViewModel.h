//
//  STRightSplitViewModel.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STServices.h"
@class STTranslation;
@class STFavouriteCellModel;
@class RACSignal;
@class STMainViewModel;

@interface STRightSplitViewModel : NSObject
@property (assign, nonatomic) BOOL currentTranslationIsSaved;
@property (assign, nonatomic) BOOL canSaveOrRemoveCurrentTranslation;
@property (assign, nonatomic) BOOL translating;
@property (strong, nonatomic) NSString *inputText;
@property (strong, nonatomic) NSAttributedString *outputText;
@property (strong, nonatomic) NSMutableArray <STFavouriteCellModel *> *favouriteViewModels;
@property (strong, nonatomic) RACSignal *favouritesUpdateSignal;
@property (assign, nonatomic) NSInteger favouritesSelectedIndex;
- (instancetype)initWithMainViewModel:(STMainViewModel *)mainViewModel;
- (void)saveOrRemoveCurrentTranslation;
- (void)showSavedTranslation:(NSInteger)index;
- (void)setSourceText:(NSString *)text;
- (NSInteger)indexOfCurrentTranslation;
@end
