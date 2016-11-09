//
//  NSMutableAttributedString+Utils.h
//  TemplateTest
//
//  Created by JackWu on 16/1/21.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMImageView.h"

/**
 富文本扩展类
 */
@interface NSMutableAttributedString (Utils)

+ (NSMutableAttributedString *)attachmentStringWithImageUrl:(NSString *)imageUrl imageSize:(CGSize)size;
+ (NSMutableAttributedString *)attachmentStringWithImage:(IMEditImage *)image imageSize:(CGSize)size gestureTarget:(id)target action:(SEL)action;
+ (NSMutableAttributedString *)attachmentStringWithCode:(NSString *)content size:(CGSize)size;

@end
