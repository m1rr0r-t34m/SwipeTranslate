//
//  TodayViewController.m
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import "TodayViewController.h"
#import "GoogleRequest.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController
- (void)didFinishLoadingStuff:(NSData *)stuff {
    NSString *strData = [[NSString alloc]initWithData:stuff encoding:NSUTF8StringEncoding];
    int startNewWord = 4,endNewWord=0;
    for(int i=4;i<[strData length];i++) {
        if([[strData substringWithRange:NSMakeRange(i,1)] isEqual:@"\""]) {
            endNewWord=i;
            break;
        }
    }
    NSString *newWord=[strData substringWithRange:NSMakeRange(startNewWord, endNewWord-startNewWord)];
    [_outputText setStringValue:newWord];
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
}
-(IBAction)swapButton: (id)sender {
    GoogleRequest *newRequest=[[GoogleRequest alloc] init];
    [newRequest sendRequestWithSourceLanguage:@"ru" TargetLanguage:@"en" Text:[_inputText stringValue] Sender:self];
    
}

@end

