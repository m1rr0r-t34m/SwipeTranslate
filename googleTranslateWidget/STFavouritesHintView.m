//
//  STFavouritesHintView.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 09/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STFavouritesHintView.h"
#import <QuartzCore/CAMediaTimingFunction.h>

static CGFloat leftArrowConstant = -70;
static CGFloat viewHeight = 70;
static CGFloat arrowWidth = 70;
static CGFloat arrowAniamtionSpeed = 350;

@interface STFavouritesHintView()
@property (assign, nonatomic) BOOL animating;
@property (readwrite, assign, nonatomic) BOOL isShown;
@end

@implementation STFavouritesHintView
- (void)show {
    self.isShown = YES;
    self.animating = YES;
    self.arrowLeft.constant = [self rightArrowConstant];
    [self layout];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self animateArrow];
        [self setBottomConstraintAnimated:0 completion:nil];
    });
}

- (void)hide {
    self.isShown = NO;
    __weak typeof(self) weakSelf = self;
    [self setBottomConstraintAnimated:-viewHeight completion:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.animating = NO;
    }];
}

- (void)setBottomConstraintAnimated:(CGFloat)constant completion:(void (^)(void))completion {
    self.bottom.constant = constant;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * context) {
        context.allowsImplicitAnimation = YES;
        context.duration = 0.5;
        [self.superview layout];
    } completionHandler:completion];
}

- (void)animateArrow {
    self.arrowLeft.constant = leftArrowConstant;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * context) {
        context.allowsImplicitAnimation = YES;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        context.duration = [self arrowAnimationDuration];
        [self layoutSubtreeIfNeeded];
    } completionHandler:^{
        self.arrowLeft.constant = [self rightArrowConstant];
        [self layoutSubtreeIfNeeded];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.animating) {
                [self animateArrow];
            }
        });
    }];
}

- (CGFloat)rightArrowConstant {
    CGFloat leftSpace = (self.frame.size.width - self.label.frame.size.width)/2;
    return leftSpace - arrowWidth - 20;
}

- (CGFloat)arrowAnimationDuration {
    CGFloat distance = [self rightArrowConstant] - leftArrowConstant;
    return distance/arrowAniamtionSpeed;
}
@end
