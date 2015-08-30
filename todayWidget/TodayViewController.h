//
//  TodayViewController.h
//  todayWidget
//
//  Created by Mark Vasiv on 27/08/15.
//  Copyright (c) 2015 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol asynchronousRequests <NSObject>

-(void)didFinishLoadingStuff:(NSData *)stuff;

@end
@interface TodayViewController : NSViewController

@property IBOutlet NSTextField *outputText;
@property IBOutlet NSTextField *inputText;

@property (strong) IBOutlet NSDictionaryController *dictController;

@property NSDictionary *langList;

-(NSDictionary*) createList;


-(IBAction)swapButton: (id)sender;
- (void)controlTextDidChange:(NSNotification *)notification;



@end





