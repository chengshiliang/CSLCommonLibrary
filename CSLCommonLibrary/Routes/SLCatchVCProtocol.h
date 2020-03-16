//
//  SLCatchVCProtocol.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2020/3/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLCatchVCProtocol <NSObject>
- (UIViewController *)getTargetVC;
@end

NS_ASSUME_NONNULL_END
