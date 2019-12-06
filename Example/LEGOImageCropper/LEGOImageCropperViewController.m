//
//  LEGOImageCropperViewController.m
//  FilmCamera
//
//  Created by 杨庆人 on 2019/5/20.
//  Copyright © 2019年 The last stand. All rights reserved.
//

#import "LEGOImageCropperViewController.h"
#import <LEGOImageCropperView.h>
#import "LEGOSliderControl.h"

@interface LEGOImageCropperViewController ()<LEGOSliderControlDelegate,LEGONumberViewDelegate>
@property (nonatomic, assign) CGSize currScale;
@property (nonatomic, strong) LEGOImageCropperView *imageCropperView;
@property (nonatomic, strong) LEGOSliderControl *sliderControl;

@property (nonatomic, strong) UIButton *scaleButton;
@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *completeButton;

@end

@implementation LEGOImageCropperViewController

- (CGSize)currScale {
    if ([[NSValue valueWithCGSize:_currScale] isEqualToValue:[NSValue valueWithCGSize:CGSizeZero]]) {
        _currScale = CGSizeMake(2, 3);
    }
    return _currScale;
}

- (LEGOImageCropperView *)imageCropperView {
    if (!_imageCropperView) {
        _imageCropperView = ({
            LEGOImageCropperView *imageCropperView = [[LEGOImageCropperView alloc] initWithImage:self.image frame:[self imageCropViewFrame:self.currScale]];
            imageCropperView.maskColor = LEGOColor(27, 27, 27, 1);
            imageCropperView.shadowColor = [UIColor colorWithWhite:1 alpha:0.2];
            imageCropperView.shapeLayerColor = [UIColor colorWithWhite:1 alpha:0.3];
            imageCropperView.resizeWHRatio = self.currScale;
            imageCropperView.rotationEnabled = NO;
            imageCropperView.doubleResetEnabled = NO;
            imageCropperView.minificationFilter = kCAFilterTrilinear;
            imageCropperView.magnificationFilter = kCAFilterTrilinear;
            imageCropperView.minZoomScale = 200;
            imageCropperView.maxZoomScale = MAXFLOAT;
            

            imageCropperView;
        });
    }
    return _imageCropperView;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton setTitle:@"crop" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _completeButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        _completeButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _completeButton.layer.cornerRadius = 25;
        _completeButton.layer.masksToBounds = YES;
        [_completeButton addTarget:self action:@selector(cropImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

- (UIButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleButton setImage:[UIImage imageNamed:@"icon_album_cut_format_32"] forState:UIControlStateNormal];
        [_scaleButton setImage:[UIImage imageNamed:@"icon_album_cut_format_23"] forState:UIControlStateSelected];
        [_scaleButton addTarget:self action:@selector(resizeWHScale:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scaleButton;
}

- (UIButton *)rotateButton {
    if (!_rotateButton) {
        _rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rotateButton setImage:[UIImage imageNamed:@"icon_album_cut_rotate"] forState:UIControlStateNormal];
        [_rotateButton addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateButton;
}

- (LEGOSliderControl *)sliderControl {
    if (!_sliderControl) {
        _sliderControl = [[LEGOSliderControl alloc] init];
        _sliderControl.delegate = (id <LEGOSliderControlDelegate>)self;
        _sliderControl.minimumValue = -30.0f;
        _sliderControl.maximumValue = 30.0f;
        [_sliderControl setCurrValue:0.0f];
        _sliderControl.sliderNumView.delegate = self;
    }
    return _sliderControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageCropperView];
    
    [self.view addSubview:self.completeButton];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(50);
        make.bottom.offset(IS_IPHONE_X ? -(35 + 32) : -35);
    }];
    
    [self.view addSubview:self.scaleButton];
    [self.scaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.offset(25);
        make.bottom.mas_equalTo(self.completeButton.mas_top).offset(-22);
    }];
    [self.view addSubview:self.rotateButton];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.offset(-25);
        make.bottom.mas_equalTo(self.completeButton.mas_top).offset(-22);
    }];
    
    [self.view insertSubview:self.sliderControl belowSubview:self.scaleButton];
    [self.sliderControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scaleButton.mas_right).offset(-15);
        make.right.mas_equalTo(self.rotateButton.mas_left).offset(15);
        make.bottom.mas_equalTo(self.completeButton.mas_top).offset(-12);
    }];
    
    [self.view addSubview:self.sliderControl.sliderNumView];
    [self.sliderControl.sliderNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sliderControl.mas_centerX);
        make.bottom.mas_equalTo(self.scaleButton.mas_top).offset(1);
        make.width.mas_equalTo(70);
    }];
        
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    NSLog(@"LEGOImageCropperViewController dealloc");
}

- (void)beginTrackingWithTouch {

}

- (void)continueTrackingWithTouch:(CGFloat)value changeValue:(CGFloat)changeValue {
    self.sliderControl.sliderNumView.str = [NSString stringWithFormat:@"%.2f",value];
    [self.imageCropperView setRotationAngle:changeValue];
}

- (void)endTrackingWithTouch {

}

- (void)clearSliderNumberWithAnimated:(BOOL)animated {
    [self.sliderControl setCurrValue:0 animated:animated];
}

- (void)rotate:(id)sender {
    [self.imageCropperView rotation:YES];
}

- (void)resizeWHScale:(id)sender {
    UIButton *scaleButton = (UIButton *)sender;
    scaleButton.selected = !scaleButton.selected;
    if (!scaleButton.selected) {
        self.currScale = CGSizeMake(2, 3);
    }
    else {
        self.currScale = CGSizeMake(3, 2);
    }
    [UIView animateWithDuration:0.15 animations:^{
        self.imageCropperView.frame = [self imageCropViewFrame:self.currScale];
        [self.imageCropperView setResizeWHRatio:self.currScale animated:NO];
    } completion:nil];
}

- (void)cropImage:(id)sender {
    [self.imageCropperView cropImageWithComplete:^(UIImage *resizeImage) {
        NSLog(@"resizeImage=%@",resizeImage);
        if (self.resizeComplete) {
            self.resizeComplete(resizeImage);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
 
}

- (CGRect)imageCropViewFrame:(CGSize)size {
    CGRect rect = CGRectZero;
    if ([[NSValue valueWithCGSize:size] isEqualToValue:[NSValue valueWithCGSize:CGSizeMake(2, 3)]]) {
        CGFloat width = LEGOScreenWidth - 28 * 2;
        CGFloat height = width * 3 / 2.0;
        rect = CGRectMake(28, (LEGOScreenHeight - height) / 2.0 - 60, width, height);
    }
    else if ([[NSValue valueWithCGSize:size] isEqualToValue:[NSValue valueWithCGSize:CGSizeMake(3, 2)]]) {
        CGFloat width = LEGOScreenWidth - 28 * 2;
        CGFloat height = width * 2 / 3.0;
        rect = CGRectMake(28, (LEGOScreenHeight - height) / 2.0 - 50, width, height);
    }
    return rect;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

