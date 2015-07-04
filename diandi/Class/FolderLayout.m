//
//  FolderLayout.m
//  diandi
//
//  Created by kjubo on 15/6/12.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "FolderLayout.h"

#define kCellMargin 12.0
#define kCellSize CGSizeMake(90, 90)

@interface FolderLayout ()

@end


@implementation FolderLayout

- (void)prepareLayout{
    [super prepareLayout];
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _cellSize = kCellSize;
    _cellMargin = kCellMargin;
    _placeIndex = -1;
}

//通过所在的indexPath确定位置。
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    NSInteger row = path.row;
    if(self.placeIndex >= 0
       && path.row >= self.placeIndex){
        row = row + 1;
    }
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    NSInteger x = row % 3;
    NSInteger y = row / 3;
    attributes.frame = CGRectMake(_cellMargin + (_cellMargin + _cellSize.width)*x, _cellMargin + (_cellMargin + _cellSize.height)*y, _cellSize.width, _cellSize.height);
    return attributes;
}

//用来在一开始给出一套UICollectionViewLayoutAttributes
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

- (CGSize)collectionViewContentSize
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger row = count / 3;
    if(count % 3 > 0){
        row += 1;
    }
    CGFloat height = (row + 1) * kCellMargin + row * kCellSize.height;
    return CGSizeMake(self.collectionView.width, height);
}

@end
