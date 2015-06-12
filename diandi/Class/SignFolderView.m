//
//  SignFolderView.m
//  diandi
//
//  Created by kjubo on 15/6/2.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "SignFolderView.h"
#import "FolderCellView.h"

@interface SignFolderView ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *folderGroupView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageGroupView;


@end

@implementation SignFolderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    for(int i = 0; i < 3; i++){
        FolderCellView *cell = [[FolderCellView alloc] initWithFrame:CGRectMake(5 + i * 100, 0, 90, 90)];
        cell.centerY = cell.height/2;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        pan.delegate = self;
        [cell addGestureRecognizer:pan];
        
        [self.imageGroupView addSubview:cell];
    }
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
    
    
    
    view.center = ptWillMoveTo;
    [sender setTranslation:CGPointZero inView:self.imageGroupView];
}




@end
