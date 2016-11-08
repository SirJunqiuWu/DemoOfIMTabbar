//
//  IMFaceView.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMFaceView.h"

static NSString *const emojicellID       = @"IMFaceViewCollectionCell";



@interface IMFaceView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation IMFaceView
{
    UICollectionView *emojiCollection;
    UIPageControl    *pageControl;
    UIButton         *sendButton;
    
    //表情数据原始字典
    NSDictionary     *emojiDic;
    
    //所有页的表情数组。其元素为数组，每个数组元素里面存放的是表情对象。它的元素个数为表情的页码数
    NSMutableArray   *dataArray;
    //沙盒路径(当前构造的表情存储再本地沙盒文件。可根据需要灵活变动)
    NSString         *plistPath;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize                    = CGSizeMake(kScreenWidth, kScreenWidth / kEmojiKeyboardRate);
    layout.minimumLineSpacing          = 0;
    layout.minimumInteritemSpacing     = 0;
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    
    CGFloat emojiCollectionH           = self.width/kEmojiKeyboardRate;
    emojiCollection                    = [[UICollectionView alloc]initWithFrame:AppFrame(0,5,self.width,emojiCollectionH) collectionViewLayout:layout];
    emojiCollection.backgroundColor    = [UIColor clearColor];
    emojiCollection.scrollsToTop       = NO;
    emojiCollection.delegate           = self;
    emojiCollection.dataSource         = self;
    emojiCollection.pagingEnabled      = YES;
    emojiCollection.bounces            = NO;
    emojiCollection.showsHorizontalScrollIndicator = NO;
    [emojiCollection registerClass:[IMFaceViewCollectionCell class] forCellWithReuseIdentifier:emojicellID];
    [self addSubview:emojiCollection];
    
    pageControl                        = [[UIPageControl alloc]initWithFrame:AppFrame(0,5+emojiCollectionH+7.5,kScreenWidth, 20)];
    pageControl.pageIndicatorTintColor = CD_LineColor;
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:pageControl];
}

- (void)setTempFaceStyle:(IMFaceStyle )tempFaceStyle {
    _tempFaceStyle = tempFaceStyle;
    [self dealDataWithFaceStyle];
    [self uploadUI];
}

#pragma mark - 数据源

- (void)dealDataWithFaceStyle {
    if (_tempFaceStyle == IMFaceDefault)
    {
        
    }
    else if (_tempFaceStyle == IMFacePNG)
    {
        plistPath = @"EmojisImageTextList";
    }
    else if (_tempFaceStyle == IMFaceGif)
    {
        
    }
    else
    {
        
    }
    //获取表情最原始数据字典
    NSString     *filePath = [[NSBundle mainBundle]pathForResource:plistPath ofType:@"plist"];
    NSDictionary *dataDic  = [NSDictionary dictionaryWithContentsOfFile:filePath];
    emojiDic               = [NSDictionary dictionaryWithDictionary:dataDic];
    
    //获取分页表情数组
    NSArray *allEmojiArr = [emojiDic getArrayValueForKey:@"emoji"];
    dataArray            = [NSMutableArray array];
    [dataArray addObjectsFromArray:[self caluateEmojiWithAllEmojiArr:allEmojiArr]];
    
    pageControl.numberOfPages = dataArray.count;
}

- (void)uploadUI {
    //界面刷新
    [emojiCollection reloadData];
}

- (NSMutableArray *)caluateEmojiWithAllEmojiArr:(NSArray *)array {
    //dataArr里面元素为数组,每个数组元素为某页的所有表情,数组元素里面的对象都是YKEmoji,后面又填充的空字符和删除字符(要注意)
    NSMutableArray *dataArr = [NSMutableArray array];

    //每页显示表情最大个数(每页最后一个都是删除字符)
    int maxCount = (emojiRowCount * emojiLineCount - 1);
    //当前所有表情能显示的页码数
    int pageCount = ((int)(array.count - 1) / maxCount + 1);
    //所有表情个数
    int emojiCount = (int)array.count;
    NSMutableArray *pArray = [NSMutableArray array];
    for (int j = 0;j < array.count;j++)
    {
        //每页的最大个数emojiRowCount * emojiLineCount = 32；
        //每页的最后一个为删除符号
        
        //算出当前表情所在的行列
        int a = j / maxCount;
        int b = j % maxCount;
        
        [pArray addObject:[array objectAtIndex:j]];
        
        //删除字符增加的个数和页码数对应
        if (a < pageCount - 1)
        {
            if (b == maxCount - 1)
            {
                //每页的最后一个放删除字符
                [pArray addObject:kDeleteType];
                //将当页的所有表情所在的数组放到容器
                [dataArr addObject:[IMEmoji initWithArray:pArray emojiStyle:_tempFaceStyle]];
                //注意:重新初始化数组
                pArray = [NSMutableArray array];
            }
        }
        else if(a == pageCount - 1)
        {
            //表示最后一页
            //最后一页剩余的表情个数
            int currentPageItemMaxCount = emojiCount - a * maxCount;
            if (b == currentPageItemMaxCount - 1)
            {
                //最后一页的最后一个表情后紧随删除字符,
                [pArray addObject:kDeleteType];
                //后面剩余的全部补充空字符
                for (int k = 0; k < maxCount - currentPageItemMaxCount;k ++)
                {
                    [pArray addObject:kSpaceNullType];
                }
                [dataArr addObject:[IMEmoji initWithArray:pArray emojiStyle:_tempFaceStyle]];
                pArray = [NSMutableArray array];
            }
        }
        else
        {
            NSAssert(@"", nil);
        }
    }
    return dataArr;

}

#pragma mark - UIColelctionViewDataSource && Delegete

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMFaceViewCollectionCell *cell = (IMFaceViewCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:emojicellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //cell赋值
    if (indexPath.row >=dataArray.count)
    {
        return;
    }
    NSArray *emojiArr = dataArray[indexPath.row];
    [((IMFaceViewCollectionCell *)cell)initCellWithCurrentPage:indexPath.row EmojiArr:emojiArr];
    
    //表情面板上选中某个表情或者是删除符号
    [((IMFaceViewCollectionCell *)cell)setSelecteEmojiResult:^(BOOL isDelete,NSString *emojiName) {
        if (_delegate && [_delegate respondsToSelector:@selector(emojiKeyboard:didSelectEmoji:IsDelete:)])
        {
            [_delegate emojiKeyboard:self didSelectEmoji:emojiName IsDelete:isDelete];
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    pageControl.currentPage = (int)scrollView.contentOffset.x / kScreenWidth;
}

#pragma mark - 获取高度

+(CGFloat)getFaceViewHeight {
  return 5 +AppWidth/kEmojiKeyboardRate+7.5+20+40;
}

@end
