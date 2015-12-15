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
#import "DDCacheHelper.h"

@interface DDSearchEmptyView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *maskerView;
@property (nonatomic, strong) UICollectionView *contentView;
@property (nonatomic, strong) UICollectionViewFlowLayout *fl;
@end

static NSString *kHeaderReuseIdentifier = @"kHeaderReuseIdentifier";
static NSString *kTagCellIdentifier = @"kTagCellIdentifier";
@implementation DDSearchEmptyView

- (instancetype)init{
    if(self = [super init]){
        // Initialization code
        self.clipsToBounds = YES;
        [super setHidden:YES];
        
        //透明遮罩层
        self.maskerView = [UIView new];
        self.maskerView.backgroundColor = GS_COLOR_LIGHT;
        UITapGestureRecognizer *tapMaskerView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMaskerView)];
        [self.maskerView addGestureRecognizer:tapMaskerView];
        [self addSubview:self.maskerView];
        [self.maskerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.fl = [[UICollectionViewFlowLayout alloc] init];
        self.fl.minimumLineSpacing = 5.0;
        self.fl.minimumInteritemSpacing = 5.0;
        self.fl.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.fl.headerReferenceSize = CGSizeMake(DF_WIDTH, 20);
        self.contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.fl];
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


- (void)handleTapMaskerView{
    self.hidden = YES;
}

- (void)setHidden:(BOOL)hidden{
    if(self.hidden == hidden) return;
    if(hidden){
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.top = -self.contentView.height;
        }completion:^(BOOL finished) {
            [super setHidden:YES];
        }];
    }else{
        [self.contentView setContentOffset:CGPointZero];
        [self.contentView setScrollEnabled:NO];
        [self.superview bringSubviewToFront:self];
        [super setHidden:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.top = 0;
        } completion:nil];
    }
}

#pragma mark - UICollectionView Delegate & Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if([[DDCacheHelper shared].searchHistoryList count] > 0){
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        if([DDCacheHelper shared].mddList){
            return [[DDCacheHelper shared].mddList.hotsearch count];
        }else{
            return 0;
        }
    }else{
        return [[DDCacheHelper shared].searchHistoryList count];
    }
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return CGSizeMake((DF_WIDTH - 40)/3.0, 36);
    }else{
        return CGSizeMake(DF_WIDTH - 20.0, 36);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = GS_COLOR_WHITE;
    if(indexPath.section == 0){
        if([DDCacheHelper shared].mddList
           && [[DDCacheHelper shared].mddList.hotsearch count] > 0){
            cell.text = [[DDCacheHelper shared].mddList.hotsearch[indexPath.row] copy];
        }
    }else{
        if([[DDCacheHelper shared].searchHistoryList count] > 0){
            cell.text = [[DDCacheHelper shared].searchHistoryList[indexPath.row] copy];
        }
    }
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
    DDTagCollectionViewCell *cell = (DDTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell && [self.delegate respondsToSelector:@selector(ddSearchEmptyViewDidSelect:)]){
        [self.delegate ddSearchEmptyViewDidSelect:cell.text];
    }
}

@end
