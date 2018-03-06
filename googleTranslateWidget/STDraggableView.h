//
//  STTouchableView.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 05/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class RACSignal;

@interface STDragUpdate : NSObject
@property (assign, nonatomic) BOOL active;
@property (assign, nonatomic) CGFloat moveDistance;
@end

@interface STDraggableView : NSView
@property (strong, nonatomic) RACSignal *touchSignal;
@end
