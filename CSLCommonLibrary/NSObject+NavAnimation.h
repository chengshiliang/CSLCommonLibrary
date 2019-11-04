//
//  NSObject+NavAnimation.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NavAnimation)
- (void)transitionDurationBlock:(NSTimeInterval(^)(_Nullable id <UIViewControllerContextTransitioning> transitionContext))transitionDurationBlock;
- (void)animateTransitionBlock:(void(^)(id <UIViewControllerContextTransitioning> transitionContext))animateTransitionBlock;
- (void)animationEndedBlock:(void(^)(BOOL transitionCompleted))animationEndedBlock;
@end

NS_ASSUME_NONNULL_END
