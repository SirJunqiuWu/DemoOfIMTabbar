//
//  IMTabbar.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/2.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMTabbar.h"
#import "IMInputTextParser.h"

//icon之间的间距10px
static NSInteger const IconGap = 10;
//文本输入框最小高度
static CGFloat   const InputViewMinHeight = 36.0;
//文本输入框最大高度
static CGFloat   const InputViewMaxHeight = 150.0;

@interface IMTabbar ()<IMMoreViewDelegate>

@end

@implementation IMTabbar
{
    UIButton *audioIconBtn;
    UIButton *addIconBtn;
    UIButton *emojiIconBtn;
    UIButton *recordBtn;
    /**
     是否显示底部展示的视图
     */
    BOOL      isShowButtomView;
    /*
     * 标记上一次inputTextView的contentSize.height
     */
    CGFloat  previousTextViewContentHeight;
}
@synthesize inputTextView,tabbarView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 创建UI

- (void)setupUI {
    tabbarView = [[UIView alloc] initWithFrame:AppFrame(0, 0, self.frame.size.width, self.frame.size.height)];
    tabbarView.backgroundColor = [UIColor clearColor];
    [self addSubview:tabbarView];
    
    //语音切换按钮 selected=YES为切换到录音;反之默认文本输入
    audioIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    audioIconBtn.frame = AppFrame(15, tabbarView.frame.size.height-10-30, 30, 30);
    [audioIconBtn setImage:[UIImage imageNamed:@"AudioInput"] forState:UIControlStateNormal];
    [audioIconBtn setImage:[UIImage imageNamed:@"KeyboardInput"] forState:UIControlStateSelected];
    [audioIconBtn addTarget:self action:@selector(audioIconBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    audioIconBtn.selected = NO;
    [tabbarView addSubview:audioIconBtn];
    
    //加号按钮 selected=YES为切换到显示功能按钮视图;反之默认文本输入
    addIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addIconBtn.frame = AppFrame(AppWidth-15-30, tabbarView.frame.size.height-10-30, 30, 30);
    [addIconBtn setImage:[UIImage imageNamed:@"AddInput"] forState:UIControlStateNormal];
    [addIconBtn addTarget:self action:@selector(addIconBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    addIconBtn.selected = NO;
    [tabbarView addSubview:addIconBtn];
    
    //表情按钮 selected=YES为切换到显示表情视图;反之默认文本输入
    emojiIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiIconBtn.frame = AppFrame(addIconBtn.left-IconGap-30,tabbarView.frame.size.height-10-30, 30, 30);
    [emojiIconBtn setImage:[UIImage imageNamed:@"EmojiInput"] forState:UIControlStateNormal];
    [emojiIconBtn setImage:[UIImage imageNamed:@"KeyboardInput"] forState:UIControlStateSelected];
    [emojiIconBtn addTarget:self action:@selector(emojiIconBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    emojiIconBtn.selected = NO;
    [tabbarView addSubview:emojiIconBtn];
    
    //文本输入框
    inputTextView                    = [[YYTextView alloc]init];
    inputTextView.layer.cornerRadius = AppUICornerRadius;
    inputTextView.frame              = AppFrame(audioIconBtn.right+10,7,emojiIconBtn.left-IconGap-audioIconBtn.right-IconGap,tabbarView.frame.size.height-7*2);
    inputTextView.layer.borderColor  = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    inputTextView.layer.borderWidth  = AppLineHeight;
    inputTextView.font               = [UIFont systemFontOfSize:15];
    inputTextView.textColor          = [UIColor colorWithHexString:@"#333333"];
    inputTextView.textContainerInset = UIEdgeInsetsMake(9, 10, 9, 10);
    inputTextView.enablesReturnKeyAutomatically = YES;
    inputTextView.returnKeyType      = UIReturnKeySend;
    inputTextView.delegate           = self;
    
    //文本框默认下高度
    previousTextViewContentHeight    = [self getTextViewContentH:inputTextView];
    
    //解析器(很重要)
    IMInputTextParser *inputParser = [IMInputTextParser new];
    inputParser.emoticonMapper     = [IMTabbar emojiMapper];
    inputTextView.textParser       = inputParser;
    
    [tabbarView addSubview:inputTextView];
    
    //录音按钮 和文本输入框的显示刚好相反 其高度不变
    recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = AppFrame(audioIconBtn.right+10,7, inputTextView.width,tabbarView.frame.size.height-7*2);
    recordBtn.titleLabel.font = inputTextView.font;
    [recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [recordBtn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    recordBtn.layer.cornerRadius = AppUICornerRadius;
    recordBtn.layer.masksToBounds= YES;
    recordBtn.layer.borderColor  = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    recordBtn.layer.borderWidth  = AppLineHeight;
    recordBtn.hidden = YES;
    
    [recordBtn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [recordBtn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [recordBtn addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
    
    [self addSubview:recordBtn];
    
    [tabbarView drawTopLine];
    [tabbarView drawBottomLine];
    
    //系统键盘事件监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IMTabbarChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Getter && Setter

- (IMFaceView *)faceView {
    if (_faceView == nil)
    {
        CGFloat faceViewH = [IMFaceView getFaceViewHeight];
        _faceView = [[IMFaceView alloc]initWithFrame:AppFrame(0, 0,self.width, faceViewH)];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _faceView.tempFaceStyle    = IMFacePNG;
        _faceView.backgroundColor  = [UIColor clearColor];
        _faceView.delegate         = self;
    }
    return _faceView;
}


- (IMMoreView *)moreView {
    if (_moreView == nil)
    {
        CGFloat moreViewH = [IMMoreView getMoreViewHeight];
        _moreView = [[IMMoreView alloc]initWithFrame:AppFrame(0, 0,self.width, moreViewH)];
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _moreView.backgroundColor = [UIColor clearColor];
        _moreView.delegate = self;
    }
    return _moreView;
}

#pragma mark - 按钮点击事件 切换到语音  加号按钮  表情按钮 录音执行按钮

- (void)audioIconBtnPressed {
    audioIconBtn.selected = !audioIconBtn.selected;
    if (audioIconBtn.selected)
    {
        //显示录音触发按钮
        emojiIconBtn.selected = NO;
        addIconBtn.selected   = NO;
        
        [self willShowBottomView:nil];
        
        //将文本框恢复到原始高度
        inputTextView.text = @"";
        [self textViewDidChange:inputTextView];
        
        [inputTextView resignFirstResponder];
    }
    else
    {
        //不显示录音触发按钮,显示文本输入框
        [inputTextView becomeFirstResponder];
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        recordBtn.hidden     = !audioIconBtn.selected;
        inputTextView.hidden = audioIconBtn.selected;
    } completion:nil];
}

- (void)addIconBtnPressed {
    addIconBtn.selected = !addIconBtn.selected;
    if (addIconBtn.selected)
    {
        //显示功能按钮视图
        emojiIconBtn.selected = NO;
        audioIconBtn.selected = NO;
        
        [inputTextView resignFirstResponder];
        [self willShowBottomView:self.moreView];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            recordBtn.hidden     = YES;
            inputTextView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];

    }
    else
    {
        //默认文本视图
        [inputTextView becomeFirstResponder];
    }
}

- (void)emojiIconBtnPressed {
    emojiIconBtn.selected = !emojiIconBtn.selected;
    if (emojiIconBtn.selected)
    {
        //显示表情视图
        audioIconBtn.selected = NO;
        addIconBtn.selected   = NO;
        
        [inputTextView resignFirstResponder];
        [self willShowBottomView:self.faceView];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            recordBtn.hidden     = YES;
            inputTextView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        //默认文本视图
        [inputTextView becomeFirstResponder];
    }
}

#pragma mark - 开启语音按钮点击

- (void)recordButtonTouchDown {
    NSLog(@"开始录音");
    _recordView = [[IMRecordView alloc]initWithFrame:CGRectMake(0, 0,AppWidth,AppHeight)];
    [_recordView showInView:[UIApplication sharedApplication].delegate.window];
}

- (void)recordButtonTouchUpOutside {
    NSLog(@"取消录音,删除已经录制的音频文件");
    [_recordView cancel];
    //删除已经录制的音频文件
}

- (void)recordButtonTouchUpInside {
    NSLog(@"录音结束,发送音频文件");
    [_recordView cancel];
    //发送已经录制好的音频文件
}

- (void)recordDragOutside {
    NSLog(@"拖拽到外面:松开手指 取消发送");
    _recordView.title = @"松开手指,取消发送";
    _recordView.color = [UIColor colorWithRed:255.0 green:0 blue:0 alpha:1.0];
}

- (void)recordDragInside {
    NSLog(@"继续录音:手指上滑 取消发送");
    _recordView.title = @"手指上滑,取消发送";
    _recordView.color = [UIColor clearColor];
}

#pragma mark - 显示底部视图

- (void)willShowBottomView:(UIView *)bottomView {
    if (![_activityBottomView isEqual:bottomView])
    {
        //当前要显示的视图和上一次显示的不一样
        CGFloat bottomHeight = bottomView?bottomView.height:0;
        [self willShowBottomHeight:bottomHeight];
        if (bottomView)
        {
            //重置将要显示的视图位置
            CGRect rect      = bottomView.frame;
            rect.origin.y    = CGRectGetMaxY(tabbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        //移除上一次显示的视图并重置
        if (_activityBottomView)
        {
            [_activityBottomView removeFromSuperview];
        }
        _activityBottomView = bottomView;
    }
    else
    {
        NSAssert(@"", nil);
    }
}

#pragma mark -NSNotification

- (void)IMTabbarChangeFrameNotification:(NSNotification *)note {
    NSDictionary *userInfo     = [note userInfo];
    CGRect beginFrame          = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame            = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration           = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)()        = ^{[self willShowKeyboardFromFrame:beginFrame ToFrame:endFrame];};
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}


- (void)willShowKeyboardFromFrame:(CGRect)fromFrame ToFrame:(CGRect)toFrame {
    if (fromFrame.origin.y == AppHeight)
    {
        //键盘将要显示
        [self willShowBottomHeight:toFrame.size.height];
        
        //系统键盘出现时,重置当前显示的底部视图标记
        if (_activityBottomView)
        {
            [_activityBottomView removeFromSuperview];
        }
        _activityBottomView = nil;
    }
    else if (toFrame.origin.y == AppHeight)
    {
        //键盘将要隐藏
        [self willShowBottomHeight:0];
    }
    else
    {
        //变化的过程中
        [self willShowBottomHeight:toFrame.size.height];
    }
}

         #pragma mark - 重要:底部视图位置变化调整

- (void)willShowBottomHeight:(CGFloat)bottomHeight {
    //上一次的位置
    CGRect fromFrame = self.frame;
    
    //整体要变化的目标高度
    CGFloat toHeight = tabbarView.frame.size.height + bottomHeight;
    
    //纵坐标需要变化的:往上移动为负值，往下为正值(就是上一次的高度减去最新的高度)
    CGFloat originYNeedChange = fromFrame.size.height - toHeight;
    
    //整体要变化的目标位置
    CGRect toFrame   = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + originYNeedChange, fromFrame.size.width, toHeight);
    
    //如若不显示各内容返回
    if(bottomHeight == 0 && self.frame.size.height == self.tabbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0)
    {
        //不显示底部其他视图
        isShowButtomView = NO;
    }
    else
    {
        //显示底部其他视图
        isShowButtomView = YES;
    }
    
    //显示内容视图后，重置自身位置
    self.frame = toFrame;
    
    //重要:代理到顶部,改变消息列表的位置
    if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)])
    {
        [_delegate chatToolbarDidChangeFrameToHeight:toHeight];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)])
    {
        [_delegate inputTextViewWillBeginEditing:textView];
    }
    audioIconBtn.selected = NO;
    emojiIconBtn.selected = NO;
    addIconBtn.selected   = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    [inputTextView becomeFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)])
    {
        [_delegate inputTextViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    [inputTextView resignFirstResponder];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        //文本消息发送
        if (_delegate && [_delegate respondsToSelector:@selector(didSendText:)])
        {
            [_delegate didSendText:textView.text];
            inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:inputTextView]];
        }
        return NO;
    }
    else if ([text isEqualToString:@"@"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectAtCharacter)])
        {
            [_delegate didSelectAtCharacter];
        }
    }
    else if ([text length]==0)
    {
        if (range.length == 1 &&[_delegate respondsToSelector:@selector(didDeleteCharacterFromLocation:)])
        {
            //输入特殊字符 键盘上的x
            return ![_delegate didDeleteCharacterFromLocation:range.location];
        }
    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    //文本输入框在改变内容
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark ------------------ 根据输入框的输入文本改变，调整自身视图和输入框所在的tabbarView视图 --------------

- (CGFloat)getTextViewContentH:(YYTextView *)textView {
    if (MobileSystemVersion >= 7.0)
    {
        //向上取整 返回“最佳”大小
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    }
    else
    {
        return textView.contentSize.height;
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight {
    if (toHeight<=InputViewMinHeight)
    {
        //小于最低高度时取默认最低高度
        toHeight = InputViewMinHeight;
    }
    if (toHeight>=InputViewMaxHeight)
    {
        //大于最大高度时取默认最大高度
        toHeight = InputViewMaxHeight;
    }
    //如果和上一次的文本内容高度一致，不需要重新调整位置
    if (toHeight == previousTextViewContentHeight)
    {
        return;
    }
    //高度有变化 相比上次改变的高度
    CGFloat changeHeight = toHeight - previousTextViewContentHeight;
    
    //自身位置调整
    CGRect  rect  = self.frame;
    rect.size.height +=changeHeight;
    rect.origin.y-=changeHeight;
    self.frame = rect;
    
    //控件父视图位置
    rect  = tabbarView.frame;
    rect.size.height+=changeHeight;
    tabbarView.frame = rect;
    
    [self layoutSubviews];
    
    //重置文本输入框位置
    if (MobileSystemVersion<7.0)
    {
      [inputTextView setContentOffset:CGPointMake(0.0f, (inputTextView.contentSize.height - inputTextView.frame.size.height) / 2) animated:YES];
    }
    
    //修改文本输入框上一次高度标记值
    previousTextViewContentHeight = toHeight;
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)])
    {
        //代理出去，改变消息列表位置
        [_delegate chatToolbarDidChangeFrameToHeight:self.frame.size.height];
    }
}

#pragma mark - 退出键盘

- (BOOL)endEditing:(BOOL)force {
    BOOL result = [super endEditing:force];
    //注意:此处需要将底部tabbarView上的其他按钮点击属性selected置为NO,底部不显示其他视图
    audioIconBtn.selected = NO;
    emojiIconBtn.selected = NO;
    addIconBtn.selected   = NO;
    [self willShowBottomView:nil];
    return result;
}

#pragma mark - IMFaceViewDelegate

- (void)emojiKeyboard:(IMFaceView *)faceView didSelectEmoji:(NSString *)emojiName IsDelete:(BOOL)isDelete {
    if (isDelete)
    {
        //删除符号
        [inputTextView deleteBackward];
    }
    else
    {
        [inputTextView insertText:emojiName];
        [inputTextView scrollToBottom];
    }
}

#pragma mark - IMMoreViewDelegate

- (void)functionBtnPressedWithTitle:(NSString *)title {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewFunctionBtnPressedWithTitle:)])
    {
        [_delegate moreViewFunctionBtnPressedWithTitle:title];
    }
}

#pragma mark - 获取高度

+(CGFloat)getTabbarHeight {
    return 50.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    audioIconBtn.frame  = AppFrame(15, tabbarView.frame.size.height-10-30, 30, 30);
    addIconBtn.frame    = AppFrame(AppWidth-15-30, tabbarView.frame.size.height-10-30, 30, 30);
    emojiIconBtn.frame  = AppFrame(addIconBtn.left-IconGap-30,tabbarView.frame.size.height-10-30, 30, 30);
    inputTextView.frame = AppFrame(audioIconBtn.right+10,7,emojiIconBtn.left-IconGap-audioIconBtn.right-IconGap,tabbarView.frame.size.height-7*2);
    recordBtn.frame     = AppFrame(audioIconBtn.right+10,7, inputTextView.width,tabbarView.frame.size.height-7*2);
    [tabbarView drawTopLine];
    [tabbarView drawBottomLine];
}

#pragma mark - 作为JPtextInputParser的遍历字典

+ (NSDictionary *)emojiMapper {
    NSMutableDictionary *mapper   = [NSMutableDictionary new];
    NSString *path                = [[NSBundle mainBundle] pathForResource:@"EmojisImageTextList" ofType:@"plist"];
    NSDictionary *emojiDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *emojiArray           = [emojiDictionary objectForKey:@"emoji"];
    [emojiArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[dic allKeys] objectAtIndex:0];
        NSString *value = [[dic allValues] objectAtIndex:0];
        mapper[key] = [IMTabbar imageWithName:value];
    }];
    return mapper;
}

#pragma mark - 根据表情名字转换成YYImage对象 很重要

+ (UIImage *)imageWithName:(NSString *)name {
    YYImage *image = [YYImage imageNamed:name];
    image.preloadAllAnimatedImageFrames = YES;
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


@end
