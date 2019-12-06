

//
//  UISliderControl.m
//  LEGOImageCropper_Example
//
//  Created by 杨庆人 on 2019/7/23.
//  Copyright © 2019年 564008993@qq.com. All rights reserved.
//

#import "LEGOSliderControl.h"
#import <Masonry/Masonry.h>

@interface LEGOSliderControl ()<UIScrollViewDelegate>
@property(nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UIImageView *scaleImageView;
@property (nonatomic, assign) BOOL isAnimated;
@property (nonatomic, assign) CGFloat halfScreenWidth;
@property (nonatomic, strong) CAGradientLayer *leftLayer;
@property (nonatomic, strong) CAGradientLayer *rightLayer;
@property (nonatomic, assign) CGFloat currRatio;

@end
@implementation LEGOSliderControl

- (instancetype)init
{
    if (self = [super init]) {
        _isAnimated = NO;
        [self setSliderControl];
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return _scrollView;
}

- (UIImageView *)scaleImageView
{
    if (!_scaleImageView) {
        _scaleImageView = [[UIImageView alloc] init];
        _scaleImageView.image = [UIImage imageNamed:@"img_cut_scroll"];
    }
    return _scaleImageView;
}

- (void)setSliderControl
{
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.mas_equalTo(65);
    }];
    [self.scrollView addSubview:self.scaleImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.halfScreenWidth = self.bounds.size.width / 2.0;
    self.scrollView.contentSize = CGSizeMake(self.halfScreenWidth * 6, 65);
    self.scaleImageView.frame = CGRectMake(self.halfScreenWidth, (self.scrollView.contentSize.height - 32) / 2.0, self.halfScreenWidth * 4, 32);
    CGFloat total = self.maximumValue - self.minimumValue;
    CGFloat ratio =  (self.value - self.minimumValue) / total;
    [self.scrollView setContentOffset:CGPointMake(ratio * self.scrollView.contentSize.width * (2 / 3.0), 0) animated:self.isAnimated];
    
    if (self.leftLayer && self.leftLayer.superlayer) {
        [self.leftLayer removeFromSuperlayer];
    }
    if (self.rightLayer && self.rightLayer.superlayer) {
        [self.rightLayer removeFromSuperlayer];
    }
    CGFloat layerWidth = self.halfScreenWidth * (80 / 130.0);
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, (self.scrollView.contentSize.height - 45) / 2.0, layerWidth, 45);
    leftLayer.startPoint = CGPointMake(0, 0);
    leftLayer.endPoint = CGPointMake(1, 0);
    leftLayer.colors = @[(__bridge id)LEGOColor(0, 0, 0, 1).CGColor,(__bridge id)LEGOColor(0, 0, 0, 0).CGColor];
    leftLayer.locations = @[@(0.0),@(1.0f)];
    [self.layer addSublayer:leftLayer];
    self.leftLayer = leftLayer;
    
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width - layerWidth, (self.scrollView.contentSize.height - 45) / 2.0, layerWidth, 45);
    rightLayer.startPoint = CGPointMake(1, 0);
    rightLayer.endPoint = CGPointMake(0, 0);
    rightLayer.colors = @[(__bridge id)LEGOColor(0, 0, 0, 1).CGColor,(__bridge id)LEGOColor(0, 0, 0, 0).CGColor];
    rightLayer.locations = @[@(0.0),@(1.0f)];
    [self.layer addSublayer:rightLayer];
    self.rightLayer = rightLayer;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginTrackingWithTouch)]) {
        [self.delegate beginTrackingWithTouch];
    }
}

- (void)setCurrValue:(CGFloat)value
{
    self.isAnimated = NO;
    _value = value;
    [self setNeedsLayout];
}

- (void)setCurrValue:(CGFloat)value animated:(BOOL)animated
{
    self.isAnimated = animated;
    _value = value;
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat total = self.maximumValue - self.minimumValue;
    if (!total) {
        return;
    }
    CGFloat ratio = self.scrollView.contentOffset.x / (self.scrollView.contentSize.width * (2 / 3.0));
    ratio = [[NSString stringWithFormat:@"%.3f",ratio] floatValue];
    self.value = ratio * total + self.minimumValue;
    if (self.delegate && [self.delegate respondsToSelector:@selector(continueTrackingWithTouch:)]) {
        [self.delegate continueTrackingWithTouch:self.value];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(continueTrackingWithTouch:changeValue:)]) {
        CGFloat changeValue = M_PI / 180 * (self.value - self.currRatio);
        [self.delegate continueTrackingWithTouch:self.value changeValue:changeValue];
    }
    self.currRatio = self.value;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endTrackingWithTouch)]) {
        [self.delegate endTrackingWithTouch];
    }
}

- (LEGONumberView *)sliderNumView
{
    if (!_sliderNumView) {
        _sliderNumView = [[LEGONumberView alloc] init];
        _sliderNumView.layer.cornerRadius = 2;
        _sliderNumView.layer.masksToBounds = YES;
        _sliderNumView.str = @"0.00";
    }
    return _sliderNumView;
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    if ((fabs(self.value) <= 0.1)) {
        self.sliderNumView.alpha = 0;
    }
    else {
        self.sliderNumView.alpha = alpha;
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.sliderNumView.userInteractionEnabled = userInteractionEnabled;
}


@end


@interface LEGONumberView ()
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation LEGONumberView

- (instancetype)init
{
    if (self = [super init]) {
        [self setSliderNumberView];
    }
    return self;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = LEGOColor(185, 185, 185, 1);
        _numLabel.font = [UIFont systemFontOfSize:11];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UIButton *)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:[UIImage imageNamed:@"icon_cut_reset"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(deleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (void)setSliderNumberView
{
    self.backgroundColor = LEGOColor(39, 39, 39, 1);
    [self addSubview:self.numLabel];
    [self addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.right.offset(0);
        make.top.bottom.offset(0);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.right.mas_equalTo(self.clearButton.mas_left);
    }];
}

- (void)setStr:(NSString *)str
{
    _str = str;
    if ([str floatValue] > 0) {
        str = [NSString stringWithFormat:@"+%@°",str];
    }
    else {
        str = [NSString stringWithFormat:@"%@°",str];
    }
    self.numLabel.text = str;
    
    if (fabs([str floatValue]) <= 0.1) {
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 0;
        }];
    }
    else {
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)deleButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clearSliderNumberWithAnimated:)]) {
        [self.delegate clearSliderNumberWithAnimated:YES];
    }
}

@end
