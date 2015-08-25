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
@end

@implementation DDSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.popAreaView = [DDPopAreaView new];
    [self.view addSubview:self.popAreaView];
    [self.popAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
