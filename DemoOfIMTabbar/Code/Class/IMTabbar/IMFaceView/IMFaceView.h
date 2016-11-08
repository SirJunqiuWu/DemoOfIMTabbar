//
//  IMFaceView.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFaceViewCollectionCell.h"

@protocol IMFaceViewDelegate;
/**
 IM交互底部表情所在视图
 */
@interface IMFaceView : UIView

/**
 当前添加的表情类型
 */
@property (nonatomic,assign)IMFaceStyle tempFaceStyle;

@property(nonatomic,assign)id<IMFaceViewDelegate>delegate;

/**
 获取表情所在视图高度

 @return 表情所在视图高度
 */
+(CGFloat)getFaceViewHeight;

@end

@protocol IMFaceViewDelegate <NSObject>

@optional


/**
 表情面板选中某个表情或者删除符号

 @param faceView  自身
 @param emojiName 表情符号对应的名称
 @param isDelete  YES,是删除符号;反之不是
 */
- (void)emojiKeyboard:(IMFaceView *)faceView didSelectEmoji:(NSString *)emojiName IsDelete:(BOOL)isDelete;

@end
