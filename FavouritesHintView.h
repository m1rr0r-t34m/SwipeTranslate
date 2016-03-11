//
//  FavouritesHintView.h
//  googleTranslateWidget
//
//  Created by Andrei on 10/03/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "SavedInfo.h"
#import <QuartzCore/QuartzCore.h>

@interface FavouritesHintView : NSView <NSAnimatablePropertyContainer> {
    IBOutlet NSImageView *arrowImageLeft;
}

@property NSTimer *arrowTimer;

-(void)moveFavouritesBar;
-(void)closeFavouritesBar;

@end
