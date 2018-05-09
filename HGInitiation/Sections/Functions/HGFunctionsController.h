//
//  HGFunController.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/5/3.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import "HGBASEViewController.h"

typedef NS_ENUM(NSUInteger, HGDataType) {
    HGDataType_ImagePicker,
    HGDataType_AvatarCut,
    HGDataType_Picker,
    HGDataType_DatePicker,
    HGDataType_Biometrics,
    HGDataType_Browser,
    HGDataType_Theme,
    HGDataType_Other,
};

@interface HGFunctionsController : HGBASEViewController

@end
