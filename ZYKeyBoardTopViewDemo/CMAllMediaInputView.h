//
//  CMAllMediaInputView.h
//  ZYKeyBoardTopViewDemo
//
//  Created by yao on 2018/3/2.
//  Copyright © 2018年 王智垚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CMAMInputViewType) {
    CMAMInputViewTypeServerNumber = 1,    //服务密码
    CMAMInputViewTypeIDCardNumber,        //身份证
    CMAMInputViewTypeAuthNumber,          //验证码
};

@interface CMAMPwdInputView : UIView
/**
 密文密码长度
 */
@property (assign, nonatomic) NSUInteger length;
/**
 输入完成回调
 */
@property (copy, nonatomic) void (^inputDidCompletion)(NSString *pwd);
@end

#pragma mark 弹出视图
@interface CMAllMediaInputView : UIView
/**
 输入结果回调
 */
@property (nonatomic, copy)void (^resultTextBlock)(NSString *text);
/**
 改变title提示语
 */
- (void)changeTitleString:(NSString *)titleString;
/**
 弹出视图
 */
- (void)showInputView:(CMAMInputViewType)inputType;
@end
