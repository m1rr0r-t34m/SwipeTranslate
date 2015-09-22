//
//  GoogleRequest.h
//  
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import <Foundation/Foundation.h>
#import "LanguagesStorage.h"

@interface RequestHandler : NSObject
+(NSURLRequest *)getRequestForSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText;
@end


