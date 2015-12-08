//
//  DDTopMenuView.m
//  diandi
//
//  Created by kjubo on 15/10/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDTopMenuView.h"
#import "DDMenuButton.h"

@interface DDTopMenuView()
@property (nonatomic, strong) UIButton *btnSearch;          //搜索
@property (nonatomic, strong) DDMenuButton *btnArea;        //区域
@property (nonatomic, strong) DDMenuButton *btnType;        //分类
@property (nonatomic, strong) DDMenuButton *btnSort;        //排序

@property (nonatomic, weak) DDMenuButton *btnSelected;    //当前选中
@end

@implementation DDTopMenuView

- (instancetype)init{
    if(self = [super init]){
        self.btnSearch = [UIButton new];
        [self.btnSearch setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
        [self.btnSearch addTarget:self action:@selector(btnClick_search:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSearch];
        [self.btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 44));
            make.bottom.right.equalTo(self);
        }];
        
        CGFloat buttonWidth = (DF_WIDTH - 42)/3.0;
        
        self.btnArea = [DDMenuButton new];
        self.btnArea.title = @"区域";
        self.btnArea.tag = 0;
        [self.btnArea addTarget:self action:@selector(btnClick_menu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnArea];
        [self.btnArea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonWidth, 44.0));
            make.left.bottom.equalTo(self);
        }];
        
        UIView *line0 = [UIView new];
        line0.backgroundColor = GS_COLOR_WHITE;
        [self addSubview:line0];
        [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnArea.mas_right);
            make.top.equalTo(self.btnArea).offset(10);
            make.bottom.equalTo(self.btnArea).offset(-10);
            make.width.mas_equalTo(@1);
        }];
        
        self.btnType = [DDMenuButton new];
        self.btnType.title = @"分类";
        self.btnType.tag = 1;
        [self.btnType addTarget:self action:@selector(btnClick_menu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnType];
        [self.btnType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonWidth, 44.0));
            make.bottom.equalTo(self);
            make.left.equalTo(self.btnArea.mas_right);
        }];
        
        UIView *line1 = [UIView new];
        line1.backgroundColor = GS_COLOR_WHITE;
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnType.mas_right);
            make.top.equalTo(self.btnType).offset(10);
            make.bottom.equalTo(self.btnType).offset(-10);
            make.width.mas_equalTo(@1);
        }];
        
        self.btnSort = [DDMenuButton new];
        self.btnSort.title = @"排序";
        self.btnSort.tag = 2;
        [self.btnSort addTarget:self action:@selector(btnClick_menu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSort];
        [self.btnSort mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonWidth, 44.0));
            make.bottom.equalTo(self);
            make.left.equalTo(self.btnType.mas_right);
        }];
    }
    return self;
}

- (void)btnClick_menu:(DDMenuButton *)sender{
    if(sender == self.btnSelected){
        self.btnSelected.opened = NO;
        self.btnSelected = nil;
        if([self.delegate respondsToSelector:@selector(ddTopMenuViewDidCancelSelected)]){
            [self.delegate ddTopMenuViewDidCancelSelected];
        }
        return;
    }else{
        if(self.btnSelected){
            self.btnSelected.opened = NO;
        }
        self.btnSelected = sender;
        sender.opened = YES;
        if([self.delegate respondsToSelector:@selector(ddTopMenuViewDidSelected:)]){
            [self.delegate ddTopMenuViewDidSelected:sender.tag];
        }
    }
}

- (void)btnClick_search:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(ddTopMenuViewDidSearch)]){
        [self.delegate ddTopMenuViewDidSearch];
    }
}

@end
