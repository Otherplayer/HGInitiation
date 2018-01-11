//
//  HGScrollDefaultContentImage.h
//  HGInitiation
//
//  Created by __无邪_ on 2018/1/9.
//  Copyright © 2018年 __无邪_. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface HGScrollDefaultImageModel : NSObject
//@property(nonatomic, strong)NSString *imgUrl;
//@property(nonatomic, strong)NSString *title;
//@end

@interface HGScrollDefaultImage : UICollectionViewCell

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel *labTitle;

- (void)setImageUrl:(NSString *)imgUrl placeholderImage:(UIImage *)placeholderImage title:(NSString *)title;

@end
