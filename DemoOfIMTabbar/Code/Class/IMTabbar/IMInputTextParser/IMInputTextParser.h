//
//  IMInputTextParser.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 文本解析类(YYTextView需要用到,其关键在匹配到自定义key-vaule的图片)
 */
@interface IMInputTextParser : NSObject<YYTextParser>

/**
 正则表达式匹配unicode字符
 */
@property (nonatomic, strong) NSRegularExpression *regexImageBinding;
@property (copy) NSDictionary *emoticonMapper;
@property (nonatomic, strong) id attachmentTarget;
@property (nonatomic, assign) SEL attachmentAction;

- (void)addImageMapper:(NSDictionary *)mapper;

@end
