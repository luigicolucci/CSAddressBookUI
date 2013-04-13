//
//  UIColor+ULColor.m
//  UberLife
//
//  Created by luigi br on 06/01/12.
//  Copyright (c) 2012 la sua. All rights reserved.
//

#import "UIColor+ULColor.h"
#import "ULLog.h"


@implementation UIColor (ULColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    
    // Set the background            
    NSString *redString   = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *greenString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *blueString  = [hexString substringWithRange:NSMakeRange(4, 2)];
    
    if (redString   != nil && 
        greenString != nil &&
        blueString  != nil) {
        
        unsigned int r, g, b;
        [[NSScanner scannerWithString:redString] scanHexInt:&r];
        [[NSScanner scannerWithString:greenString] scanHexInt:&g];
        [[NSScanner scannerWithString:blueString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }
    else{
        ELog(@"ULColor Enable to create custom color. White will be returned");
        return [UIColor whiteColor];
    }
}

+ (UIColor *)colorWithHexString:(NSString *)hexString{
    
    UIColor *color = [UIColor colorWithHexString:hexString alpha:1.0];
    return color;
}

@end