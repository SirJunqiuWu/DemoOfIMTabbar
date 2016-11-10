//
//  ViewController.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/2.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "ViewController.h"
#import "GroupMemberControlle.h"
#import "IMTabbar.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,IMTabbarDelegate,GroupMemberControlleDelegate>
{
    UITableView *infoTable;
    IMTabbar    *myTabber;
    
    //标记@who的数组，在文本编辑中动态增减
    NSMutableArray *atWhoArr;
}

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"IM交互";
        atWhoArr   = [NSMutableArray array];
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
    
    NSMutableString *atWhoID = [NSMutableString string];
    
    //遍历文本输入框的富文本组成,获取最终@的对象
    [myTabber.inputTextView.attributedText enumerateAttributesInRange:myTabber.inputTextView.attributedText.rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        YYTextBinding *textBinding = [attrs objectForKey:YYTextBindingAttributeName];
        if (textBinding)
        {
            //当前某个部分的富文本所含的字符
            NSString *tempText = [myTabber.inputTextView.attributedText attributedSubstringFromRange:range].string;
            if ([atWhoArr containsObject:tempText])
            {
                [atWhoID appendString:tempText];
                [atWhoID appendString:@","];
            }
        }
    }];
    NSLog(@"当前@了 %@",atWhoID);
    //消息发送结束,清空数组
    [atWhoArr removeAllObjects];
}

- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location {
    NSLog(@"当前删除字符的位置 %lu",location);
    //这里最怕删除的是@who中的字符,这样在发送消息的时候需要确定哪些不被@
    return NO;
}

- (void)didSelectAtCharacter {
    NSLog(@"当前输入@字符");
    GroupMemberControlle *vc = [[GroupMemberControlle alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - GroupMemberControlleDelegate

- (void)selectedUserWithUserName:(NSString *)userName {
    if (userName.length == 0)
    {
        return;
    }
    NSString *atWhoString = [userName stringByAppendingString:@" "];
    [myTabber.inputTextView insertText:atWhoString];
    
    //添加到容器 eg:@["@who "]
    NSString *storeString = [NSString stringWithFormat:@"@%@",userName];
    [atWhoArr addObject:storeString];
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
