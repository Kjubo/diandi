//
//  DDLinkageView.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDLinkageView.h"
#import "DDLinkageCell.h"
#import ""
@interface DDLinkageView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSInteger selectedStage1Index;

/**
 *  一级菜单
 */
@property (nonatomic, strong) UITableView *tbStage1st;

/**
 *  二级菜单
 */
@property (nonatomic, strong) UITableView *tbStage2nd;
@end

static NSString *kTableCellIdentifier = @"kTableCellIdentifier";
@implementation DDLinkageView

- (instancetype)init{
    if(self = [super init]){
        self.tbStage1st = [UITableView new];
        self.tbStage1st.backgroundColor = GS_COLOR_WHITE;
        self.tbStage1st.delegate = self;
        self.tbStage1st.dataSource = self;
        self.tbStage1st.separatorColor = GS_COLOR_LIGHT;
        self.tbStage1st.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tbStage1st.rowHeight = 50.0;
        [self.tbStage1st registerClass:[DDLinkageCell class] forCellReuseIdentifier:kTableCellIdentifier];
        [self addSubview:self.tbStage1st];
        [self.tbStage1st mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(self).dividedBy(2.0);
        }];
        
        self.tbStage2nd = [UITableView new];
        self.tbStage2nd.delegate = self;
        self.tbStage2nd.dataSource = self;
        self.tbStage2nd.backgroundColor = GS_COLOR_LIGHT;
        self.tbStage2nd.separatorColor = GS_COLOR_WHITE;
        self.tbStage2nd.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tbStage2nd.rowHeight = 50.0;
        [self.tbStage2nd registerClass:[DDLinkageCell class] forCellReuseIdentifier:kTableCellIdentifier];
        [self addSubview:self.tbStage2nd];
        [self.tbStage2nd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.equalTo(self).dividedBy(2.0);
        }];
    }
    return self;
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLinkageCell *cell = (DDLinkageCell *)[tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    if(tableView == self.tbStage1st){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont gs_font:NSAppFontM];
    cell.textLabel.textColor = GS_COLOR_BLACK;
    cell.textLabel.text = @"城市名称";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbStage1st){
        self.selectedStage1Index = indexPath.row;
        [self.tbStage2nd reloadData];
    }else{
        NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.selectedStage1Index];
        if([self.delegate respondsToSelector:@selector(ddLinkageView:didSelected:)]){
            [self.delegate ddLinkageView:self didSelected:selectedPath];
        }
    }
}

@end
