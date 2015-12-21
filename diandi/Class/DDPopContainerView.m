//
//  DDPopContainerView.m
//  diandi
//
//  Created by kjubo on 15/10/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDPopContainerView.h"

@interface DDPopContainerView ()
@property (nonatomic, strong) UIView *maskerView;
@property (nonatomic, strong) UITableView *tbList;
@end

@implementation DDPopContainerView

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
        
        self.tbList = [UITableView new];
        self.tbList.separatorColor = [UIColor clearColor];
        self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tbList.backgroundColor = GS_COLOR_WHITE;
        [self addSubview:self.tbList];
        [self.tbList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.top.equalTo(self);
            make.height.mas_equalTo(@220);
        }];
        
        [RACObserve(self, hidden) subscribeNext:^(id x) {
            if([x boolValue]){
                [UIView animateWithDuration:0.2 animations:^{
                    self.tbList.top = -self.tbList.height;
                }completion:nil];
            }else{
                [self.superview bringSubviewToFront:self];
                [UIView animateWithDuration:0.2 animations:^{
                    self.tbList.top = 0;
                } completion:nil];
            }
        }];
    }
    return self;
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate{
    self.tbList.delegate = tableViewDelegate;
}

- (void)setTableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource{
    self.tbList.dataSource = tableViewDataSource;
}

- (id<UITableViewDelegate>)tableViewDelegate{
    return self.tbList.delegate;
}

- (id<UITableViewDataSource>)tableViewDataSource{
    return self.tbList.dataSource;
}

- (void)handleTapMaskerView{
    self.hidden = YES;
}

@end
