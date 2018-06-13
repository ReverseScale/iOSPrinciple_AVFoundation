//
//  UIColor+Hex.h
//  Parrot
//
//  Created by DengLiujun on 16/1/4.
//  Copyright © 2016年 liujun.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor*)colorWithRGB:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
