//
//  CSABContactCell.m
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

#import "CSABContactCell.h"

@interface CSABContactCell ()

@property (nonatomic, strong) UIImageView *checkImageView;

@end

@implementation CSABContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.checked = NO;
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *image = (self.checked) ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
        
        _checkImageView = [[UIImageView alloc] initWithImage:image];
        [_checkImageView setXOrigin:6.];
        [_checkImageView setYCentre:24.];
        [_checkImageView setUserInteractionEnabled:YES];
        [self addSubview:_checkImageView];
        
        _nameLabel = [[ULBoldLabel alloc] initWithFrame:CGRectMake([_checkImageView rightEdge]+10, 6., 240., 22.)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFontSize:20.];
        [self addSubview:_nameLabel];
        
        _contactLabel = [[UILabel alloc] initWithFrame:CGRectMake([_checkImageView rightEdge] + 10, [_nameLabel bottomOrigin]-2, 200., 22.)];
        [_contactLabel setBackgroundColor:[UIColor clearColor]];
        [_contactLabel setFont:[UIFont systemFontOfSize:13.]];
        [_contactLabel setTextColor:[UIColor colorWithHexString:@"acacac"]];
        [self addSubview:_contactLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    if (self.checked) {
        [_checkImageView setImage:[UIImage imageNamed:@"checked.png"]];
    }
    else{
        [_checkImageView setImage:[UIImage imageNamed:@"unchecked.png"]];
    }
}

- (void)didPressed{
    self.checked = !self.checked;
    
    if (self.checked) {
        self.backgroundColor = [UIColor colorWithHexString:@"e9f0fa"];
    }
    else{
        self.backgroundColor = [UIColor whiteColor];
    }
    [self setNeedsDisplay];
}

@end
