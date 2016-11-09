//
//  GroupMemberControlle.h
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/9.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupMemberControlleDelegate;

@interface GroupMemberControlle : UIViewController

@property(nonatomic,assign)id<GroupMemberControlleDelegate>delegate;

@end

@protocol GroupMemberControlleDelegate <NSObject>

@optional

- (void)selectedUserWithUserName:(NSString *)userName;

@end
