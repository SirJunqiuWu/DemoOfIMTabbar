//
//  NSMutableAttributedString+Utils.m
//  TemplateTest
//
//  Created by JackWu on 16/1/21.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "NSMutableAttributedString+Utils.h"
#import "YYKit.h"

@implementation NSMutableAttributedString (Utils)

+ (NSMutableAttributedString *)attachmentStringWithImageUrl:(NSString *)imageUrl imageSize:(CGSize)size {
    
    CGSize attachmentSize       = size;
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent             = attachmentSize.height;
    delegate.descent            = 0;
    delegate.width              = attachmentSize.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode       = UIViewContentModeScaleAspectFit;
    attachment.contentInsets     = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIImageView *imageView       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, attachmentSize.width, attachmentSize.height)];
    imageView.contentMode        = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds      = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
    //设置附件的content
    attachment.content           = imageView;
    
    CTRunDelegateRef ctDelegate    = delegate.CTRunDelegate;
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    
    if (ctDelegate) CFRelease(ctDelegate);
    return atr;
}

+ (NSMutableAttributedString *)attachmentStringWithImage:(IMEditImage *)image imageSize:(CGSize)size gestureTarget:(id)target action:(SEL)action {
    CGSize attachmentSize         = size;
    
    YYTextRunDelegate *delegate   = [YYTextRunDelegate new];
    delegate.ascent               = attachmentSize.height;
    delegate.descent              = 0;
    delegate.width                = attachmentSize.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode       = UIViewContentModeScaleAspectFit;
    attachment.contentInsets     = UIEdgeInsetsMake(0, 0, 0, 0);
    
    IMImageView *imageView           = [[IMImageView alloc] initWithFrame:CGRectMake(0, 0, attachmentSize.width, attachmentSize.height)];
    imageView.contentMode            = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds          = YES;
    imageView.editImage              = image;
    imageView.userInteractionEnabled = YES;
    
    if (target != nil)
    {
        //增加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    //设置附件的content
    attachment.content = imageView;
    
    CTRunDelegateRef ctDelegate    = delegate.CTRunDelegate;
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

+ (NSMutableAttributedString *)attachmentStringWithCode:(NSString *)content size:(CGSize)size {
    CGSize attachmentSize = size;
    
    YYTextRunDelegate *delegate  = [YYTextRunDelegate new];
    delegate.ascent              = attachmentSize.height;
    delegate.descent             = 0;
    delegate.width               = attachmentSize.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode       = UIViewContentModeScaleAspectFit;
    attachment.contentInsets     = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIWebView *codeView          = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, attachmentSize.width, attachmentSize.height)];
    codeView.backgroundColor     = CDBACKGROUND;
    [codeView loadHTMLString:content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    codeView.scrollView.bounces  = NO;
    codeView.scrollView.backgroundColor = CDBACKGROUND;
    
    //设置附件的content
    attachment.content = codeView;
    
    CTRunDelegateRef ctDelegate    = delegate.CTRunDelegate;
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    return atr;
}

@end
