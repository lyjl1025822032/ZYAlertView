//
//  CMAMCustonAlertView.m
//  ZYKeyBoardTopViewDemo
//
//  Created by yao on 2018/3/3.
//  Copyright © 2018年 王智垚. All rights reserved.
//

#import "CMAMCustonAlertView.h"
#import "UIColor+CmosAllMedia.h"

@interface CMAMCustonAlertView ()<UIGestureRecognizerDelegate>
/**
 遮罩
 */
@property (strong, nonatomic) UIView *maskView;
/**
 弹出背景
 */
@property (strong, nonatomic) UIView *backView;
/**
 头像
 */
@property (strong, nonatomic) UIImageView *iconImageView;
/**
 提示语
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 取消按钮
 */
@property (strong, nonatomic) UIButton *cancelButton;
/**
 确定按钮
 */
@property (strong, nonatomic) UIButton *confirmButton;
@end

@implementation CMAMCustonAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self.backView addSubview:self.iconImageView];
        [self.backView addSubview:self.titleLabel];
    }
    return self;
}

/**
 普通alert弹窗
 */
- (void)showAlertViewWithTitleStr:(NSString *)titleString {
    self.titleLabel.frame = CGRectMake(25*kCMScaleWidth, 40*kCMScaleHeight, kCMScreenWidth-100*kCMScaleWidth, 60*kCMScaleHeight);
    self.titleLabel.text = titleString;
    [self.backView addSubview:self.cancelButton];

    self.confirmButton.frame = CGRectMake(kCMScreenWidth/2-5*kCMScaleWidth, 110*kCMScaleHeight, (kCMScreenWidth-170*kCMScaleWidth)/2, 40*kCMScaleHeight);
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.backView addSubview:self.confirmButton];
    
    [self.maskView addSubview:self.backView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    self.backView.transform = CGAffineTransformMakeScale(.1f, .1f);
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.maskView.alpha = 1.f;
        weakSelf.alpha = 1.f;
        weakSelf.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        weakSelf.backView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    }];
}

/**
 弹出icon/title/button弹窗
 */
- (void)showAlertViewWithTitleStr:(NSString *)titleString andButtonTitle:(NSString *)titlStr andImageIcon:(UIImage *)iconImage {
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.confirmButton];
    self.iconImageView.image = iconImage;
    self.titleLabel.text = titleString;
    [self.confirmButton setTitle:titlStr forState:UIControlStateNormal];
    
    [self.maskView addSubview:self.backView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    self.backView.transform = CGAffineTransformMakeScale(.1f, .1f);
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.maskView.alpha = 1.f;
        weakSelf.alpha = 1.f;
        weakSelf.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        weakSelf.backView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    }];
}

#pragma mark - Action
//关闭视图
- (void)handleDismiss:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

- (void)handleActionButton:(UIButton *)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)dismiss {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0.f;
        weakSelf.maskView.alpha = 0.f;
        weakSelf.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
            [weakSelf.maskView removeFromSuperview];
            [weakSelf.backView removeFromSuperview];
        }
    }];
}

#pragma mark UIGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.backView]) {
        return NO;
    }
    return YES;
}

#pragma mark LazyProperty
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismiss:)];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(25*kCMScaleWidth, (kCMScreenHeight-190*kCMScaleHeight)/2, kCMScreenWidth-50*kCMScaleWidth, 190*kCMScaleHeight)];
        _backView.layer.cornerRadius = 5;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kCMScreenWidth-140*kCMScaleHeight)/2, 10*kCMScaleHeight, 80*kCMScaleHeight, 80*kCMScaleHeight)];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10*kCMScaleHeight+80*kCMScaleHeight, kCMScreenWidth-50*kCMScaleWidth, 30*kCMScaleHeight)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#676767"];
        _titleLabel.numberOfLines = 0;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(40*kCMScaleWidth, 130*kCMScaleHeight, kCMScreenWidth-130*kCMScaleWidth, 40*kCMScaleHeight);
        [_confirmButton setBackgroundColor:[UIColor colorWithHexString:@"#4FA1FB"]];
        _confirmButton.layer.cornerRadius = 5;
        [_confirmButton addTarget:self action:@selector(handleActionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(40*kCMScaleWidth, 110*kCMScaleHeight, (kCMScreenWidth-170*kCMScaleWidth)/2, 40*kCMScaleHeight);
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.borderWidth = 1;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#4FA1FB"] forState:UIControlStateNormal];
        _cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#4FA1FB"].CGColor;
        [_cancelButton addTarget:self action:@selector(handleDismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end
