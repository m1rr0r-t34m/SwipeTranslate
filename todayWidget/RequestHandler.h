//
//  GoogleRequest.h
//
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Parser.h"

@interface RequestHandler : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate> {
    NSViewController *returnView;
}

-(void)performRequestForSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText sender:(id)sender;
@end


