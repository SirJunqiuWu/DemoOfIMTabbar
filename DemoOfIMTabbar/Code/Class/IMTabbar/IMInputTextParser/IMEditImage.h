//
//  IMEditImage.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMEditImage : NSObject

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *drawingImage;
@property (nonatomic, strong) UIImage *mosaicImage;
@property (nonatomic, strong) UIImage *finishedImage;
@property (nonatomic, strong) NSString *imageName;

@end
