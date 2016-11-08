//
//  IMInputTextParser.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMInputTextParser : NSObject<YYTextParser>

@property (nonatomic, strong) NSRegularExpression *regexImageBinding;
@property (copy) NSDictionary *emoticonMapper;
@property (nonatomic, strong) id attachmentTarget;
@property (nonatomic, assign) SEL attachmentAction;

- (void)addImageMapper:(NSDictionary *)mapper;

@end
