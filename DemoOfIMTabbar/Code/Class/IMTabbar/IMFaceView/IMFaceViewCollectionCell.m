//
//  IMFaceViewCollectionCell.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMFaceViewCollectionCell.h"

@implementation IMFaceViewCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - 初始化

- (void)initCellWithCurrentPage:(NSInteger)currentPage EmojiArr:(NSArray *)emojiArr {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    tempPage = currentPage;
    dataArray= [NSArray arrayWithArray:emojiArr];
    
    //根据数据源,创建表情按钮
    for (int i = 0; i < dataArray.count; i++)
    {
        CGFloat width                   = kScreenWidth / emojiRowCount;
        CGFloat height                  = kScreenWidth / kEmojiKeyboardRate / emojiLineCount;
        
        UIButton *emojiView             = [UIButton buttonWithType:UIButtonTypeCustom];
        emojiView.frame                 = CGRectMake((i % emojiRowCount) * width, (i / emojiRowCount) * height, width, height);
        emojiView.titleLabel.font       = [UIFont systemFontOfSize:30];
        emojiView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        emojiView.tag = kEmojiButton_TAG * tempPage + i;
        [self addSubview:emojiView];
        
        NSString *title;
        NSString *image;
        
        IMEmoji *tempEmoji = [dataArray objectAtIndex:i];
        SEL touchUpIn = @selector(didSelectEmojiItem:);
        UILongPressGestureRecognizer *longPress = nil;
        
        //可以控制显示名字
        if ([tempEmoji.emojiName isEqualToString:kDeleteType])
        {
            //删除字符
            title = nil;
            image = tempEmoji.emojiName;
            longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongTouchDownDeleteItem:)];
        }
        else if ([tempEmoji.emojiName isEqualToString:kSpaceNullType])
        {
            //NULL 空白填充
            title = nil;
            image = nil;
        }
        else
        {
            title = tempEmoji.emojiName;
            image = nil;
        }
        if ([tempEmoji.pngEmojiDic allKeys] > 0)
        {
            title = nil;
            //取出表情图片名
            image = [[tempEmoji.pngEmojiDic allValues] objectAtIndex:0];
            emojiView.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        }
        if ([tempEmoji.gifEmojiDic allKeys] > 0)
        {
            title = nil;
            image = [[tempEmoji.gifEmojiDic allValues] objectAtIndex:0];
            emojiView.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        }
        [emojiView setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [emojiView setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
        [emojiView setTitle:title forState:UIControlStateNormal];
        [emojiView setTitle:title forState:UIControlStateHighlighted];
        if (touchUpIn)
        {
            [emojiView addTarget:self action:touchUpIn forControlEvents:UIControlEventTouchUpInside];
        }
        if (longPress)
        {
            [emojiView addGestureRecognizer:longPress];
        }
    }
}

#pragma mark - 按钮点击事件

- (void)didSelectEmojiItem:(UIButton *)sender {
    NSInteger index = sender.tag%kEmojiButton_TAG;
    if (index >=dataArray.count)
    {
        return;
    }
    IMEmoji *emoji  = [dataArray objectAtIndex:index];
    NSString *emojiText;
    
    if ([emoji.emojiName isEqualToString:kSpaceNullType])
    {
        //空白填充的不继续
        return;
    }
    if ([emoji.pngEmojiDic allKeys] > 0)
    {
        //取出表情符号对应的文本信息
        emojiText = [[emoji.pngEmojiDic allKeys] objectAtIndex:0];
    }
    else if ([emoji.gifEmojiDic allKeys] > 0)
    {
        emojiText = [[emoji.gifEmojiDic allKeys] objectAtIndex:0];
    }
    else
    {
        emojiText = emoji.emojiName;
    }
    
    if (_selecteEmojiResult)
    {
        _selecteEmojiResult(emoji.deleteBackward,emojiText);
    }
}

#pragma mark - 手势

- (void)didLongTouchDownDeleteItem:(UILongPressGestureRecognizer *)ges {
    
}

@end
