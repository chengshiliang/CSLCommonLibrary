//
//  SLUIConsts.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#ifndef SLUIConsts_h
#define SLUIConsts_h

#define Iphone13  [UIDevice currentDevice].systemVersion.doubleValue >= 13.0
#define Iphone12  [UIDevice currentDevice].systemVersion.doubleValue >= 12.0
#define Iphone11  [UIDevice currentDevice].systemVersion.doubleValue >= 11.0
#define Iphone10  [UIDevice currentDevice].systemVersion.doubleValue >= 10.0
#define Iphone9  [UIDevice currentDevice].systemVersion.doubleValue >= 9.0

#define WeakSelf __weak typeof (self) weakSelf = self
#define StrongSelf __strong typeof (self) strongSelf = weakSelf

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define SLUIColor(r, g, b) SLUIColorWithAlpha(r, g, b, 1)
#define SLUIColorWithAlpha(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

#define SLUIHexColor(rgb) SLUIHexAlphaColor(rgb, 1)
#define SLUIHexAlphaColor(rgb, a) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:(a)]

#define SLUIBoldFont(size) [UIFont boldSystemFontOfSize:size]
#define SLUINormalFont(size) [UIFont systemFontOfSize:size]

#define SLH1LabelFont SLUIBoldFont(40.0)
#define SLH2LabelFont SLUIBoldFont(36.0)
#define SLH3LabelFont SLUIBoldFont(32.0)
#define SLH4LabelFont SLUIBoldFont(26.0)
#define SLH5LabelFont SLUIBoldFont(22.0)
#define SLH6LabelFont SLUIBoldFont(20.0)
#define SLBoldLabelFont SLUIBoldFont(17.0)
#define SLNormalLabelFont SLUINormalFont(17.0)
#define SLSelectLabelFont SLUINormalFont(16.0)
#define SLDisabelLabelFont SLUINormalFont(15.0)

#define SLH1LabelColor SLUIHexColor(0x000000)
#define SLH2LabelColor SLUIHexColor(0x000000)
#define SLH3LabelColor SLUIHexColor(0x000000)
#define SLH4LabelColor SLUIHexColor(0x000000)
#define SLH5LabelColor SLUIHexColor(0x000000)
#define SLH6LabelColor SLUIHexColor(0x000000)
#define SLBoldLabelColor SLUIHexColor(0x000000)
#define SLNormalLabelColor SLUIHexColor(0x000000)
#define SLSelectLabelColor SLUIHexColor(0x666666)
#define SLDisableLabelColor SLUIHexColor(0x999999)

#endif /* SLUIConsts_h */
