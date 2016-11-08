//
//  NSMutableAttributedString+Utils.m
//  TemplateTest
//
//  Created by caijingpeng on 16/1/21.
//  Copyright © 2016年 caijingpeng.haowu. All rights reserved.
//

#import "NSMutableAttributedString+Utils.h"
#import "YYKit.h"

@implementation NSMutableAttributedString (Utils)

+ (NSMutableAttributedString *)attachmentStringWithImageUrl:(NSString *)imageUrl imageSize:(CGSize)size {
    
    CGSize attachmentSize = size;
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = attachmentSize.height;
    delegate.descent = 0;
    delegate.width = attachmentSize.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, attachmentSize.width, attachmentSize.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    attachment.content = imageView;
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

+ (NSMutableAttributedString *)attachmentStringWithImage:(IMEditImage *)image imageSize:(CGSize)size gestureTarget:(id)target action:(SEL)action
{
    CGSize attachmentSize = size;
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = attachmentSize.height;
    delegate.descent = 0;
    delegate.width = attachmentSize.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    IMImageView *imageView = [[IMImageView alloc] initWithFrame:CGRectMake(0, 0, attachmentSize.width, attachmentSize.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.editImage = image;
    imageView.userInteractionEnabled = YES;
    
    if (target != nil)
    {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    attachment.content = imageView;
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

+ (NSMutableAttributedString *)attachmentStringWithCode:(NSString *)content size:(CGSize)size
{
    CGSize attachmentSize = size;
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = attachmentSize.height;
    delegate.descent = 0;
    delegate.width = attachmentSize.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIWebView *codeView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, attachmentSize.width, attachmentSize.height)];
    codeView.backgroundColor = CDBACKGROUND;
//    codeView.backgroundColor = [UIColor redColor];
    [codeView loadHTMLString:content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    codeView.scrollView.bounces = NO;
    codeView.scrollView.backgroundColor = CDBACKGROUND;
    attachment.content = codeView;
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

@end
