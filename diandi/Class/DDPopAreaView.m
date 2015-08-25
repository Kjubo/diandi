//
//  DDPopAreaView.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDPopAreaView.h"
#import "DDGradeView.h"
#import "DDLinkageView.h"

@interface DDPopAreaView ()<DDGradeViewDelegate, DDLinkageViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIView *maskerView;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) DDGradeView *gradeView;
@property (nonatomic, strong) DDLinkageView *linkageView;
@end

@implementation DDPopAreaView

-(instancetype)init{
    if (self = [super init]) {
        // Initialization code
        //透明遮罩层
        self.maskerView = [UIView new];
        self.maskerView.backgroundColor = GS_COLOR_BLACK;
        self.maskerView.alpha = 0.5;
        UITapGestureRecognizer *tapMaskerView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMaskerView)];
        [self.maskerView addGestureRecognizer:tapMaskerView];
        [self addSubview:self.maskerView];
        [self.maskerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.contentView = [UIScrollView new];
        self.contentView.backgroundColor = GS_COLOR_WHITE;
        self.contentView.pagingEnabled = YES;
        self.contentView.scrollEnabled = NO;
        self.contentView.delegate = self;
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 200, 0));
        }];
        
        self.gradeView = [DDGradeView new];
        self.gradeView.delegate = self;
        [self.contentView addSubview:self.gradeView];
        [self.gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.equalTo(self.contentView);
            make.width.mas_equalTo(DF_WIDTH);
        }];
        
        self.linkageView = [DDLinkageView new];
        self.linkageView.delegate = self;
        self.linkageView.hidden = YES;
        [self.contentView addSubview:self.linkageView];
        [self.linkageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.gradeView.mas_right);
            make.top.height.equalTo(self.contentView);
            make.width.mas_equalTo(DF_WIDTH);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.contentSize = CGSizeMake(DF_WIDTH * 2.0, self.contentView.height);
}

- (void)handleTapMaskerView{
    self.hidden = YES;
}

- (void)setHidden:(BOOL)hidden{
    if(self.hidden == hidden) return;
    if(hidden){
        self.maskerView.alpha = 0.5;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.top = -self.contentView.height;
            self.maskerView.alpha = 0;
        }completion:^(BOOL finished) {
            [super setHidden:YES];
        }];
    }else{
        [self.contentView setContentOffset:CGPointZero];
        [self.contentView setScrollEnabled:NO];
        [self.superview bringSubviewToFront:self.contentView];
        [super setHidden:NO];
        self.maskerView.hidden = NO;
        self.maskerView.alpha = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.maskerView.alpha = 0.5;
            self.contentView.top = 0;
        } completion:nil];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.contentOffset.x < DF_WIDTH){
        scrollView.scrollEnabled = NO;
    }else{
        scrollView.scrollEnabled = YES;
    }
}

#pragma mark - DDGradeViewDelegate
- (void)ddGradeView:(DDGradeView *)gradeView didTagSelected:(NSInteger)index{
    self.hidden = YES;
}

- (void)ddGradeView:(DDGradeView *)gradeView didTableSelected:(NSInteger)index{
    [self.contentView setContentOffset:CGPointMake(DF_WIDTH, 0) animated:YES];
    self.contentView.scrollEnabled = YES;
}

#pragma mark - DDLinkageViewDelegate
- (void)ddLinkageView:(DDLinkageView *)linkageView didSelected:(NSIndexPath *)indexPath{
    self.hidden = YES;
}


@end
