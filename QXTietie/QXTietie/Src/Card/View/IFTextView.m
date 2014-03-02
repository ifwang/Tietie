//
//  IFTextView.m
//  QXTietie
//
//  Created by ifwang on 14-3-2.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFTextView.h"

@interface IFTextView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeHolder;

@end

@implementation IFTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textView = [[UITextView alloc] initWithFrame:self.bounds];
        _textView.delegate = self;
        _textView.font = [UIFont flatFontOfSize:16];
        _textView.textColor = HEXCOLOR(0x272727);
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_textView];
        
        self.placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 300, 16)];
        _placeHolder.font = [UIFont flatFontOfSize:14];
        _placeHolder.textColor = HEXCOLOR(0x000000);
        _placeHolder.alpha = 0.4;
        _placeHolder.text = @"在这里输入祝福寄语……";
        [_textView addSubview:_placeHolder];
        
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0)
    {
        _placeHolder.hidden = NO;
    }
    else
    {
        _placeHolder.hidden = YES;
    }
}

- (void)hideKeyBoard
{
    [_textView resignFirstResponder];
}

- (void)setText:(NSString*)text
{
    [_textView setText:text];
}

- (void)setPlaceHolderText:(NSString*)text
{
    [_placeHolder setText:text];
}
- (NSString*)text
{
    return _textView.text;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
