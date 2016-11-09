//
//  GroupMemberControlle.m
//  DemoOfIMTabbar
//
//  Created by 吴 吴 on 16/11/9.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "GroupMemberControlle.h"

@interface GroupMemberControlle ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infoTable;
    NSMutableArray *dataArray;
}

@end

@implementation GroupMemberControlle

- (id)init {
    self = [super init];
    if (self) {
        dataArray = [NSMutableArray arrayWithObjects:@"张三",@"李四",@"王五",@"赵六", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选取群组人员";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建UI

- (void)setupUI {
    infoTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    infoTable.dataSource = self;
    infoTable.delegate   = self;
    [self.view addSubview:infoTable];
    
    [infoTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil )
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = dataArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedUserWithUserName:)])
    {
        [_delegate selectedUserWithUserName:dataArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
