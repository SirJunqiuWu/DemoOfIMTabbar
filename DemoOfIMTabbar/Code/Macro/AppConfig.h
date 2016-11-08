//
//  AppConfig.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/2.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#pragma mark ------------------ App基本数据宏 --------------

#define AppWidth                     [UIScreen mainScreen].bounds.size.width
#define AppHeight                    [UIScreen mainScreen].bounds.size.height
#define MobileSystemVersion          [[[UIDevice currentDevice]systemVersion]floatValue]

#pragma mark ------------------ App常用快捷宏 --------------

#define AppFrame(x,y,width,height)    CGRectMake((x),(y),(width),(height))

#pragma mark ------------------ 控件统一配置 --------------

#define AppUICornerRadius              5.0f//按钮的圆角度
#define CD_Text                        [UIColor colorWithHexString:@"#333333"]
#define CD_LineColor                   [UIColor colorWithHexString:@"#e5e5e5"]
#define AppLineHeight                  (1 / [UIScreen mainScreen].scale)
#define CDBACKGROUND                   [UIColor colorWithHexString:@"#e9efef"]





#endif /* AppConfig_h */
