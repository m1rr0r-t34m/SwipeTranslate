//
//  GoogleString.h
//  
//
//  Created by Mark Vasiv on 04/09/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (GoogleString)

-(NSString *)parseFirstDive;
-(NSInteger)numberOfLines;
-(NSString *)parseSecondDive;
-(NSString *)parseThirdDiveWithQuotes:(int)numberOfQuotesInInput;

@end