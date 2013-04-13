//
//  UIColor+ULColor.h
//  UberLife
//
//  Created by luigi br on 06/01/12.
//  Copyright (c) 2012 la sua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ULColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
