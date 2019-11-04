//
//  CAAnimation+DelegateProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAnimation (DelegateProxy)
- (void)animationDidStart:(void(^)(CAAnimation *anim))animationDidStartBlock;
- (void)animationDidStop:(void(^)(CAAnimation *anim))animationDidStopBlock;
@end

NS_ASSUME_NONNULL_END
