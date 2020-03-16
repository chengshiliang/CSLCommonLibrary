//
//  SLRouteProtocol.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2020/3/17.
//

#import <Foundation/Foundation.h>
#import <CSLCommonLibrary/SLCatchVCProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLRouteProtocol <NSObject>
- (id<SLCatchVCProtocol>)produce;
@end

NS_ASSUME_NONNULL_END
