//
//  ASPageView.m
//  gosheng3.0
//
//  Created by kjubo on 14/12/15.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPageView.h"

@interface ASPageView ()
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *images;
//图片items (NSString)
@property (nonatomic, strong) NSArray *items;
//自动翻页的时间 (0 表示不翻页)
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer *scrollTimer;
@property (nonatomic) NSInteger currentPage;
@end

@implementation ASPageView

- (id)init{
    if(self = [super init]){
        self.contentView = [[UIScrollView alloc] init];
        self.contentView.delegate = self;
        self.contentView.pagingEnabled = YES;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.bounces = NO;
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.bottom = self.height;
        self.pageControl.pageIndicatorTintColor = GS_COLOR_LIGHT;
        self.pageControl.currentPageIndicatorTintColor = GS_COLOR_GRAY;
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.offset(-10);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(@10);
        }];
        
        self.images = [NSMutableArray array];
        _currentPage = 1;
    }
    return self;
}

- (void)setItems:(NSArray *)items andTimeInterval:(NSTimeInterval)interval{
    [self clearTimer];
    _interval = interval;
    if([items count] <= 1){
        _items = [items copy];
    }else{
        NSMutableArray *arr = [NSMutableArray arrayWithArray:items];
        [arr addObject:[items firstObject]];
        [arr insertObject:[items lastObject] atIndex:0];
        _items = [arr copy];
    }
    [self refresh];
}

- (void)refresh{
    [self.contentView removeAllSubViews];
    UIImageView *lastView = nil;
    for(int i = 0; i < [self.items count]; i++){
        UIImageView *iv = [[UIImageView alloc] init];
        iv.userInteractionEnabled = YES;
        iv.backgroundColor = [UIColor clearColor];//设置了背景颜色
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_Image:)];
        [iv addGestureRecognizer:tap];
        iv.tag = i;
        [iv sd_setImageWithURL:[NSURL URLWithString:self.items[i]]];
        [self.contentView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            if(lastView){
                make.left.equalTo(lastView.mas_right);
            }else{
                make.left.equalTo(self.contentView);
            }
        }];
        lastView = iv;
    }
    if([self.items count] <= 3){
        self.pageControl.hidden = YES;
        self.contentView.scrollEnabled = NO;
    }else{
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = [self.items count] - 2;
        self.contentView.scrollEnabled = YES;
    }
    if([self.items  count] <= 3){
        [self.contentView setContentOffset:CGPointZero];
    }else{
        [self.contentView setContentOffset:CGPointMake(self.contentView.width, 0)];
    }
    if([self.items count] >= 3
       && self.interval > 0){
        [self clearTimer];
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
}

- (void)tap_Image:(UITapGestureRecognizer *)sender{
    NSInteger tag = sender.view.tag - 1;
    if (self.items.count == 1) {
        tag = sender.view.tag;
    }
    
    if(tag >= 0 && tag < [self.items count] - 2){
        if([self.delegate respondsToSelector:@selector(pageView:didSelected:)]){
            [self.delegate pageView:self didSelected:tag];
        }
    }
}

- (void)clearTimer{
    if(self.scrollTimer){
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)nextPage{
    self.currentPage++;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [self.contentView setContentOffset:CGPointMake(self.contentView.width * currentPage, 0) animated:YES];
    if(currentPage == 0){
        currentPage = [self.items count] - 2;
    }else if(currentPage == [self.items count] - 1){
        currentPage = 1;
    }
    _currentPage = currentPage;
    self.pageControl.currentPage = _currentPage - 1;
}

- (void)fixCurrentPage{
    NSInteger fixedPage = (NSInteger)(self.contentView.contentOffset.x / self.contentView.width + 0.5);
    if(fixedPage == [self.items count] - 1){
        fixedPage = 1;
        self.contentView.contentOffset = CGPointMake(fixedPage * self.contentView.width, 0);
    }else if(fixedPage == 0){
        fixedPage = [self.items count] - 2;
        self.contentView.contentOffset = CGPointMake(fixedPage * self.contentView.width, 0);
    }
    _currentPage = fixedPage;
    self.pageControl.currentPage = _currentPage - 1;
}

#pragma mark -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.scrollTimer setFireDate:[NSDate dateWithTimeInterval:self.interval sinceDate:[NSDate date]]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self fixCurrentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x/scrollView.width != self.currentPage){
        [self.contentView setContentOffset:CGPointMake(self.contentView.width * self.currentPage, 0) animated:NO];
    }
}
@end
