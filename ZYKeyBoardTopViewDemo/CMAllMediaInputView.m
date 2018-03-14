//
//  CMAllMediaInputView.m
//  ZYKeyBoardTopViewDemo
//
//  Created by yao on 2018/3/2.
//  Copyright © 2018年 王智垚. All rights reserved.
//

#import "CMAllMediaInputView.h"

#define kColorBorder   [[UIColor lightGrayColor] colorWithAlphaComponent:0.3]

//原点直径
static const CGFloat dotDiameter = 12.f;
//密码位数
static const NSInteger pwdNumber = 6;

#pragma mark 密文输入框
@interface CMAMPwdInputView () <UITextFieldDelegate>
/**
 原点数组
 */
@property (strong, nonatomic) NSMutableArray *secureDots;
/**
 密码位数数组
 */
@property (strong, nonatomic) NSMutableArray *secureCounts;
/**
 键盘响应者
 */
@property (strong, nonatomic) UITextField *responder;
@end

@implementation CMAMPwdInputView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = dotDiameter*0.5;
    CGFloat w = (self.frame.size.width - 30*kCMScaleWidth) / self.length;
    
    [self.secureCounts enumerateObjectsUsingBlock:^(UIView  *_Nonnull layerView, NSUInteger idx, BOOL * _Nonnull stop) {
        layerView.frame = CGRectMake((w+6)*idx, 0, w-1, self.frame.size.height-1);
    }];
    
    [self.secureDots enumerateObjectsUsingBlock:^(CAShapeLayer *_Nonnull dot, NSUInteger idx, BOOL * _Nonnull stop) {
        dot.position = CGPointMake((w + 5.5) * (0.5 + idx) - margin, self.frame.size.height * 0.5 - margin);
        dot.hidden = YES;
        if (_responder.text.length) {
            dot.hidden = idx < _responder.text.length ? NO : YES;
        }
    }];
}

#pragma mark - Privite
- (void)configurViewWithLength:(NSUInteger)length {
    [self.secureDots removeAllObjects];
    [self.secureCounts removeAllObjects];
    
    for (int i = 0; i < length; i++) {
        UIView *layerView = [[UIView alloc] init];
        layerView.layer.cornerRadius = 2;
        layerView.layer.borderWidth = 1;
        layerView.layer.borderColor = kColorBorder.CGColor;
        [self addSubview:layerView];
        [self.secureCounts addObject:layerView];
        
        CAShapeLayer *dot = [CAShapeLayer layer];
        dot.fillColor = [UIColor blackColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, dotDiameter, dotDiameter)];
        dot.path = path.CGPath;
        dot.hidden = YES;
        [self.layer addSublayer:dot];
        [self.secureDots addObject:dot];
    }
}

- (void)addNotifications {
    __weak typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSUInteger length = weakSelf.responder.text.length;
        if (length > weakSelf.length) {
            self.responder.text = [weakSelf.responder.text substringToIndex:weakSelf.length];
        }
        
        [self.secureDots enumerateObjectsUsingBlock:^(CAShapeLayer *dot, NSUInteger idx, BOOL * stop) {
            dot.hidden = idx < length ? NO : YES;
        }];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == self.length && self.inputDidCompletion) {
        self.inputDidCompletion(self.responder.text);
    }
    return YES;
}

#pragma mark - Setter/Getter
- (void)setLength:(NSUInteger)length {
    _length = length;
    if (length > 0) {
        [self configurViewWithLength:length];
    }
}

- (NSMutableArray *)secureDots {
    if (!_secureDots) {
        _secureDots = [NSMutableArray arrayWithCapacity:self.length];
    }
    return _secureDots;
}

- (NSMutableArray *)secureCounts {
    if (!_secureCounts) {
        _secureCounts = [NSMutableArray arrayWithCapacity:self.length];
    }
    return _secureCounts;
}

- (UITextField *)responder {
    if (!_responder) {
        _responder = [[UITextField alloc] initWithFrame:CGRectZero];
        _responder.hidden = YES;
        _responder.delegate = self;
        _responder.returnKeyType = UIReturnKeyDone;
        _responder.autocorrectionType = UITextAutocorrectionTypeNo;
        _responder.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _responder;
}

#pragma mark - Overwrite
- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [self addSubview:self.responder];
    [self.responder becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [self endEditing:YES];
    return YES;
}

- (BOOL)endEditing:(BOOL)force {
    [super endEditing:force];
    if (force) {
        self.responder.text = nil;
        [self.secureDots enumerateObjectsUsingBlock:^(CAShapeLayer *_Nonnull dot, NSUInteger idx, BOOL * _Nonnull stop) {
            dot.hidden = YES;
        }];
    }
    return force;
}
@end

#pragma mark 弹出视图
@interface CMAllMediaInputView () <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    NSInteger timeCount;
    CMAMInputViewType viewType;
}
/**
 遮罩
 */
@property (strong, nonatomic) UIView *maskView;
/**
 键盘上部视图
 */
@property (strong, nonatomic) UIView *backView;
/**
 关闭按钮
 */
@property (strong, nonatomic) UIButton *closeBtn;
/**
 提示语
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 分割线
 */
@property (strong, nonatomic) UIView *lineView;
/**
 服务密码输入框
 */
@property (strong, nonatomic) CMAMPwdInputView *inputView;
/**
 身份证/验证码输入框
 */
@property (strong, nonatomic) UITextField *inputTextField;
/**
 验证码获取按钮
 */
@property (strong, nonatomic) UIButton *authButton;
@end

@implementation CMAllMediaInputView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //1.关闭按钮
        [self.backView addSubview:self.closeBtn];
        //2.提示语
        [self.backView addSubview:self.titleLabel];
        //3.分割线
        [self.backView addSubview:self.lineView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - Public
- (void)showInputView:(CMAMInputViewType)inputType {
    [self.maskView addSubview:self.backView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    
    //4.输入区样式
    [self configureInputTypeView:inputType];
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.maskView.alpha = 1.f;
        weakSelf.alpha = 1.f;
        weakSelf.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        if (inputType == CMAMInputViewTypeServerNumber) {
            [self.inputView becomeFirstResponder];
        }
    }];
}

- (void)changeTitleString:(NSString *)titleString {
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", titleString]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = kCM_loadBundleImage(@"errortitle");
    CGFloat imgH = self.titleLabel.font.pointSize;
    CGFloat imgW = (attach.image.size.width / attach.image.size.height) * imgH;
    CGFloat textPaddingTop = (self.titleLabel.font.lineHeight - imgH) / 2 + 1;
    attach.bounds = CGRectMake(0, -textPaddingTop , imgW, imgH);
    
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attach];
    [attri insertAttributedString:string atIndex:0];
    self.titleLabel.textColor = [UIColor colorWithRed:246/255.0 green:84/255.0 blue:84/255.0 alpha:1];
    self.titleLabel.attributedText = attri;
}

#pragma mark - Privite
- (void)configureInputTypeView:(CMAMInputViewType)inputType {
    viewType = inputType;
    switch (inputType) {
        case 1: {
            _titleLabel.text = @"请输入服务密码";
            __weak typeof(self)weakSelf = self;
            weakSelf.inputView.inputDidCompletion = ^(NSString *pwd) {
                weakSelf.resultTextBlock(pwd);
            };
            self.inputView.length = pwdNumber;
            [self.backView addSubview:self.inputView];
        }
            break;
        case 2:
            _titleLabel.text = @"请输入身份证号";
            self.inputTextField.placeholder = @"请输入18位身份证号";
            [self.backView addSubview:self.inputTextField];
            [self.inputTextField becomeFirstResponder];
            break;
        case 3:
            _titleLabel.text = @"请输入验证码";
            self.inputTextField.placeholder = @"请输入6位验证码";
            self.inputTextField.rightView = self.authButton;
            self.inputTextField.rightViewMode = UITextFieldViewModeAlways;
            [self.backView addSubview:self.inputTextField];
            [self.inputTextField becomeFirstResponder];
            break;
        default:
            break;
    }
}

#pragma mark - Action
//关闭视图
- (void)handleDismiss:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

//获取验证码
- (void)handleGetAuthNumber:(UIButton *)sender {
    timeCount = 60;
    sender.enabled = NO;
    [sender setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    [sender setTitle:@" 60S后再次获取 " forState:UIControlStateNormal];
    //60s等待响应计时
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitingTimerAction:) userInfo:nil repeats:YES];
}

- (void)waitingTimerAction:(NSTimer *)timer {
    timeCount--;
    UIButton *button = (UIButton *)self.inputTextField.rightView;
    if (timeCount == 0) {
        [timer invalidate];
        timer = nil;
        button.enabled = YES;
        [button setBackgroundColor:[UIColor colorWithRed:79/255.0 green:161/255.0 blue:251/255.0 alpha:1]];
        [button setTitle:@"点击获取" forState:UIControlStateNormal];
        self.titleLabel.text = @"请输入验证码";
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    } else {
        [button setTitle:[NSString stringWithFormat:@" %ldS后再次获取 ", timeCount] forState:UIControlStateNormal];
    }
}

- (void)dismiss {
    viewType == CMAMInputViewTypeServerNumber?[self.inputView resignFirstResponder]:[self.inputTextField resignFirstResponder];
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
            [weakSelf.inputView removeFromSuperview];
        }
    }];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.resultTextBlock(textField.text);
    return YES;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    switch (viewType) {
        case CMAMInputViewTypeIDCardNumber:
            if (textField.text.length >= 18) {
                textField.text = [textField.text substringToIndex:18];
            }
            break;
        case CMAMInputViewTypeAuthNumber:
            if (textField.text.length >= 6) {
                textField.text = [textField.text substringToIndex:6];
            }
            break;
        default:
            break;
    }
    NSDictionary *attrsDictionary = @{NSFontAttributeName:textField.font,NSKernAttributeName:[NSNumber numberWithFloat:10.0f]};
    textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text attributes:attrsDictionary];
}

#pragma mark 键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if ((begin.size.height > 0 || (begin.size.height == 0 && end.origin.y < kCMScreenHeight)) && (begin.origin.y - end.origin.y > 0)){
        CGFloat keyBoardHeight = end.size.height;
        
        [UIView animateWithDuration:0.05 animations:^{
            self.backView.frame = CGRectMake(0, kCMScreenHeight - keyBoardHeight - 150*kCMScaleHeight, kCMScreenWidth, 150*kCMScaleHeight);
        }];
    }
}

#pragma mark 键盘隐藏事件
- (void)keyBoardDidHide:(NSNotification *)notification{
    [self dismiss];
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
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kCMScreenHeight+150*kCMScaleHeight, kCMScreenWidth, 150*kCMScaleHeight)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 10*kCMScaleHeight, 30*kCMScaleWidth, 30*kCMScaleWidth);
        [_closeBtn setImage:kCM_loadBundleImage(@"alertclose") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*kCMScaleWidth, 0, kCMScreenWidth-60*kCMScaleWidth, 50*kCMScaleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*kCMScaleHeight, kCMScreenWidth, 0.5)];
        _lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    }
    return _lineView;
}

- (CMAMPwdInputView *)inputView {
    if (!_inputView) {
        _inputView = [[CMAMPwdInputView alloc] initWithFrame:CGRectMake(20*kCMScaleWidth, 70*kCMScaleHeight, kCMScreenWidth-40*kCMScaleWidth, 50*kCMScaleHeight)];
    }
    return _inputView;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20*kCMScaleWidth, 70*kCMScaleHeight, kCMScreenWidth-40*kCMScaleWidth, 50*kCMScaleHeight)];
        _inputTextField.delegate = self;
        _inputTextField.layer.cornerRadius = 2;
        _inputTextField.layer.borderWidth = 0.5f;
        _inputTextField.layer.borderColor = kColorBorder.CGColor;
        _inputTextField.returnKeyType = UIReturnKeyDone;
        _inputTextField.enablesReturnKeyAutomatically = YES;
        _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20*kCMScaleWidth, 0)];
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        [_inputTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTextField;
}

- (UIButton *)authButton {
    if (!_authButton) {
        _authButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _authButton.frame = CGRectMake(0, 0, 100*kCMScaleWidth, 50*kCMScaleHeight);
        [_authButton setTitle:@"点击获取" forState:UIControlStateNormal];
        [_authButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_authButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_authButton setBackgroundColor:[UIColor colorWithRed:79/255.0 green:161/255.0 blue:251/255.0 alpha:1]];
        [_authButton addTarget:self action:@selector(handleGetAuthNumber:) forControlEvents:UIControlEventTouchUpInside];
        _authButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _authButton;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end

