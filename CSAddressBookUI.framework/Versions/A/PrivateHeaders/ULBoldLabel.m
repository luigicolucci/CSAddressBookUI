//
//  ULBoldLabel.m
//
// Copyright (c) 2012 Luigi Colucci - CitySocialising
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ULBoldLabel.h"
#import "CSUtils.h"

@interface ULBoldLabel ()

@property (nonatomic, strong) NSMutableArray *labelArray;

- (void)addString:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

@end

@implementation ULBoldLabel
@synthesize labelArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.labelArray = [[NSMutableArray alloc] init];
        defaultLabelHeight = 18;
        fontSize = 14;
    }
    return self;
}

- (void)setFontSize:(NSInteger)size{
    
    fontSize = size;
    defaultLabelHeight = size + 4;
    [self setNeedsDisplay];
}

- (void)addString:(NSString *)text{
        
    if ([text isValidString]) {
        
        UIFont *labelFont = [UIFont systemFontOfSize:fontSize];
       // UIColor *normalColor = [UIColor colorWithHexString:@"acacac"];
        [self addString:text font:labelFont color:[UIColor blackColor]];
    }
}

- (void)addBoldString:(NSString *)text{
    
    if ([text isValidString]) {
        
        UIFont *labelFont = [UIFont boldSystemFontOfSize:fontSize];
        //UIColor *boldColor = [UIColor colorWithHexString:@"505050"];
        [self addString:text font:labelFont color:[UIColor blackColor]];
    }
}

- (void)addString:(NSString *)text font:(UIFont *)font color:(UIColor *)color{
    
    BOOL shouldKeepAdding = YES;
    
    NSArray *wordsArray = [text componentsSeparatedByString:@" "];
    
    for (NSString *word in wordsArray) {
        
        CGRect lastLabelFrame = CGRectMake(0., -3, [self width], [self height]);
        CGFloat leftRightSide = [self width];
        
        // Get the last label stored into the labelArray and check position
        int numberOfLabel = [labelArray count];
        if ([labelArray count] > 0) {
            
            UILabel *lastLabel = [labelArray lastObject];
            lastLabelFrame = lastLabel.frame;
            leftRightSide = [self width] - (lastLabelFrame.size.width + lastLabelFrame.origin.x);
        }
        
        CGSize labelSize = CGSizeMake(leftRightSide, 999);
        CGSize textSize = [word sizeWithFont:font constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat lastLabelRightEdge = lastLabelFrame.origin.x;
        
        // If there is at least one string into the array then get the right edge point
        if (numberOfLabel >0) {
            lastLabelRightEdge += lastLabelFrame.size.width + 2;
        }
        
        NSString *newWord = word;
        
        // Check if the string has been truncated
        if (textSize.height > defaultLabelHeight || lastLabelRightEdge >= [self width]) {
            
            lastLabelFrame.origin.y += defaultLabelHeight - 2;
            
            // Re-calculate the size according to the new width
            CGSize labelSize = CGSizeMake([self width], 999);
            
            textSize = [word sizeWithFont:font constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
            
            if (lastLabelFrame.origin.y >= ((defaultLabelHeight - 2) * 2)-5) {
                lastLabelFrame.origin.y -= defaultLabelHeight - 2;
                newWord = @"...";
                shouldKeepAdding = NO;
            }
            else {
                // Set the view height
                lastLabelRightEdge = 0;
                [self setHeight:lastLabelFrame.origin.y + defaultLabelHeight + 3];
            }
        }
        
        CGRect newLabelFrame = CGRectMake(lastLabelRightEdge,lastLabelFrame.origin.y, textSize.width + 2, defaultLabelHeight);
        
        UILabel *newLabel = [[UILabel alloc] initWithFrame:newLabelFrame];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.text = newWord;
        newLabel.textAlignment = UITextAlignmentLeft;
        [newLabel setFont:font];
        [newLabel setTextColor:color];
        [self addSubview:newLabel];
        [labelArray addObject:newLabel];
        
        if (!shouldKeepAdding) {
            return;
        }
    }
}

- (void)clean{
    
    for (UILabel *label in labelArray) {
        [label removeFromSuperview];
    }
    [labelArray removeAllObjects];
    [self setHeight:defaultLabelHeight];
    [self setNeedsDisplay];
}

@end
