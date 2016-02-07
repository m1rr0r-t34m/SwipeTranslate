//
//  favouritesListView.h
//  googleTranslateWidget
//
//  Created by Andrei on 07/02/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface favouritesListView : NSView <NSAnimatablePropertyContainer>{
    CGFloat lastChange;
}

@property BOOL isOpened;
@property BOOL isClosed;

-(void)changeOrigin:(CGFloat)change;
-(void)checkState;

@end
