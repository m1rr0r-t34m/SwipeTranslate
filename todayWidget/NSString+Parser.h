//
//  GoogleString.h
//  
//
//  Created by Mark Vasiv on 04/09/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Parser)

-(NSString *)parseFirstDive;
-(NSInteger)numberOfLines;
-(NSString *)parseSecondDive;
-(NSString *)parseThirdDive;
-(NSString *)parseFirstDiveForAuto;
-(NSString *)parseAutoForLanguage;

@end
