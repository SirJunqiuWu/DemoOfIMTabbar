//
//  IMButton.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/4.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMButton.h"

@implementation IMButton
{
    UILabel *titleLbl;
    UIButton*functionBtn;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    functionBtn.frame = CGRectMake(0, 0, FUNCTIONBTNW, FUNCTIONBTNW);
    [functionBtn addTarget:self action:@selector(functionBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:functionBtn];
    
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0,functionBtn.originY+functionBtn.size.height+5.0,functionBtn.size.width,12)];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLbl];
}

#pragma mark - Setter && Getter

- (void)setImage:(UIImage *)image {
    _image = image;
    [functionBtn setImage:_image forState:UIControlStateNormal];
    [functionBtn setImage:_image forState:UIControlStateHighlighted];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLbl.text = _title;
}

#pragma mark - 按钮点击事件

- (void)functionBtnPressed {
    if (_touchResult)
    {
        _touchResult(_title);
    }
}

#pragma mark - 获取高度

+ (CGFloat)getHeight {
    CGFloat totalH = FUNCTIONBTNW+5.0+12.0;
    return totalH;
}

@end
