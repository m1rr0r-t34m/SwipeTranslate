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

@interface STRightSplitViewModel : NSObject
- (instancetype)initWithServices:(id <STServices>)services;
@property (strong, nonatomic) NSString *inputText;
@property (strong, nonatomic) NSAttributedString *outputText;
@property (strong, nonatomic) STTranslation *translation;
@property (strong, nonatomic) NSArray <STFavouriteCellModel *> *favouriteViewModels;
- (void)saveFavouriteTranslation;
@end
