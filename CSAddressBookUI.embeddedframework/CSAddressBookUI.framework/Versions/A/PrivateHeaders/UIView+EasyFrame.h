//
//  UIView+EasyFrame.h
//  UberLife
//
//  Created by Luigi Again on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (easyFrame)

- (CGFloat)yOrigin;
- (CGFloat)xOrigin;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)bottomOrigin;
- (CGFloat)rightEdge;

- (void)setYCentre:(CGFloat)newYCentre;
- (void)setXCentre:(CGFloat)newXCentre;

- (void)setOrigin:(CGPoint)origin;
- (void)setYOrigin:(CGFloat)newYOrigin;
- (void)setXOrigin:(CGFloat)newXOrigin;
- (void)setHeight:(CGFloat)newHeight;
- (void)setWidth:(CGFloat)newWidth;

- (void)setWidth:(CGFloat)newWidth animated:(BOOL)animated;

- (void)setXBottomOrigin:(CGFloat)bottomOrigin;

- (void)setSize:(CGSize)newSize;

@end
