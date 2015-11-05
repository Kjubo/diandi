//
//  DDPopGradeView.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDGradeView.h"
#import "DDTagCollectionViewCell.h"
#import "DDCacheHelper.h"

@interface DDGradeView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UICollectionView *tagCollectionView;
@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, copy) DDMddListModel *mddList;
@end

#define kPopTagColor    @[HEXRGBCOLOR(0xC2185B), HEXRGBCOLOR(0x4CAF50), HEXRGBCOLOR(0xE91E63), HEXRGBCOLOR(0x2196F3), HEXRGBCOLOR(0x4CAF50), HEXRGBCOLOR(0x009688), HEXRGBCOLOR(0x7B1FA2)]
static NSString *kTableCellIdentifier   = @"kTableCellIdentifier";
static NSString *kTagCellIdentifier     = @"kTagCellIdentifier";
@implementation DDGradeView

- (instancetype)init{
    if(self = [super init]){
        // Initialization code
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.minimumLineSpacing = 5.0;
        fl.minimumInteritemSpacing = 5.0;
        fl.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.tagCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        self.tagCollectionView.backgroundColor = [UIColor clearColor];
        self.tagCollectionView.delegate = self;
        self.tagCollectionView.dataSource = self;
        [self.tagCollectionView registerClass:[DDTagCollectionViewCell class] forCellWithReuseIdentifier:kTagCellIdentifier];
        [self addSubview:self.tagCollectionView];
        [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.equalTo(self);
            make.width.equalTo(self).dividedBy(3.0/2.0);
        }];
        
        self.tbList = [UITableView new];
        self.tbList.backgroundColor = [UIColor clearColor];
        self.tbList.separatorColor = [UIColor clearColor];
        self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tbList.delegate = self;
        self.tbList.dataSource = self;
        self.tbList.rowHeight = 50.0;
        [self.tbList registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellIdentifier];
        [self addSubview:self.tbList];
        [self.tbList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.height.equalTo(self);
            make.width.equalTo(self).dividedBy(3.0);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = GS_COLOR_LIGHT;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tbList).offset(10);
            make.bottom.equalTo(self.tbList).offset(-10);
            make.left.equalTo(self.tbList);
            make.width.mas_equalTo(@1);
        }];
        
        [self reloadData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kNotificationName_MddList_Update object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadData{
    self.mddList = [DDCacheHelper shared].mddList;
    [self.tbList reloadData];
    [self.tagCollectionView reloadData];
}

#pragma mark - UITableView Delegate & Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mddList.mddlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont gs_font:NSAppFontL];
    cell.textLabel.textColor = GS_COLOR_WHITE;
    DDArea *item = self.mddList.mddlist[indexPath.row];
    cell.textLabel.text = [item.name copy];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(ddGradeView:didTableSelected:withData:)]){
        DDArea *data = self.mddList.mddlist[indexPath.row];
        [self.delegate ddGradeView:self didTableSelected:indexPath.row withData:data];
    }
}

#pragma mark - UICollectionView Delgate & Method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mddList.hotplace count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDArea *item = self.mddList.hotplace[indexPath.row];
    NSString *name = [item.name copy];
    CGSize size = [name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontM]} context:nil].size;
    return CGSizeMake(size.width + 16, 36);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellIdentifier forIndexPath:indexPath];
    DDArea *item = self.mddList.hotplace[indexPath.row];
    cell.text = [item.name copy];
    cell.backgroundColor = kPopTagColor[indexPath.row % [kPopTagColor count]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(ddGradeView:didTagSelected:)]){
        [self.delegate ddGradeView:self didTagSelected:indexPath.row];
    }
}


@end
