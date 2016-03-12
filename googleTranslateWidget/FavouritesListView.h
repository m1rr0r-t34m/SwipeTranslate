//
//  favouritesListView.h
//  googleTranslateWidget
//
//  Created by Andrei on 07/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SavedInfo.h"
#import "FavouritesHintView.h"

@interface favouritesListView : NSView <NSAnimatablePropertyContainer>{
    CGFloat lastChange;
    IBOutlet FavouritesHintView *hintView;
}

@property BOOL isOpened;
@property BOOL isClosed;
@property SavedInfo *localDefaults;

-(void)changeOrigin:(CGFloat)change;
-(void)checkState;

-(void)moveWithButton;

@end
