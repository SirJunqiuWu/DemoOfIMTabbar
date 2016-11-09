//
//  IMTabbar.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/2.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFaceView.h"
#import "IMRecordView.h"
#import "IMMoreView.h"

@protocol IMTabbarDelegate;
@interface IMTabbar : UIView<YYTextViewDelegate,IMFaceViewDelegate>

#pragma mark - 对外对象

/**
 输入框等控件所在的视图(存在的意义:作为中间高度转化变量)
 */
@property(nonatomic,strong)UIView     *tabbarView;

/**
 输入框
 */
@property(nonatomic,strong)YYTextView *inputTextView;


/**
 表情视图
 */
@property(nonatomic,strong)IMFaceView *faceView;

/**
 录音视图
 */
@property(nonatomic,strong)IMRecordView *recordView;

/**
 更多功能按钮所在视图(加号按钮点击显示)
 */
@property(nonatomic,strong)IMMoreView *moreView;

/**
 标记底部正在显示的视图(切换底部显示视图时用到)
 */
@property(strong, nonatomic)UIView *activityBottomView;

@property(nonatomic,assign)id<IMTabbarDelegate>delegate;

#pragma mark - 对外方法

/**
 获取默认状态下的输入框所在视图高度

 @return 默认状态下的输入框所在视图高度
 */
+(CGFloat)getTabbarHeight;

@end

@protocol IMTabbarDelegate <NSObject>

@optional

#pragma mark - 文本框操作
/**
 当前输入框将要开始进行编辑

 @param inputTextView YYTextView
 */
- (void)inputTextViewWillBeginEditing:(YYTextView *)inputTextView;


/**
 当前输入框开始进行编辑

 @param inputTextView YYTextView
 */
- (void)inputTextViewDidBeginEditing:(YYTextView *)inputTextView;


/**
 发送当前输入的文本

 @param text 当前文本框输入的文本
 */
- (void)didSendText:(NSString *)text;


/**
 键盘执行删除字符

 @param location 删除字符的位置
 @return 是否能删除字符
 */
- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location;


/**
 当前选中的是系统键盘上的@字符
 */
- (void)didSelectAtCharacter;


#pragma mark - 功能按钮视图操作
/**
 IMMoreView上当前点击的功能按钮

 @param title IMMoreView上点击的功能按钮标题
 */
- (void)moreViewFunctionBtnPressedWithTitle:(NSString *)title;


@required

/**
 IMTabbar将要变化的目标高度,告知顶层,变换消息列表位置

 @param toHeight IMTabbar变化的目标高度
 */
- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight;

@end


