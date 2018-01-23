//
//  ViewController.h
//  HGInitiation
//
//  Created by __无邪_ on 2017/12/25.
//  Copyright © 2017年 __无邪_. All rights reserved.
//

#import "HGBASEViewController.h"

@interface ViewController : HGBASEViewController


typedef NS_ENUM(NSUInteger, HGDataType) {
    HGDataType_Net,
    HGDataType_ImagePicker,
    HGDataType_AvatarCut,
    HGDataType_Picker,
    HGDataType_DatePicker,
    HGDataType_Alert,
    HGDataType_Browser,
    HGDataType_Theme,
    HGDataType_Other,
};


@end

