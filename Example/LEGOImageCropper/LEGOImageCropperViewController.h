//
//  LEGOImageCropperViewController.h
//  FilmCamera
//
//  Created by 杨庆人 on 2019/5/20.
//  Copyright © 2019年 The last stand. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEGOImageCropperViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void (^resizeComplete)(UIImage *image);

@end

NS_ASSUME_NONNULL_END
