//
//  STSidebarAnimator.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 06/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STSidebarAnimator.h"
#import <ReactiveObjC.h>
#import "STDraggableView.h"

//TODO: tune constants
static CGFloat defaultSpringSpeed = 50;
static CGFloat defaultSlowSpeed = 150;
static CGFloat defaultMediumSpeed = 270;
static CGFloat defaultFastSpeed = 400;

@implementation STSidebarAnimatorUpdate
@end

@interface STSidebarAnimator()
@property (weak, nonatomic) STDraggableView *observedView;
@property (assign, nonatomic) CGFloat leftConstant;
@property (assign, nonatomic) CGFloat currentConstant;
@property (assign, nonatomic) CGFloat rightConstant;
@property (strong, nonatomic) RACSubject *updateSubject;
@end

@implementation STSidebarAnimator
- (instancetype)initWithDraggableView:(STDraggableView *)view
                      rightConstraint:(CGFloat)rightConstraint
                       leftConstraint:(CGFloat)leftConstraint
                     andCurrentCostraint:(CGFloat)currentConstraint {
    if (self = [super init]) {
        _observedView = view;
        _currentConstant = currentConstraint;
        _leftConstant = leftConstraint;
        _rightConstant = rightConstraint;
        _updateSubject = [RACSubject new];
        _updateSignal = [_updateSubject deliverOnMainThread];
        [self setupFlow];
    }
    
    return self;
}

- (void)setupFlow {
    RACSignal *touchSignal = self.observedView.touchSignal;
    
    RACSignal *activeGestureSignal = [[touchSignal filter:^BOOL(STDragUpdate *update) {
        return update.active;
    }] map:^id (STDragUpdate *update) {
        return @(update.moveDistance);
    }];
    
    RACSignal *inactiveGestureSignal = [touchSignal filter:^BOOL(STDragUpdate *update) {
        return !update.active;
    }];
    
    @weakify(self);
    __block CGFloat lastMoveDistance = 0;
    
    [activeGestureSignal subscribeNext:^(NSNumber *distanceNumber) {
        @strongify(self);
        CGFloat distance = distanceNumber.floatValue;
        CGFloat possibleConstant = self.currentConstant - distance;
        
        if (possibleConstant >= self.rightConstant && possibleConstant <= self.leftConstant) {
            self.currentConstant = possibleConstant;
        } else {
            if (possibleConstant == self.leftConstant) {
                possibleConstant = self.leftConstant + 1;
            }
            //Don't wanna get zero here
            CGFloat coeff = 1/(possibleConstant - self.leftConstant);
            if (coeff > 1) coeff = 1;
            self.currentConstant -= distance * coeff;
        }

        STSidebarAnimatorUpdate *update = [STSidebarAnimatorUpdate new];
        update.animated = NO;
        update.constant = self.currentConstant;
        [self.updateSubject sendNext:update];
        lastMoveDistance = distance;
    }];
    
    [inactiveGestureSignal subscribeNext:^(STDragUpdate *update) {
        @strongify(self);
        CGFloat constant = self.currentConstant;
        CGFloat modulusMoveDistance = ABS(lastMoveDistance);
        
        STSidebarMoveDirection direction = lastMoveDistance > 0 ? STSidebarMoveDirectionClose : STSidebarMoveDirectionOpen;
        CGFloat speed = defaultMediumSpeed;
        
        if (modulusMoveDistance > 15) {
            speed = defaultFastSpeed;
        } else if (modulusMoveDistance > 4) {
            speed = defaultMediumSpeed;
        } else {
            if (constant > self.leftConstant) {
                direction = STSidebarMoveDirectionOpen;
                speed = defaultSpringSpeed;
            } else if (constant > (self.rightConstant + self.leftConstant)/2){
                direction = STSidebarMoveDirectionOpen;
                speed = defaultSlowSpeed;
            } else {
                direction = STSidebarMoveDirectionClose;
                speed = defaultSlowSpeed;
            }
        }
        
        [self.updateSubject sendNext:[self updateWithMoveDirection:direction andSpeed:speed]];
    }];
}

- (STSidebarAnimatorUpdate *)updateWithMoveDirection:(STSidebarMoveDirection)direction andSpeed:(CGFloat)speed {
    STSidebarAnimatorUpdate *update = [STSidebarAnimatorUpdate new];
    update.animated = YES;
    CGFloat distance;
    if (direction == STSidebarMoveDirectionOpen) {
        distance = ABS(self.leftConstant - self.currentConstant);
        update.constant = self.leftConstant;
    } else {
        distance = ABS(self.currentConstant - self.rightConstant);
        update.constant = self.rightConstant;
    }
    
    update.duration = distance / speed;
    self.currentConstant = update.constant;
    return update;
}

- (STSidebarAnimatorUpdate *)updateWithDirection:(STSidebarMoveDirection)direction {
    return [self updateWithMoveDirection:direction andSpeed:defaultMediumSpeed];
}
@end
