//
//  LanguageArray.m
//  
//
//  Created by Mark Vasiv on 14/09/15.
//
//

#import "LanguageArray.h"

@implementation NSArray (LanguageArray)
-(NSArray *)getArrayOfLanguagesWithLetter:(NSString *)letter {
    NSMutableArray *newArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[self count];i++){
        if([[[self objectAtIndex:i] substringWithRange:NSMakeRange(0, 1)] isEqualToString: letter])
            [newArray addObject:[self objectAtIndex:i]];
    }
    return [[NSArray alloc] initWithArray:newArray];
}
@end
