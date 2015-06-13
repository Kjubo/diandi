//
//  SignFolderView.m
//  diandi
//
//  Created by kjubo on 15/6/2.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "SignFolderView.h"
#import "FolderCellView.h"
#define kRowCount       3
#define kCellMargin     5
#define kCellRangeSize  CGSizeMake(100, 100)
#define kCellSize       CGSizeMake(90, 90)


@interface SignFolderView ()<UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIScrollView *folderGroupView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageGroupView;

@property (nonatomic, strong) NSMutableArray *images;


@end

@implementation SignFolderView

static NSString *identifier = @"FolderCell";

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.imageGroupView registerClass:[FolderCellView class] forCellWithReuseIdentifier:identifier];
    self.images = [NSMutableArray array];
    
//    for(int k = 0; k < 10; k++){
//        NSInteger i = k % kRowCount;
//        NSInteger j = k / kRowCount;
//        
//        FolderCellView *cell = [[FolderCellView alloc] initWithFrame:CGRectMake(5 + i * kCellRangeSize.width,  5 + j * kCellRangeSize.height, kCellSize.width, kCellSize.height)];
//        cell.tag = k;
//        cell.title = [NSString stringWithFormat:@"%@", @(k)];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//        pan.delegate = self;
//        [cell addGestureRecognizer:pan];
//        [self.images addObject:cell];
//        [self.imageGroupView addSubview:cell];
//    }
}

- (void)setOpened:(BOOL)opened{
    if(_opened == opened) return;
    _opened = opened;
}

- (void)hideImagesView{
    self.opened = NO;
}



- (void)panView:(UIPanGestureRecognizer *)sender{
    UIView *view = sender.view;
    CGPoint pt = [sender translationInView:self.imageGroupView];
    CGPoint ptWillMoveTo = CGPointMake(view.centerX + pt.x, view.centerY + pt.y);
    
    NSInteger row = ptWillMoveTo.y / kCellSize.height;
    NSInteger col = ptWillMoveTo.x / kCellSize.width;
    NSInteger toTag = row * kRowCount + col;
    
    view.center = ptWillMoveTo;
    [sender setTranslation:CGPointZero inView:self.imageGroupView];
}

#pragma mark - UICollectionView Delegate & DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FolderCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.title = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}




@end
