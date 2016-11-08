//
//  IMMoreView.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMMoreViewDelegate;

/**
 IM交互底部+号按钮点击的功能按钮所在视图
 */
@interface IMMoreView : UIView

@property(nonatomic,assign)id<IMMoreViewDelegate>delegate;

/**
 获取功能按钮所在视图高度
 
 @return 功能按钮所在视图高度
 */
+(CGFloat)getMoreViewHeight;

@end

@protocol IMMoreViewDelegate <NSObject>

@optional


/**
 功能按钮点击事件
 
 @param title 当前功能按钮的标题
 */
- (void)functionBtnPressedWithTitle:(NSString *)title;

@end
