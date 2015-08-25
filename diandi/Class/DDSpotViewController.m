//
//  DDSpotViewController.m
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDSpotViewController.h"
#import "DDPopAreaView.h"
#import "DDGradeView.h"
@interface DDSpotViewController ()
@property (nonatomic, strong) DDPopAreaView *popAreaView;
@property (nonatomic, strong) DDGradeView *gradeView;
@end

@implementation DDSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    self.popAreaView = [DDPopAreaView new];
    [self.view addSubview:self.popAreaView];
    [self.popAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    self.gradeView = [DDGradeView new];
//    [self.view addSubview:self.gradeView];
//    [self.gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.view);
//        make.height.mas_equalTo(@300);
//    }];
}

- (void)handleTap:(UITapGestureRecognizer *)sender{
    self.popAreaView.hidden = NO;
}

@end
