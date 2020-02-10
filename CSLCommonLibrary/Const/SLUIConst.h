//
//  SLUIConst.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN const NSString *const SLLabelFontSize;
UIKIT_EXTERN const NSString *const SLLabelColor;
UIKIT_EXTERN const NSString *const SLAlertWidth;
UIKIT_EXTERN const NSString *const SLAlertContentInset;
typedef NS_ENUM(NSInteger, SLViewDirection) {
    Horizontal,// 横向
    Vertical,// 纵向
};
typedef NS_ENUM(NSInteger, LabelType){
    LabelH1 = 1,// h1
    LabelH2 = 2,// h2
    LabelH3 = 3,// h3
    LabelH4 = 4,// h4
    LabelH5 = 5,// h5
    LabelH6 = 6,// h6
    LabelBold = 7,// 加粗
    LabelNormal = 0,// 正常大小
    LabelSelect = 8,// 稍微暗点
    LabelDisabel = 9// 置灰
};

typedef NS_ENUM(NSInteger, AlertType){
    AlertView = 0,// UIAlertView
    AlertSheet = 1,// UIActionSheet
};
typedef NS_ENUM(NSInteger, AlertActionType){
    AlertActionCancel = 0,
    AlertActionDefault = 1,
    AlertActionDestructive = 2
};
typedef NS_ENUM(NSInteger, AlertContentViewAlignmentType) {
    AlertContentViewAlignmentCenter = 0,
    AlertContentViewAlignmentLeft = 1,
    AlertContentViewAlignmentRight = 2,
};
@interface SLUIConst : NSObject

@end

NS_ASSUME_NONNULL_END
