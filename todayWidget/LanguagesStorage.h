//
//  LanguagesStorage.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 21/09/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LanguagesStorage)
+(NSArray *)getAlphabetArray;
+(NSArray *)getValuesArray:(BOOL)full;
+(NSArray *)getKeysArray;
-(NSArray *)getArrayOfLanguagesWithLetter:(NSString *)letter;
@end
