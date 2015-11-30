//
//  DDSpotDescViewController.m
//  diandi
//
//  Created by kjubo on 15/11/30.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotDescViewController.h"

@interface DDSpotDescViewController ()
@property (nonatomic, strong) UILabel *lbDesc;
@end

@implementation DDSpotDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lbDesc  = [UILabel new];
    self.lbDesc.backgroundColor = [UIColor clearColor];
    self.lbDesc.textColor = GS_COLOR_DARKGRAY;
    self.lbDesc.font = [UIFont gs_font:NSAppFontM];
    self.lbDesc.lineBreakMode = NSLineBreakByWordWrapping;
    self.lbDesc.numberOfLines = 0;
    self.lbDesc.preferredMaxLayoutWidth = DF_WIDTH - 20;
    [self.view addSubview:self.lbDesc];
    [self.lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
}

- (void)setDesc:(NSString *)desc{
    self.lbDesc.text = [desc copy];
}

- (NSString *)desc{
    return self.lbDesc.text;
}

@end
