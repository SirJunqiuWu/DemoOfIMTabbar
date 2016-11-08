//
//  IMMoreView.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMMoreView.h"
#import "IMButton.h"

/**
 宽高比
 */
#define kEmojiKeyboardRate   (375.f / 150.0f)

@interface IMMoreView ()

@end

@implementation IMMoreView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    NSArray *imageArr = @[@"CameraInput",@"PhotoInput"];
    NSArray *titleArr = @[@"拍摄照片",@"相册照片"];
    [imageArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IMButton *tempBtn = [[IMButton alloc]initWithFrame:CGRectMake(15*(idx+1)+FUNCTIONBTNW*idx,15,FUNCTIONBTNW, [IMButton getHeight])];
        tempBtn.tag       = 1000+idx;
        tempBtn.image     = [UIImage imageNamed:imageArr[idx]];
        tempBtn.title     = titleArr[idx];
        //注意:按钮点击回调
        tempBtn.touchResult=^(NSString *title)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(functionBtnPressedWithTitle:)])
            {
                [_delegate functionBtnPressedWithTitle:title];
            }
        };
        [self addSubview:tempBtn];
    }];
}

#pragma mark - 获取高度

+(CGFloat)getMoreViewHeight {
    return 5 +AppWidth/kEmojiKeyboardRate+7.5+20+40;
}

@end
