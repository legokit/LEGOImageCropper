//
//  LEGOViewController.h
//  LEGOImageCropper
//
//  Created by 564008993@qq.com on 07/19/2019.
//  Copyright (c) 2019 564008993@qq.com. All rights reserved.
//


#import "LEGOViewController.h"
#import <Masonry/Masonry.h>
#import "LEGOImageCropperViewController.h"

@interface LEGOViewController ()
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIImageView *perviewView;
@end

@implementation LEGOViewController

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = [UIColor lightGrayColor];
        [_addButton setImage:[UIImage imageNamed:@"icon_album_import"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIImageView *)perviewView {
    if (!_perviewView) {
        _perviewView = [[UIImageView alloc] init];
        _perviewView.contentMode = UIViewContentModeScaleAspectFit;
        _perviewView.layer.masksToBounds = YES;
        _perviewView.layer.allowsEdgeAntialiasing = YES;
        _perviewView.layer.minificationFilter = kCAFilterTrilinear;
        _perviewView.layer.magnificationFilter = kCAFilterTrilinear;
        _perviewView.image = [UIImage imageNamed:@"IMG_1148"];
    }
    return _perviewView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"LEGOImageCropper";
    
    [self.view addSubview:self.perviewView];
    [self.perviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 300));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-50);
    }];
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.perviewView.mas_bottom).offset(50);
    }];

}

- (void)addButtonAction:(id)sender {
    LEGOImageCropperViewController *vc = [[LEGOImageCropperViewController alloc] init];
    vc.image = [UIImage imageNamed:@"IMG_1148"];
    vc.resizeComplete = ^(UIImage * _Nonnull image) {
        self.perviewView.image = image;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


@end

