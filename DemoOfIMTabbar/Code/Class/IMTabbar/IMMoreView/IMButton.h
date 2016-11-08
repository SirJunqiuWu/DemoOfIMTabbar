//
//  IMButton.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/4.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>

//功能按钮宽高
static CGFloat const FUNCTIONBTNW = 60.0;

@interface IMButton : UIView

/**
 按钮图片
 */
@property(nonatomic,strong)UIImage  *image;

/**
 按钮标题
 */
@property(nonatomic,strong)NSString *title;


/**
 按钮点击回调
 */
@property(nonatomic,copy)void(^touchResult)(NSString *title);

+ (CGFloat)getHeight;

@end
