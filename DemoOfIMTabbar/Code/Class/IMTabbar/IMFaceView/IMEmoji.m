//
//  IMEmoji.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMEmoji.h"

@implementation IMEmoji

+ (NSMutableArray<IMEmoji *> *)initWithArray:(NSArray *)array emojiStyle:(IMFaceStyle)emojiStyle {
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IMEmoji *tempEmiji = [IMEmoji new];
        if (emojiStyle == IMFaceDefault)
        {
            tempEmiji.gifEmojiDic = nil;
            tempEmiji.pngEmojiDic = nil;
            if ([obj isKindOfClass:[NSString class]])
            {
                tempEmiji.emojiName   = (NSString *)obj;
            }
            else
            {
                NSAssert(@"", nil);
            }
        }
        else if (emojiStyle == IMFacePNG)
        {
            tempEmiji.gifEmojiDic = nil;
            if ([obj isKindOfClass:[NSString class]])
            {
                tempEmiji.emojiName = (NSString *)obj;
            }
            else if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)obj;
                tempEmiji.pngEmojiDic = dic;
            }
            else
            {
                NSAssert(@"",nil);
            }
        }
        else if (emojiStyle == IMFaceGif)
        {
            tempEmiji.pngEmojiDic = nil;
            if ([obj isKindOfClass:[NSString class]])
            {
                tempEmiji.emojiName = (NSString *)obj;
            }
            else if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)obj;
                tempEmiji.gifEmojiDic = dic;
            }
            else
            {
                NSAssert(@"",nil);
            }
        }
        else
        {
            NSAssert(@"", nil);
        }
        tempEmiji.deleteBackward = [tempEmiji.emojiName isEqualToString:kDeleteType];
        [resultArr addObject:tempEmiji];
    }];
    return resultArr;
}


@end
