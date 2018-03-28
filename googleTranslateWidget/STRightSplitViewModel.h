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
@property (strong, nonatomic) NSString *inputText;
@property (readonly, strong, nonatomic) NSAttributedString *outputText;
@property (readonly, assign, nonatomic) BOOL currentTranslationIsSaved;
@property (readonly, assign, nonatomic) BOOL canSaveOrRemoveCurrentTranslation;
@property (readonly, assign, nonatomic) BOOL translating;
@property (readonly, assign, nonatomic) BOOL shouldShowFavouritesHint;
@property (assign, nonatomic) BOOL usedFavourites;
@property (readonly, strong, nonatomic) NSMutableArray <STFavouriteCellModel *> *favouriteViewModels;
@property (readonly, strong, nonatomic) RACSignal *favouritesUpdateSignal;
@property (readonly, assign, nonatomic) NSInteger favouritesSelectedIndex;

- (instancetype)initWithMainViewModel:(STMainViewModel *)mainViewModel;
- (void)saveOrRemoveCurrentTranslation;
- (void)showSavedTranslation:(NSInteger)index;
- (void)setSourceText:(NSString *)text;
- (NSInteger)indexOfCurrentTranslation;
- (void)trackOpenSidebar;
@end
