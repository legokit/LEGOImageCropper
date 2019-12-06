//
//  UISliderControl.h
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/23.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEGONumberView;

@protocol LEGOSliderControlDelegate <NSObject>
@optional
- (void)beginTrackingWithTouch;
- (void)continueTrackingWithTouch:(CGFloat)value;
- (void)continueTrackingWithTouch:(CGFloat)value changeValue:(CGFloat)changeValue;
- (void)endTrackingWithTouch;

@end

@interface LEGOSliderControl : UIControl

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id <LEGOSliderControlDelegate> delegate;
@property(nonatomic, assign, readonly) CGFloat value;
@property(nonatomic, assign) CGFloat minimumValue;
@property(nonatomic, assign) CGFloat maximumValue;

@property(nonatomic, strong) LEGONumberView *sliderNumView;

- (void)setCurrValue:(CGFloat)value;
- (void)setCurrValue:(CGFloat)value animated:(BOOL)animated;

@end


@protocol LEGONumberViewDelegate <NSObject>

@optional

- (void)clearSliderNumberWithAnimated:(BOOL)animated;
@end

@interface LEGONumberView : UIView
@property (nonatomic, weak) id <LEGONumberViewDelegate> delegate;
@property (nonatomic, copy) NSString *str;

- (void)deleButtonClick:(id)sender;
@end

