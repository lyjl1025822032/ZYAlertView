//
//  CMAMCustonAlertView.h
//  ZYKeyBoardTopViewDemo
//
//  Created by yao on 2018/3/3.
//  Copyright © 2018年 王智垚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMAMCustonAlertView : UIView
/**
 按钮回调
 */
@property (nonatomic, copy)void (^confirmBlock)(void);
/**
 普通alert弹窗
 */
- (void)showAlertViewWithTitleStr:(NSString *)titleString;

/**
 弹出icon/title/button弹窗
 */
- (void)showAlertViewWithTitleStr:(NSString *)titleString andButtonTitle:(NSString *)titlStr andImageIcon:(UIImage *)iconImage;
@end
