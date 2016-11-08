//
//  IMInputTextParser.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMInputTextParser.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>

#import "IMEditImage.h"
#import "NSMutableAttributedString+Utils.h"

#define LOCK(...) OSSpinLockLock(&_lock); \
__VA_ARGS__; \
OSSpinLockUnlock(&_lock);

@implementation IMInputTextParser
{
    NSRegularExpression *_regex;        // regex mapper
    NSRegularExpression *_atRegex;
    NSDictionary *_mapper;              // emoj mapper  key:name value:filepath
    NSMutableDictionary *_imageMapper;         // image mapper key:name value:JPEditImage
    OSSpinLock _lock;
    NSMutableArray *_imageBindingArray;
}
- (instancetype)init
{
    self = [super init];
    _lock = OS_SPINLOCK_INIT;
    _imageMapper = [NSMutableDictionary dictionary];
    _imageBindingArray = [NSMutableArray array];
    
    /*\s：用于匹配单个空格符，包括tab键和换行符；
     \S：用于匹配除单个空格符之外的所有字符；*/
    NSString *pattern = @"(@[a-zA-z0-9\u4e00-\u9fa5]+\\s)";
    _atRegex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    
    return self;
}

- (void)addImageBindingName:(NSString *)string
{
    if ([_imageBindingArray containsObject:string])
    {
        return;
    }
    [_imageBindingArray addObject:string];
    [self createImageBindingRegex];
}

- (void)addImageMapper:(NSDictionary *)mapper
{
    [_imageMapper setDictionary:mapper];
    [self createImageBindingRegex];
}

- (void)createImageBindingRegex
{
    NSMutableString *pattern = @"(".mutableCopy;
    
    for (NSUInteger i = 0, max = _imageMapper.allKeys.count; i < _imageMapper.allKeys.count; i++)
    {
        NSMutableString *str =  [[_imageMapper.allKeys objectAtIndex:i] mutableCopy];
        
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"$^?+*.,#|{}[]()\\"];
        // escape regex characters
        for (NSUInteger ci = 0, cmax = str.length; ci < cmax; ci++) {
            unichar c = [str characterAtIndex:ci];
            if ([charset characterIsMember:c]) {
                [str insertString:@"\\" atIndex:ci];
                ci++;
                cmax++;
            }
        }
        
        [pattern appendString:str];
        if (i != max - 1) [pattern appendString:@"|"];
    }
    [pattern appendString:@")"];
    self.regexImageBinding = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    
}

- (NSDictionary *)emoticonMapper
{
    LOCK(NSDictionary *mapper = _mapper); return mapper;
}

- (void)setEmoticonMapper:(NSDictionary *)emoticonMapper
{
    LOCK(
         _mapper = emoticonMapper.copy;
         if (_mapper.count == 0) {
             _regex = nil;
         } else {
             NSMutableString *pattern = @"(".mutableCopy;
             NSArray *allKeys = _mapper.allKeys;
             NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"$^?+*.,#|{}[]()\\"];
             for (NSUInteger i = 0, max = allKeys.count; i < max; i++) {
                 NSMutableString *one = [allKeys[i] mutableCopy];
                 
                 // escape regex characters
                 for (NSUInteger ci = 0, cmax = one.length; ci < cmax; ci++) {
                     unichar c = [one characterAtIndex:ci];
                     if ([charset characterIsMember:c]) {
                         [one insertString:@"\\" atIndex:ci];
                         ci++;
                         cmax++;
                     }
                 }
                 
                 [pattern appendString:one];
                 if (i != max - 1) [pattern appendString:@"|"];
             }
             [pattern appendString:@")"];
             _regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
         }
         );
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange
{
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    if (text.length == 0) return NO;
    
    [text setAttribute:NSForegroundColorAttributeName value:CD_Text range:NSMakeRange(0, text.length)];
    
    __block BOOL isChange = NO;
    
    NSDictionary *mapper;
    NSRegularExpression *regex;
    LOCK(mapper = _mapper; regex = _regex;);
    //    if (mapper.count == 0 || regex == nil) return NO;
    
    NSArray *matches = [regex matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.length)];
    if (matches.count != 0)
    {
        NSRange selectedRange = range ? *range : NSMakeRange(0, 0);
        NSUInteger cutLength = 0;
        for (NSUInteger i = 0, max = matches.count; i < max; i++) {
            NSTextCheckingResult *one = matches[i];
            NSRange oneRange = one.range;
            if (oneRange.length == 0) continue;
            oneRange.location -= cutLength;
            NSString *subStr = [text.string substringWithRange:oneRange];
            UIImage *emoticon = mapper[subStr];
            if (!emoticon) continue;
            
            CGFloat fontSize = 12; // CoreText default value
            CTFontRef font = (__bridge CTFontRef)([text attribute:NSFontAttributeName atIndex:oneRange.location]);
            if (font) fontSize = CTFontGetSize(font);
            NSMutableAttributedString *atr = [NSAttributedString attachmentStringWithEmojiImage:emoticon fontSize:fontSize];
            [atr setTextBackedString:[YYTextBackedString stringWithString:subStr] range:NSMakeRange(0, atr.length)];
            [text replaceCharactersInRange:oneRange withString:atr.string];
            [text removeDiscontinuousAttributesInRange:NSMakeRange(oneRange.location, atr.length)];
            [text addAttributes:atr.attributes range:NSMakeRange(oneRange.location, atr.length)];
            selectedRange = [self _replaceTextInRange:oneRange withLength:atr.length selectedRange:selectedRange];
            cutLength += oneRange.length - 1;
        }
        if (range) *range = selectedRange;
        isChange = YES;
    }
    
    NSArray *imageMatches = [self.regexImageBinding matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.length)];
    if (imageMatches.count != 0)
    {
        NSRange selectedRange = range ? *range : NSMakeRange(0, 0);
        NSUInteger cutLength = 0;
        
        for (NSUInteger i = 0, max = imageMatches.count; i < max; i++)
        {
            NSTextCheckingResult *one = imageMatches[i];
            NSRange oneRange = one.range;
            if (oneRange.length == 0) continue;
            oneRange.location -= cutLength;
            NSString *subStr = [text.string substringWithRange:oneRange];
            IMEditImage *image = _imageMapper[subStr];
            if (!image) continue;
            
            CGFloat width = kScreenWidth - 20;
            CGFloat height = width * (image.finishedImage.size.height / image.finishedImage.size.width);
            CGSize imageSize = CGSizeMake(width, height);
            
            NSMutableAttributedString *atr = [NSMutableAttributedString attachmentStringWithImage:image imageSize:imageSize gestureTarget:self.attachmentTarget action:self.attachmentAction];
            [atr setTextBackedString:[YYTextBackedString stringWithString:subStr] range:NSMakeRange(0, atr.length)];
            [text replaceCharactersInRange:oneRange withString:atr.string];
            [text removeDiscontinuousAttributesInRange:NSMakeRange(oneRange.location, atr.length)];
            [text addAttributes:atr.attributes range:NSMakeRange(oneRange.location, atr.length)];
            selectedRange = [self _replaceTextInRange:oneRange withLength:atr.length selectedRange:selectedRange];
            cutLength += oneRange.length - 1;
            
        }
        
        if (range) *range = selectedRange;
        isChange = YES;
    }
    
    [_atRegex enumerateMatchesInString:text.string options:NSMatchingWithoutAnchoringBounds range:text.rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        if ([text attribute:YYTextBindingAttributeName atIndex:range.location effectiveRange:NULL]) return;
        
        NSRange bindlingRange = NSMakeRange(range.location, range.length - 1);
        YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:NO];
        [text setTextBinding:binding range:bindlingRange]; /// Text binding
        //        [text setColor:[UIColor colorWithRed:0.000 green:0.519 blue:1.000 alpha:1.000] range:bindlingRange];
        isChange = YES;
    }];
    
    return isChange;
    
}



@end
