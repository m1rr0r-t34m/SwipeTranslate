//
//  STFavouritesHintView.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 09/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface STFavouritesHintView : NSView
@property (weak) IBOutlet NSLayoutConstraint *arrowLeft;
@property (weak) IBOutlet NSLayoutConstraint *bottom;
@property (weak) IBOutlet NSTextField *label;
@property (readonly, assign, nonatomic) BOOL isShown;
- (void)show;
- (void)hide;
@end
