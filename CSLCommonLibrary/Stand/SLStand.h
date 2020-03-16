//
//  SLStand.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2020/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLStand : NSObject
+ (instancetype)sharedInstance;
/// 超过多少毫秒为一次卡顿 400毫秒
@property (nonatomic, assign) NSInteger limitMillisecond;

/// 多少次卡顿纪录为一次有效，默认为5次
@property (nonatomic, assign) NSInteger standstillCount;

/// 发生一次有效的卡顿回调函数
@property (nonatomic, copy) void (^callbackWhenStandStill)(void);

/**
 开始监听卡顿
 */
- (void)startMonitor;

/**
 结束监听卡顿
 */
- (void)endMonitor;
@end

NS_ASSUME_NONNULL_END
