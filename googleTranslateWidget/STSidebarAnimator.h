//
//  STSidebarAnimator.h
//  Swipe Translate
//
//  Created by Mark Vasiv on 06/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@class STDraggableView;

@interface STSidebarAnimatorUpdate : NSObject
@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) CGFloat constant;
@property (assign, nonatomic) CGFloat duration;
@end


typedef enum : NSUInteger {
    STSidebarMoveDirectionOpen,
    STSidebarMoveDirectionClose,
} STSidebarMoveDirection;

@interface STSidebarAnimator : NSObject
@property (readonly, assign, nonatomic) BOOL active;
@property (readonly, strong, nonatomic) RACSignal *updateSignal;
- (instancetype)initWithDraggableView:(STDraggableView *)view
                      rightConstraint:(CGFloat)rightConstraint
                       leftConstraint:(CGFloat)leftConstraint
                  andCurrentCostraint:(CGFloat)currentConstraint;

- (STSidebarAnimatorUpdate *)updateWithDirection:(STSidebarMoveDirection)direction;
@end
