//
//  STFavouriteCellModel.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STTranslation;
@class RACCommand;

@interface STFavouriteCellModel : NSObject
@property (strong, nonatomic) NSString *inputText;
@property (strong, nonatomic) NSString *outputText;
@property (strong, nonatomic) STTranslation *translation;
@property (strong, nonatomic) RACCommand *command;
@end
