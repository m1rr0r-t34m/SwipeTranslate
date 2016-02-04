//
//  KeyHandler.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 04/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyHandler : NSObject
-(void)updateDictionaryKey;
-(void)updateTranslationKey;
-(NSString *)currentDictionaryKey;
-(NSString *)currentTranslationKey;


@property NSArray* dictionaryKeys;
@property NSArray* translationKeys;
@property NSInteger* dictionaryKeyIndex;
@property NSInteger* translationKeyIndex;
@end
