//
//  SignFolderView.m
//  diandi
//
//  Created by kjubo on 15/6/2.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "SignFolderView.h"
#import "FolderCellView.h"
#import "FolderLayout.h"
#define kRowCount       3
#define kCellMargin     5


@interface SignFolderView ()<UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *folderGroupView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageGroupView;
@property (nonatomic, strong) FolderLayout *imagesLayout;
@property (nonatomic, strong) UICollectionViewCell *selectedCell;
@property (nonatomic, strong) UIImageView *movingCellImage;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) BOOL isDragging;

@end

@implementation SignFolderView

static NSString *identifier = @"FolderCell";

- (void)awakeFromNib{
    [super awakeFromNib];
    self.imagesLayout = [[FolderLayout alloc] init];
    [self.imageGroupView registerClass:[FolderCellView class] forCellWithReuseIdentifier:identifier];
    [self.imageGroupView setCollectionViewLayout:self.imagesLayout];
    [self.folderGroupView registerClass:[FolderCellView class] forCellWithReuseIdentifier:identifier];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self.imageGroupView addGestureRecognizer:panRecognizer];
    self.images = [NSMutableArray array];
    for(int i = 0; i < 20 ; i++){
        [self.images addObject:@(i + 100)];
    }
}

- (void)setOpened:(BOOL)opened{
    if(_opened == opened) return;
    _opened = opened;
}

- (void)hideImagesView{
    self.opened = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(!self.isDragging &&
       otherGestureRecognizer == self.imageGroupView.panGestureRecognizer) {
        return YES;
    } else {
        return NO;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)panRecognizer{
    CGPoint locationPoint = [panRecognizer locationInView:self.imageGroupView];
    NSIndexPath *indexPath = [self.imageGroupView indexPathForItemAtPoint:locationPoint];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        if(indexPath){
            self.isDragging = YES;
        }else{
            return;
        }
        self.selectedCell = [self.imageGroupView cellForItemAtIndexPath:indexPath];
        UIGraphicsBeginImageContext(self.selectedCell.bounds.size);
        [self.selectedCell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.movingCellImage = [[UIImageView alloc] initWithImage:cellImage];
        [self.movingCellImage setCenter:locationPoint];
        [self.movingCellImage setAlpha:0.75f];
        [self.imageGroupView addSubview:self.movingCellImage];
        
        self.selectedCell.hidden = YES;
        self.selectedIndexPath = [indexPath copy];
        
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        if(self.isDragging){
            [self.movingCellImage setCenter:locationPoint];
            
//            [self.imageGroupView performBatchUpdates:^{
//                self.imagesLayout.placeIndex = indexPath.row;
//                [self.imagesLayout invalidateLayout];
//                [self.imageGroupView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] animated:YES];
//            } completion:nil];
        }
        
    } else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        if(self.isDragging){
            self.selectedCell.hidden = NO;
            [self.movingCellImage removeFromSuperview];
            if(indexPath){
                id item = self.images[self.selectedIndexPath.row];
                if(item){
                    [self.images removeObject:item];
                    [self.images insertObject:item atIndex:indexPath.row];
                }
            }
            self.imagesLayout.placeIndex = -1;
            [self.imageGroupView reloadData];
            self.isDragging = NO;
        }
        
    }
}

#pragma mark - UICollectionView Delegate & DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FolderCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(collectionView == self.imageGroupView){
        cell.backgroundColor = [UIColor redColor];
        cell.title = [NSString stringWithFormat:@"%@", self.images[indexPath.row]];
    }else{
        cell.backgroundColor = [UIColor blueColor];
        cell.title = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == self.imageGroupView){
        return [self.images count];
    }else{
        return 5;
    }
}

@end
