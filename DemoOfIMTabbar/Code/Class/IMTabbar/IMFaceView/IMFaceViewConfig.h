//
//  IMFaceViewConfig.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#ifndef IMFaceViewConfig_h
#define IMFaceViewConfig_h

/**
 宽高比
 */
#define kEmojiKeyboardRate   (375.f / 150.0f)


/**
 每行emoji个数
 */
#define emojiRowCount         8

/**
 每列emoji个数
 */
#define emojiLineCount        4

/**
 表示删除
 */
#define kDeleteType           @"deleteBackward"

/**
 表示空白
 */
#define kSpaceNullType        @""

/**
 Tag
 */
#define kEmojiButton_TAG      555555555

/**
 表情类型
 
 - IMFaceDefault: 系统默认表情
 - IMFacePNG:     png图片
 - IMFaceGif:     gif图片
 */
typedef NS_ENUM(NSInteger,IMFaceStyle)
{
    IMFaceDefault = 0,
    IMFacePNG,
    IMFaceGif
};


#endif /* IMFaceViewConfig_h */
