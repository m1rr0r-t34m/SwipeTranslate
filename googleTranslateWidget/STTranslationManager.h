//
//  STTranslationManager.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 28/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTranslationManager : NSObject

+(instancetype)Manager;
-(void)getTranslationForString:(NSString *)string SourceLanguage:(NSString *)sourceLang AndTargetLanguage:(NSString *)targetLang;

@end