//
//  IMFaceViewCollectionCell.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFaceViewConfig.h"
#import "IMEmoji.h"


@interface IMFaceViewCollectionCell : UICollectionViewCell
{
    NSInteger tempPage;
    NSArray *dataArray;
}


/**
 选中某个表情block
 */
@property(nonatomic,copy)void(^selecteEmojiResult)(BOOL isDelete,NSString *emojiName);


/**
 数据源

 @param currentPage 当前表情所在的页码数
 @param emojiArr    当前页面所有的表情数组
 */
- (void)initCellWithCurrentPage:(NSInteger)currentPage EmojiArr:(NSArray *)emojiArr;

@end
