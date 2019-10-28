//
//  UIControlProxy.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import <Foundation/Foundation.h>

@class CSLBaseControl;
NS_ASSUME_NONNULL_BEGIN
@protocol UIControlProxyDelegate <NSObject>

- (void)onClick:(CSLBaseControl *)control;

@end
@interface UIControlProxy : NSObject
+ (instancetype)share;
@property (nonatomic, strong) id<UIControlProxyDelegate> delegate;
- (void)addTarget:(__weak CSLBaseControl *)target;
- (void)removeTarget:(__weak CSLBaseControl *)target;

- (void)controlClick:(CSLBaseControl *)control;
@end

NS_ASSUME_NONNULL_END
