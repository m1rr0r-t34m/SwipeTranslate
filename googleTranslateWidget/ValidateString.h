//
//  ValidateString.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 31/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidateString)
-(NSUInteger)countWords;
-(BOOL)isEmpty;
-(BOOL)isWhiteSpace;
@end
