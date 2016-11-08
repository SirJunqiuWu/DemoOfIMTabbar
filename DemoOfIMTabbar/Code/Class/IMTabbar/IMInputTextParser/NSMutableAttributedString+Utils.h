//
//  NSMutableAttributedString+Utils.h
//  TemplateTest
//
//  Created by caijingpeng on 16/1/21.
//  Copyright © 2016年 caijingpeng.haowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMImageView.h"

@interface NSMutableAttributedString (Utils)

+ (NSMutableAttributedString *)attachmentStringWithImageUrl:(NSString *)imageUrl imageSize:(CGSize)size;
+ (NSMutableAttributedString *)attachmentStringWithImage:(IMEditImage *)image imageSize:(CGSize)size gestureTarget:(id)target action:(SEL)action;
+ (NSMutableAttributedString *)attachmentStringWithCode:(NSString *)content size:(CGSize)size;

@end
