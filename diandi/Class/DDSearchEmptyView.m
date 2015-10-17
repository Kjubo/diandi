//
//  DDSearchEmptyView.m
//  diandi
//
//  Created by kjubo on 15/10/17.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSearchEmptyView.h"
#import "DDTagCollectionViewCell.h"
#import "DDSearchHeaderCollectionReusableView.h"
@interface DDSearchEmptyView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *contentView;
@end

static NSString *kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
static NSString *kTagCellIdentifier = @"kTagCellIdentifier";
@implementation DDSearchEmptyView

- (instancetype)init{
    if(self = [super init]){
        // Initialization code
        self.backgroundColor = GS_COLOR_BACKGROUND;
        
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.minimumLineSpacing = 5.0;
        fl.minimumInteritemSpacing = 5.0;
        fl.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.delegate = self;
        self.contentView.dataSource = self;
        [self.contentView registerClass:[DDTagCollectionViewCell class] forCellWithReuseIdentifier:kTagCellIdentifier];
        [self.contentView registerClass:[DDSearchHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseIdentifier];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UICollectionView Delegate & Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return 6;
    }else{
        return 4;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return CGSizeMake(DF_WIDTH, 36);
    }else{
        return CGSizeMake((DF_WIDTH - 40)/3.0, 36);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = GS_COLOR_RED;
    cell.text = @"关键词";
//    cell.backgroundColor = kPopTagColor[indexPath.row % [kPopTagColor count]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reuseableView = nil;
    if(kind == UICollectionElementKindSectionHeader){
        DDSearchHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderReuseIdentifier forIndexPath:indexPath];
        if(indexPath.section == 0){
            header.title = @"# 热门搜索 #";
        }else{
            header.title = @"# 历史搜索 #";
        }
        reuseableView = header;
    }
    return reuseableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if([self.delegate respondsToSelector:@selector(ddGradeView:didTagSelected:)]){
//        [self.delegate ddGradeView:self didTagSelected:indexPath.row];
//    }
}

@end
