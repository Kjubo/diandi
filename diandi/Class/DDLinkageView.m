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
#import "DDLinkageCountryCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface DDLinkageView ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
/**
 *  一级菜单
 */
@property (nonatomic, strong) UITableView *tbStage1st;

/**
 *  二级菜单
 */
@property (nonatomic, strong) UITableView *tbStage2nd;
@end

static NSString *kCellIdentifier = @"kTableCellIdentifier";
static NSString *kCountryCellIdentifier = @"kCountryCellIdentifier";
@implementation DDLinkageView

- (instancetype)init{
    if(self = [super init]){
        self.tbStage1st = [UITableView new];
        self.tbStage1st.delegate = self;
        self.tbStage1st.dataSource = self;
        self.tbStage1st.backgroundColor = GS_COLOR_LIGHT;
        self.tbStage1st.separatorColor = [UIColor clearColor];
        self.tbStage1st.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tbStage1st.tableFooterView = [UIView new];
        [self.tbStage1st registerClass:[DDLinkageCountryCell class] forCellReuseIdentifier:kCountryCellIdentifier];
        [self addSubview:self.tbStage1st];
        [self.tbStage1st mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(self).dividedBy(2.0);
        }];
        
        self.tbStage2nd = [UITableView new];
        self.tbStage2nd.delegate = self;
        self.tbStage2nd.dataSource = self;
//        self.tbStage2nd.emptyDataSetDelegate = self;
//        self.tbStage2nd.emptyDataSetSource = self;
        self.tbStage2nd.backgroundColor = GS_COLOR_WHITE;
        self.tbStage2nd.separatorColor = [UIColor clearColor];
        self.tbStage2nd.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tbStage2nd.tableFooterView = [UIView new];
        [self.tbStage2nd registerClass:[DDLinkageCell class] forCellReuseIdentifier:kCellIdentifier];
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
    _data = [data copy];
    [self.tbStage1st reloadData];
    [self.tbStage2nd reloadData];
}

- (void)setSelectedStage1Index:(NSInteger)selectedStage1Index{
    _selectedStage1Index = selectedStage1Index;
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
    if(tableView == self.tbStage1st){
        DDLinkageCountryCell *cell = (DDLinkageCountryCell *)[tableView dequeueReusableCellWithIdentifier:kCountryCellIdentifier forIndexPath:indexPath];
        DDArea *item = self.data.list[indexPath.row];
        cell.textLabel.text = [item.name copy];
        return cell;
    }else{
        DDLinkageCell *cell = (DDLinkageCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        DDArea *parent = self.data.list[self.selectedStage1Index];
        DDArea *item = parent.list[indexPath.row];
        cell.textLabel.text = [item.name copy];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbStage1st){
        self.selectedStage1Index = indexPath.row;
    }else{
        NSIndexPath *selectedPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.selectedStage1Index];
//        self.selectedStage1Index = -1;
        if([self.delegate respondsToSelector:@selector(ddLinkageView:didSelected:)]){
            [self.delegate ddLinkageView:self didSelected:selectedPath];
        }
    }
}

#pragma mark - DZEmptyDataSet Delegate & DataSource
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return GS_COLOR_WHITE;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if(self.selectedStage1Index < 0
       || self.selectedStage1Index > [self.data.list count]){
        return YES;
    }
    DDArea *item = self.data.list[self.selectedStage1Index];
    return [item.list count] == 0;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
    return CGPointMake(0, -DF_HEIGHT/4.0);
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return NO;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    if(scrollView == self.tbStage2nd){
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"请选择国家~" attributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontM], NSForegroundColorAttributeName : GS_COLOR_GRAY}];
        return str;
    }
    return nil;
}


@end
