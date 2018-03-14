//
//  Header.h
//  ZYKeyBoardTopViewDemo
//
//  Created by yao on 2018/3/5.
//  Copyright © 2018年 王智垚. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define kCMScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kCMScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kCMScaleWidth    (kCMScreenWidth > 320 ? 1.0 : (kCMScreenWidth / 360.0))
#define kCMScaleHeight   (kCMScreenHeight > 568.0 ? 1.0 : (kCMScreenHeight / 640.0))
#define kColorBorder     [[UIColor lightGrayColor] colorWithAlphaComponent:0.3]
#define kCM_loadBundleImage(imageName) [UIImage imageNamed:imageName]

#endif /* Header_h */
