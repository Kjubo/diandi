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
        self.clipsToBounds = YES;
        [super setHidden:YES];
        //透明遮罩层
        self.maskerView = [UIView new];
        self.maskerView.backgroundColor = GS_COLOR_BLACK;
        self.maskerView.alpha = 0.4;
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
        [self.contentView addSubview:self.linkageView];
        [self.linkageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.gradeView.mas_right);
            make.top.height.equalTo(self.contentView);
            make.width.mas_equalTo(DF_WIDTH);
        }];
        
        [RACObserve(self, hidden) subscribeNext:^(id x) {
            if([x boolValue]){
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentView.top = -self.contentView.height;
                }completion:nil];
            }else{
                [self.superview bringSubviewToFront:self];
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentView.top = 0;
                } completion:nil];
            }
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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView != self.contentView) return;
    if(scrollView.contentOffset.x <= 0){
        scrollView.scrollEnabled = NO;
        self.linkageView.selectedStage1Index = -1;
    }else{
        scrollView.scrollEnabled = YES;
    }
}

#pragma mark - DDGradeViewDelegate
- (void)ddGradeView:(DDGradeView *)gradeView didTagSelected:(DDArea *)data{
    if([self.delegate respondsToSelector:@selector(ddPopAreaViewDidSelected:)]){
        [self.delegate ddPopAreaViewDidSelected:data];
    }
    self.hidden = YES;
}

- (void)ddGradeView:(DDGradeView *)gradeView didTableSelected:(DDArea *)data{
    self.linkageView.data = data;
    [self.contentView setContentOffset:CGPointMake(DF_WIDTH, 0) animated:YES];
    self.contentView.scrollEnabled = YES;
}

#pragma mark - DDLinkageViewDelegate
- (void)ddLinkageView:(DDLinkageView *)linkageView didSelected:(NSIndexPath *)indexPath{
    DDArea *parent = self.linkageView.data.list[indexPath.section];
    DDArea *data = parent.list[indexPath.row];
    if([self.delegate respondsToSelector:@selector(ddPopAreaViewDidSelected:)]){
        [self.delegate ddPopAreaViewDidSelected:data];
    }
    self.hidden = YES;
}


@end
