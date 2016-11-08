//
//  IMRecordView.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 IM交互底部录音时呈现的视图
 */
@interface IMRecordView : UIView

//标题
@property(nonatomic,strong)NSString *title;
//背景色
@property(nonatomic,strong)UIColor  *color;


/**
 显示在目标视图上

 @param view 目标视图
 */
- (void)showInView:(UIView *)view;


/**
 取消显示
 */
- (void)cancel;

@end
