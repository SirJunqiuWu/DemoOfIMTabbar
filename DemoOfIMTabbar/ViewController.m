//
//  ViewController.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/2.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "ViewController.h"
#import "IMTabbar.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,IMTabbarDelegate>
{
    UITableView *infoTable;
    IMTabbar    *myTabber;
}

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"IM交互";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建UI

- (void)setupUI {
    /**
     * 消息列表
     */
    infoTable = [[UITableView alloc]initWithFrame:AppFrame(0,64,AppWidth,self.view.height-64-50) style:UITableViewStylePlain];
    infoTable.backgroundColor = [UIColor clearColor];
    infoTable.dataSource      = self;
    infoTable.delegate        = self;
    [self.view addSubview:infoTable];
    
    /**
     * 底部IM-UI组件视图
     */
    myTabber = [[IMTabbar alloc]initWithFrame:AppFrame(0,AppHeight-50,AppWidth, 50)];
    myTabber.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    myTabber.backgroundColor = [UIColor whiteColor];
    myTabber.delegate = self;
    [self.view addSubview:myTabber];
    
    /**
     * 退出键盘手势
     */
    UITapGestureRecognizer *hideKeyboardGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyBoardHidden:)];
    [infoTable addGestureRecognizer:hideKeyboardGes];
}

#pragma mark ------------------ UIGestureRecognizer --------------

- (void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [myTabber endEditing:YES];
    }
}

#pragma mark ------------------ UITableViewDataSource && Delegate --------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
}


#pragma mark - IMTabbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect      = infoTable.frame;
        rect.origin.y    = 64;
        rect.size.height = self.view.height-64 - toHeight;
        infoTable.frame  = rect;
    }];
    //在此将列表滚动到底部
    [self _scrollViewToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(YYTextView *)inputTextView {
    
}

- (void)inputTextViewDidBeginEditing:(YYTextView *)inputTextView {
    
}

- (void)didSendText:(NSString *)text {
    NSLog(@"发送的文本消息 %@",text);
}

- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location {
    NSLog(@"当前删除字符的位置 %lu",location);
    //后面会完善好 等待
    return NO;
}

- (void)moreViewFunctionBtnPressedWithTitle:(NSString *)title {
    if ([title isEqualToString:@"拍摄照片"])
    {
        
    }
    else if ([title isEqualToString:@"相册照片"])
    {
        
    }
    else
    {
        
    }
    NSLog(@"click %@",title);
}

#pragma mark - 自定义方法

/**
 根据标记值将消息列表滚动到最底部

 @param animated YES,带动画;反之无
 */
- (void)_scrollViewToBottom:(BOOL)animated {
    if (infoTable.contentSize.height > infoTable.frame.size.height)
    {
        CGPoint offset = CGPointMake(0,infoTable.contentSize.height - infoTable.frame.size.height);
        [infoTable setContentOffset:offset animated:animated];
    }
}

#pragma mark - NSNotification

- (void)dealloc {
}

@end
