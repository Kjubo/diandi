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
@property (nonatomic, strong) NSArray *buttons;             //所有按钮
@end

@implementation DDTopMenuView

- (instancetype)init{
    if(self = [super init]){
        self.btnSearch = [UIButton new];
        self.btnSearch.tag = DDTopMenuTypeSearch;
        [self.btnSearch setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
        [self.btnSearch addTarget:self action:@selector(btnClick_menu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSearch];
        [self.btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 44));
            make.bottom.right.equalTo(self);
        }];
        
        CGFloat buttonWidth = (DF_WIDTH - 42)/3.0;
        
        self.btnArea = [DDMenuButton new];
        self.btnArea.title = @"区域";
        self.btnArea.tag = DDTopMenuTypeArea;
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
        self.btnType.tag = DDTopMenuTypeCategory;
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
        self.btnSort.tag = DDTopMenuTypeSort;
        [self.btnSort addTarget:self action:@selector(btnClick_menu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSort];
        [self.btnSort mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonWidth, 44.0));
            make.bottom.equalTo(self);
            make.left.equalTo(self.btnType.mas_right);
        }];
        
        _menuType = DDTopMenuTypeNone;
        self.buttons = @[[UIButton new], self.btnArea, self.btnType, self.btnSort, self.btnSearch];
        
    }
    return self;
}

- (void)setMenuType:(DDTopMenuType)menuType{
    if(_menuType == menuType) return;
    
    if(_menuType != DDTopMenuTypeNone
       && _menuType != DDTopMenuTypeSearch){
        DDMenuButton *btn = self.buttons[_menuType];
        btn.opened = NO;
    }
    
    _menuType = menuType;
    if(_menuType != DDTopMenuTypeNone
       && _menuType != DDTopMenuTypeSearch){
        DDMenuButton *btn = self.buttons[_menuType];
        btn.opened = YES;
    }
}

- (void)btnClick_menu:(DDMenuButton *)sender{
    if(sender.tag == self.menuType){
        if([self.delegate respondsToSelector:@selector(ddTopMenuViewDidCancel:)]){
            [self.delegate ddTopMenuViewDidCancel:self.menuType];
        }
        self.menuType = DDTopMenuTypeNone;
    }else{
        if([self.delegate respondsToSelector:@selector(ddTopMenuViewDidCancel:)]){
            [self.delegate ddTopMenuViewDidCancel:self.menuType];
        }
        self.menuType = sender.tag;
        if([self.delegate respondsToSelector:@selector(ddTopMenuViewDidSelected:)]){
            [self.delegate ddTopMenuViewDidSelected:self.menuType];
        }
    }
}

@end
