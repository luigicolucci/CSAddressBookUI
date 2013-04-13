//
//  UIView+EasyFrame.m
//  UberLife
//
//  Created by Luigi Again on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+EasyFrame.h"

#define kAnimationDuration 0.3

@implementation UIView (easyFrame)

- (CGFloat)yOrigin{
    return self.frame.origin.y;
}

- (CGFloat)xOrigin{
    return self.frame.origin.x;
}

- (void)setWidth:(CGFloat)newWidth animated:(BOOL)animated{
    
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration
                         animations:^(void){
            [self setWidth:newWidth];
        }];
    }
    else{
        [self setWidth:newWidth];
    }
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)bottomOrigin{
    return ([self height] + [self yOrigin]);
}

- (CGFloat)rightEdge{
    return ([self width] + [self xOrigin]);
}

- (void)setOrigin:(CGPoint)origin{

    CGRect currentFrame = self.frame;
    currentFrame.origin.y = origin.y;
    currentFrame.origin.x = origin.x;
    self.frame = currentFrame;
}

- (void)setYOrigin:(CGFloat)newYOrigin{
    
    CGRect currentFrame = self.frame;
    currentFrame.origin.y = newYOrigin;
    self.frame = currentFrame;
}

- (void)setXOrigin:(CGFloat)newXOrigin{
    
    CGRect currentFrame = self.frame;
    currentFrame.origin.x = newXOrigin;
    self.frame = currentFrame;
}

- (void)setXBottomOrigin:(CGFloat)bottomOrigin{
    
    CGFloat xOrigin = bottomOrigin - [self width];
    [self setXOrigin:xOrigin];
}

- (void)setXCentre:(CGFloat)newXCentre;
{
    CGPoint currentCentre = self.center;
    currentCentre.x = newXCentre;
    self.center = currentCentre;
}

- (void)setYCentre:(CGFloat)newYCentre;
{
    CGPoint currentCentre = self.center;
    currentCentre.y = newYCentre;
    self.center = currentCentre;
}

- (void)setHeight:(CGFloat)newHeight{
    
    CGRect currentFrame = self.frame;
    currentFrame.size.height = newHeight;
    self.frame = currentFrame;
}

- (void)setWidth:(CGFloat)newWidth{
    
    CGRect currentFrame = self.frame;
    currentFrame.size.width = newWidth;
    self.frame = currentFrame;
}

- (void)setSize:(CGSize)newSize{
    
    CGRect currentFrame = self.frame;
    currentFrame.size = newSize;
    self.frame = currentFrame;
}

@end
