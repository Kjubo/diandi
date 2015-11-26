//
//  DDLinkageView.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDLinkageView.h"
#import "DDLinkageCell.h"
#import "DDCacheHelper.h"
//#import "UIScrollView+EmptyDataSet.h"

@interface DDLinkageView ()<UITableViewDelegate, UITableViewDataSource>
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
        self.tbStage1st.delegate = self;
        self.tbStage1st.dataSource = self;
        self.tbStage1st.backgroundColor = [UIColor clearColor];
        self.tbStage1st.separatorColor = [UIColor clearColor];
        self.tbStage1st.separatorStyle = UITableViewCellSeparatorStyleNone;
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
//        self.tbStage1st.emptyDataSetDelegate = self;
//        self.tbStage2nd.emptyDataSetSource = self;
        self.tbStage2nd.backgroundColor = [UIColor clearColor];
        self.tbStage2nd.separatorColor = [UIColor clearColor];
        self.tbStage2nd.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tbStage2nd.rowHeight = 50.0;
        [self.tbStage2nd registerClass:[DDLinkageCell class] forCellReuseIdentifier:kTableCellIdentifier];
        [self addSubview:self.tbStage2nd];
        [self.tbStage2nd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.equalTo(self).dividedBy(2.0);
        }];
        
        _selectedStage1Index = -1;
        
    }
    return self;
}

- (void)setData:(DDArea *)data{
    _data = data;
    [self.tbStage1st reloadData];
    [self.tbStage2nd reloadData];
}

- (void)setSelectedStage1Index:(NSInteger)selectedStage1Index{
    _selectedStage1Index = selectedStage1Index;
    [self.tbStage1st reloadData];
    [self.tbStage2nd reloadData];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbStage2nd){
        if(self.selectedStage1Index < 0){
            return 0;
        }else{
            DDArea *parent = self.data.list[self.selectedStage1Index];
            return [parent.list count];
        }
    }else if(tableView == self.tbStage1st){
        return [self.data.list count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLinkageCell *cell = (DDLinkageCell *)[tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DDArea *item = nil;
    if(tableView == self.tbStage1st){
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(indexPath.row == self.selectedStage1Index){
            cell.backgroundColor = GS_COLOR_BLACK;
            cell.textLabel.textColor = GS_COLOR_BLUE;
        }else{
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = GS_COLOR_WHITE;
        }
        item = self.data.list[indexPath.row];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = GS_COLOR_BLACK;
        cell.textLabel.textColor = GS_COLOR_WHITE;
        DDArea *parent = self.data.list[self.selectedStage1Index];
        item = parent.list[indexPath.row];
    }
    cell.textLabel.font = [UIFont gs_font:NSAppFontM];
    cell.textLabel.text = item.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbStage1st){
        self.selectedStage1Index = indexPath.row;
    }else{
        NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.selectedStage1Index];
        self.selectedStage1Index = -1;
        if([self.delegate respondsToSelector:@selector(ddLinkageView:didSelected:)]){
            [self.delegate ddLinkageView:self didSelected:selectedPath];
        }
    }
}

#pragma mark - DZNEmptyDataSetDataSouce
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
//    if(scrollView == self.tbStage2nd){
//        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请选择国家~" attributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontM], NSForegroundColorAttributeName : GS_COLOR_LIGHTGRAY}];
//        return str;
//    }
//    return nil;
//}


@end
