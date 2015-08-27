//
//  GoogleRequest.h
//  
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import <Foundation/Foundation.h>

@interface GoogleRequest : NSObject
-(NSString*) sendRequestWithSourceLanguage:(NSString *)sLanguage TargetLanguage:(NSString *)tLanguage Text:(NSString *)inputText;

@end
