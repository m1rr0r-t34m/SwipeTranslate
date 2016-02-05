//
//  KeyHandler.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 04/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "KeyHandler.h"

@implementation KeyHandler
-(KeyHandler *)init {
    self=[super init];
    if(!self)
        return nil;
    self.translationKeys=[[NSArray alloc] initWithObjects:@"trnsl.1.1.20151022T101327Z.947a48f231e6aa6e.7e71b163761e2e6791c492f9448b63e1c1f27a2e",@"trnsl.1.1.20160205T220026Z.f79840726332a14f.3c6ff3304b4bafc4d2a932d887dc44da76d81514", @"trnsl.1.1.20160116T172821Z.1f08aedad7321adc.c61d63de33f7b02ef4fc0ff70bab33484e4f099b", nil];
    self.dictionaryKeys=[[NSArray alloc] initWithObjects:@"dict.1.1.20151022T180334Z.52a72548fccdbcf3.fe30ded92dd2687f0229f3ebc9709f4e27891329",@"dict.1.1.20160205T215034Z.bf16881b170334ea.acaaf8e74a7585d32222c44dd8b24b1f9a600d63", nil];
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"translationKeyIndex"])
        self.translationKeyIndex=0;
    else
        self.translationKeyIndex=(NSInteger )[[NSUserDefaults standardUserDefaults] integerForKey:@"translationKeyIndex"];
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"dictionaryKeyIndex"])
        self.dictionaryKeyIndex=0;
    else
        self.dictionaryKeyIndex=(NSInteger )[[NSUserDefaults standardUserDefaults] integerForKey:@"dictionaryKeyIndex"];
    
    return self;
}

-(NSString *)currentTranslationKey {
    int index=(int)self.translationKeyIndex;
    return [self.translationKeys objectAtIndex:index];
}
-(NSString *)currentDictionaryKey {
    int index=(int)self.dictionaryKeyIndex;
    return [self.dictionaryKeys objectAtIndex:index];
}

-(void)updateTranslationKey{
    
    self.translationKeyIndex++;
    if((int)self.translationKeyIndex>=self.translationKeys.count)
        self.translationKeyIndex=0;
    
    [[NSUserDefaults standardUserDefaults]setInteger:(int)self.translationKeyIndex forKey:@"translationKeyIndex"];
}
-(void)updateDictionaryKey {
    
    self.dictionaryKeyIndex++;
    if((int)self.dictionaryKeyIndex>=self.dictionaryKeys.count)
        self.dictionaryKeyIndex=0;
    
    [[NSUserDefaults standardUserDefaults]setInteger:(int)self.dictionaryKeyIndex forKey:@"dictionaryKeyIndex"];
}



@end
