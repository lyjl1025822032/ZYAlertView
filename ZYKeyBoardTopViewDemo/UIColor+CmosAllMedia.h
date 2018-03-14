//
//  UIColor+CmosAllMedia.h
//  CmosAllMediaUI
//
//  Created by liangscofield on 2017/8/21.
//  Copyright © 2017年 cmos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CmosAllMedia)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert ;
+ (NSString *) changeUIColorToRGB:(UIColor *)color ;
+ (BOOL)isSameColor:(UIColor*)color1 anotherColor:(UIColor*)color2;
- (UIImage*)createImage;

@end
