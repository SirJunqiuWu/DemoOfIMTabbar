//
//  IMRecordView.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMRecordView.h"

static CGFloat const RECORDVIEWH = 140.0;

@implementation IMRecordView
{
    UIImageView *animationImageIcon;
    UILabel     *titleLbl;
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
    //背景
    UIView *bgView             = [[UIView alloc] initWithFrame:CGRectMake((AppWidth-RECORDVIEWH)/2,(AppHeight-64-RECORDVIEWH)/2, RECORDVIEWH, RECORDVIEWH)];
    bgView.backgroundColor     = [UIColor grayColor];
    bgView.layer.cornerRadius  = 5;
    bgView.layer.masksToBounds = YES;
    bgView.alpha               = 0.6;
    [self addSubview:bgView];
    
    //变化的声音图片
    animationImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10,0,bgView.width-20,bgView.width-20)];
    animationImageIcon.backgroundColor = [UIColor clearColor];
    animationImageIcon.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
    [bgView addSubview:animationImageIcon];
    
    //动态标题
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10,bgView.height-20-13,bgView.width-20,25)];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont systemFontOfSize:13];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.layer.cornerRadius = 5;
    titleLbl.layer.masksToBounds=YES;
    titleLbl.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
    titleLbl.text = @"手指上滑,取消发送";
    [bgView addSubview:titleLbl];
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLbl.text = title;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    titleLbl.backgroundColor = color;
}

#pragma mark - 对外方法

- (void)showInView:(UIView *)view {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.8;
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
        [view addSubview:self];
    }];
}

- (void)cancel {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.alpha = 0.0;
        [self removeFromSuperview];
    }];
}



@end
