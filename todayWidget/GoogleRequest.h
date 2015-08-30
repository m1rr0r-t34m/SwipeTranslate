//
//  GoogleRequest.h
//  
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import <Foundation/Foundation.h>
#import "TodayViewController.h"


@interface GoogleRequest : NSObject
- (void)getDataFromUrlWithSourceLanguage:(NSString *)SLanguage TargetLanguage:(NSString *)TLanguage Text:(NSString *)inputText WithDelegate:(NSObject <asynchronousRequests> *)delegate;
-(void)sendRequestWithSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText Sender:(id)sender;

@end


@interface languageList : NSObject



@property NSDictionary *langList;

-(NSDictionary*) createList;

@end
