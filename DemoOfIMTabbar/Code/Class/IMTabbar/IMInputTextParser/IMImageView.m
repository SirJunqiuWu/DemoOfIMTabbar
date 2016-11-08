//
//  IMImageView.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/3.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "IMImageView.h"

@implementation IMImageView

- (void)setEditImage:(IMEditImage *)editImage {
    _editImage = editImage;
    self.image = _editImage.finishedImage;
}

@end
