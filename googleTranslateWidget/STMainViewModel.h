//
//  MainViewControllerModel.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STServices.h"
@class STTranslation;

@interface STMainViewModel : NSObject
@property (readonly, nonatomic) id <STServices> services;
@property (strong, nonatomic) STTranslation *translation;
@property (readonly, assign, nonatomic) BOOL translating;
@property (strong, nonatomic) NSString *sourceText;
@property (strong, nonatomic) STLanguage *sourceLanguage;
@property (strong, nonatomic) STLanguage *targetLanguage;
- (void)setSavedTranslation:(STTranslation *)translation;
- (void)allowTranslation;
@end
