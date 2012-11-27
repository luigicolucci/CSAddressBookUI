//
//  ULBoldLabel.h
//  UberLife
//
//  Created by Luigi Colucci on 10/07/2012.
//  Copyright (c) 2012 luigi@uberlife.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ULBoldLabel : UIView{
    
    NSMutableArray *labelArray;
    NSInteger defaultLabelHeight;
    NSInteger fontSize;
}

- (void)addString:(NSString *)text;
- (void)addBoldString:(NSString *)text;
- (void)setFontSize:(NSInteger)fontSize;

- (void)clean;

@end
