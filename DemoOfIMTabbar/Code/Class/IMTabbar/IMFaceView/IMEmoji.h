//
//  IMEmoji.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMFaceViewConfig.h"

/**
 表情model
 */
@interface IMEmoji : NSObject

/**
 是否是删除标记 YES,是;反之不是
 */
@property (nonatomic,assign) BOOL         deleteBackward;

/**
 表情名字
 */
@property (nonatomic,strong) NSString     *emojiName;

/**
 png图片字典(key,编码，value，图片名称)
 */
@property (nonatomic,strong) NSDictionary *pngEmojiDic;

/**
 gif图片字典(key,编码，value，图片名称)
 */
@property (nonatomic,strong) NSDictionary *gifEmojiDic;



/**
 对外方法:将表情字典转化为IMEmoji对象
 
 @param array      某页的所有表情数组
 @param emojiStyle 表情类型
 
 @return 转化为表情model后的当页表情数组
 */
+ (NSMutableArray<IMEmoji *> *)initWithArray:(NSArray *)array emojiStyle:(IMFaceStyle)emojiStyle;

@end
