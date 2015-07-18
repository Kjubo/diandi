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
#import "DPhoto.h"

@interface SignFolderView ()<UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageGroupView;
@property (weak, nonatomic) IBOutlet UICollectionView *folderGroupView;
@property (nonatomic, strong) FolderLayout *imagesLayout;
@property (nonatomic, strong) UICollectionViewCell *selectedCell;
@property (nonatomic, strong) UIImageView *movingCellImage;
@property (nonatomic, strong) NSIndexPath *selectedImagePath;
@property (nonatomic, strong) NSIndexPath *selectedFolderPath;
@property (nonatomic, strong) NSIndexPath *hoverFolderPath;
@property (nonatomic, weak) NSMutableArray *images;
@property (nonatomic) BOOL isDragging;

@end

@implementation SignFolderView

static NSString *identifierCell = @"FolderCell";
static NSString *identifierFoot = @"identifierFoot";
- (void)awakeFromNib{
    [super awakeFromNib];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    [self.imageGroupView registerClass:[FolderCellView class] forCellWithReuseIdentifier:identifierCell];
    [self.folderGroupView registerClass:[FolderCellView class] forCellWithReuseIdentifier:identifierCell];
    self.bgView.hidden = YES;
    self.imageGroupView.hidden = YES;
}

- (void)setOpened:(BOOL)opened{
    if(_opened == opened) return;
    _opened = opened;
    self.imageGroupView.hidden = !_opened;
    self.bgView.hidden = !_opened;
}

- (void)setData:(NSMutableArray *)data{
    _data = data;
    [self.folderGroupView reloadData];
}

- (void)handleTap:(UITapGestureRecognizer *)sender{
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
    CGPoint movePoint = [panRecognizer locationInView:self];    //相对整个层的位置
    CGPoint imageGroupPoint = [panRecognizer locationInView:self.imageGroupView];   //相对图片层的位置
    CGPoint folderGroupPoint = [panRecognizer locationInView:self.folderGroupView]; //相对组层的位置
    NSIndexPath *imageGroupIndexPath = [self.imageGroupView indexPathForItemAtPoint:imageGroupPoint];
    NSIndexPath *folderGroupIndexPath = [self.folderGroupView indexPathForItemAtPoint:folderGroupPoint];

    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        if(!imageGroupIndexPath) return;
        _isDragging = YES;
        self.selectedCell = [self.imageGroupView cellForItemAtIndexPath:imageGroupIndexPath];
        UIGraphicsBeginImageContext(self.selectedCell.bounds.size);
        [self.selectedCell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.movingCellImage = [[UIImageView alloc] initWithImage:cellImage];
        [self.movingCellImage setCenter:movePoint];
        [self.movingCellImage setAlpha:0.75f];
        [self addSubview:self.movingCellImage];
        
        self.selectedCell.hidden = YES;
        self.selectedImagePath = [imageGroupIndexPath copy];
        
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        if(self.isDragging){
            [self.movingCellImage setCenter:movePoint];
            self.hoverFolderPath = folderGroupIndexPath;
        }
    } else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        if(self.isDragging){
            self.hoverFolderPath = nil;
            self.selectedCell.hidden = NO;
            [self.movingCellImage removeFromSuperview];
            if(imageGroupIndexPath){
                id item = self.images[self.selectedImagePath.row];
                if(item){
                    [self.images removeObject:item];
                    [self.images insertObject:item atIndex:imageGroupIndexPath.row];
                }
            }else if(folderGroupIndexPath){
                if(folderGroupIndexPath != self.hoverFolderPath){
                    id item = self.images[self.selectedImagePath.row];
                    if(item){
                        [self.images removeObject:item];
                        [self.data[folderGroupIndexPath.row] addObject:item];
                        [self.folderGroupView reloadData];
                    }
                }
            }
            [self.imageGroupView reloadData];
            self.isDragging = NO;
        }
        
    }
}

- (void)setHoverFolderPath:(NSIndexPath *)hoverFolderPath{
    if([_hoverFolderPath isEqual:hoverFolderPath]) return;
    if(_hoverFolderPath){
        UICollectionViewCell *cell = [self.folderGroupView cellForItemAtIndexPath:_hoverFolderPath];
        [UIView animateWithDuration:0.3 animations:^{
            cell.transform = CGAffineTransformIdentity;
            cell.alpha = 1.0;
        }];
    }
    _hoverFolderPath = hoverFolderPath;
    if(_hoverFolderPath){
        FolderCellView *cell = (FolderCellView *)[self.folderGroupView cellForItemAtIndexPath:_hoverFolderPath];
        [UIView animateWithDuration:0.3 animations:^{
            cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
            cell.alpha = 0.5;
        }];
    }
}

#pragma mark - UICollectionView Delegate & DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FolderCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    if(collectionView == self.imageGroupView){
        DPhoto *item = self.images[indexPath.row];
        cell.title = [NSString stringWithFormat:@"%@", item.uri];
        cell.image = [UIImage imageWithData:item.image];
    }else{
        if([self.data[indexPath.row] count] > 0){
            DPhoto *item = self.data[indexPath.row][0];
            cell.image = [UIImage imageWithData:item.image];
        }
        cell.title = [NSString stringWithFormat:@"共%@张", @([self.data[indexPath.row] count])];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == self.imageGroupView){
        return [self.images count];
    }else if(collectionView == self.folderGroupView){
        return [self.data count];
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.folderGroupView){
        if([self.selectedFolderPath isEqual:indexPath]){
            self.selectedFolderPath = nil;
            self.opened = NO;
        }else{
            self.selectedFolderPath = [indexPath copy];
            self.images = self.data[indexPath.row];
            [self.imageGroupView reloadData];
            self.opened = YES;
        }
    }
}

@end
