//
//  STTouchableView.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 05/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STDraggableView.h"
#import <ReactiveObjC.h>

@implementation STDragUpdate
- (instancetype)initWithActive:(BOOL)active moveDistance:(CGFloat)moveDistance {
    if (self = [super init]) {
        _active = active;
        _moveDistance = moveDistance;
    }
    
    return self;
}
@end

@interface STDraggableView()
@property (strong, nonatomic) NSSet *initialTouches;
@property (assign, nonatomic) BOOL inTouch;
@property (strong, nonatomic) RACSubject *updateSubject;
@end

@implementation STDraggableView
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        _updateSubject = [RACSubject new];
        _touchSignal = [_updateSubject deliverOnMainThread];
    }
    
    return self;
}

- (void)touchesBeganWithEvent:(NSEvent *)event {
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:self];
    if (self.inTouch || touches.count == 2) {
        self.initialTouches = touches;
    } else {
        self.initialTouches = nil;
    }
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:self];
    
    CGFloat sumDelta = 0;
    NSInteger touchesCount = 0;
    for (NSTouch *initial in self.initialTouches) {
        for (NSTouch *detected in touches) {
            if ([initial.identity isEqual:detected.identity]) {
                CGFloat delta = detected.normalizedPosition.x - initial.normalizedPosition.x;
                sumDelta += delta;
                touchesCount++;
            }
        }
    }
    
    CGFloat averageDelta = 800 * sumDelta / touchesCount;
    BOOL wasInTouch = self.inTouch;
    if (touchesCount == 2 && touches.count == 2 && ABS(averageDelta) > 30) {
        self.inTouch = YES;
    }
    
    if (self.inTouch) {
        self.initialTouches = touches;
        
        if (!wasInTouch) {
            CGFloat sign = averageDelta > 0 ? -1 : 1;
            averageDelta += 30 * sign;
        }
        
        [self.updateSubject sendNext:[[STDragUpdate alloc] initWithActive:YES moveDistance:averageDelta]];
    }
}

- (void)touchesEndedWithEvent:(NSEvent *)event {
    NSMutableSet *endedTouches = [[event touchesMatchingPhase:NSTouchPhaseEnded inView:self] mutableCopy];
    NSMutableSet *initialTouches = [self.initialTouches mutableCopy];
    
    for (NSTouch *endedTouch in endedTouches) {
        for (NSTouch *touch in [self.initialTouches copy]) {
            if ([touch.identity isEqual:endedTouch.identity]) {
                [initialTouches removeObject:touch];
            }
        }
    }
    
    self.initialTouches = [initialTouches copy];
    
    if (initialTouches.count == 0) {
        self.inTouch = NO;
        [self.updateSubject sendNext:[[STDragUpdate alloc] initWithActive:NO moveDistance:0]];
    }
}

- (void)touchesCancelledWithEvent:(NSEvent *)event {
    if (self.inTouch) {
        self.inTouch = NO;
        self.initialTouches = nil;
        [self.updateSubject sendNext:[[STDragUpdate alloc] initWithActive:NO moveDistance:0]];
    }
}

- (NSTouchTypeMask)allowedTouchTypes {
    return NSTouchTypeMaskIndirect | NSTouchTypeMaskDirect;
}

- (BOOL)acceptsTouchEvents {
    return YES;
}

@end
