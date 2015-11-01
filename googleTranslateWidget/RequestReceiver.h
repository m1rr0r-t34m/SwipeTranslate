//
//  RequestReceiver.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 01/11/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseReceiver <NSObject>
-(void)receiveTranslateResponse:(NSArray *)data;
@optional
-(void)receiveDictionaryResponse:(NSArray *)data;
@end