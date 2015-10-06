//
//  DDPopGradeView.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDGradeView.h"
#import "DDTagCollectionViewCell.h"

#define kContinents @[@"亚洲", @"欧洲", @"非洲", @"北美洲", @"南美洲", @"大洋洲"]

@interface DDGradeView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UICollectionView *tagCollectionView;
@property (nonatomic, strong) UITableView *tbList;
@end

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
    }
    return self;
}

#pragma mark - UITableView Delegate & Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [kContinents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont gs_font:NSAppFontL];
    cell.textLabel.textColor = GS_COLOR_WHITE;
    cell.textLabel.text = kContinents[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(ddGradeView:didTableSelected:)]){
        [self.delegate ddGradeView:self didTableSelected:indexPath.row];
    }
}

#pragma mark - UICollectionView Delgate & Method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = kPopTags[indexPath.row%[kPopTags count]];
    CGSize size = [name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontM]} context:nil].size;
    return CGSizeMake(size.width + 16, 36);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = GS_COLOR_RED;
    cell.text = kPopTags[indexPath.row%[kPopTags count]];
    cell.backgroundColor = kPopTagColor[indexPath.row % [kPopTagColor count]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(ddGradeView:didTagSelected:)]){
        [self.delegate ddGradeView:self didTagSelected:indexPath.row];
    }
}


@end
