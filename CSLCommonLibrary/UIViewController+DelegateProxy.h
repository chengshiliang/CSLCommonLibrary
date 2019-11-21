//
//  NSObject+PresentAnimation.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/21.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PresentAnimation)
- (void)presentingControllerBlock:(nullable id <UIViewControllerAnimatedTransitioning>(^)(UIViewController *presentingController, UIViewController *sourceController))presentingControllerBlock;
- (void)dismissedControllerBlock:(nullable id <UIViewControllerAnimatedTransitioning>(^)(UIViewController *dismissedController))dismissedControllerBlock;
- (void)interactionPresentingControllerBlock:(nullable id <UIViewControllerInteractiveTransitioning>(^)(id <UIViewControllerAnimatedTransitioning> animator))interactionPresentingControllerBlock;
- (void)interactionDismissedControllerBlock:(nullable id <UIViewControllerInteractiveTransitioning>(^)(id <UIViewControllerAnimatedTransitioning> animator))interactionDismissedControllerBlock;
@end

NS_ASSUME_NONNULL_END
