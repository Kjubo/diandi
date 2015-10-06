//
//  ASWaitingView.m
//  astro
//
//  Created by kjubo on 14-1-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASWaitingView.h"

@interface ASWaitingView()
//蒙皮图片
@property (nonatomic, retain) UIView *maskview;
//loading主界面
@property (nonatomic, retain) UIImageView *loadview;
//loading
@property (nonatomic, strong) UIImageView *ivActivety;
//标题内容
@property (nonatomic, retain) UILabel *title;

//loading主界面最大宽度
@property CGFloat maxLoadingViewWidth;
@end

@implementation ASWaitingView

- (id)initWithBaseViewController:(UIViewController *)vc
{
    self = [super initWithFrame:vc.view.frame];
    if (self) {
        static NSArray *animationImages = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableArray *images = [NSMutableArray array];
            for(int i = 0;  i <= 10; i++){
                [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ic_group_%@", @(i)]]];
            }
            animationImages = [NSArray arrayWithArray:images];
        });
        
        // Initialization code
        self.maxLoadingViewWidth = self.width * 0.5;
        
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        self.viewController = vc;
        [self.viewController.view addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.viewController.view);
        }];
        
        self.maskview = [UIView new];
        self.maskview.backgroundColor = [UIColor blackColor];
        self.maskview.alpha = 0.3;
        [self addSubview:self.maskview];
        [self.maskview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.loadview = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.loadview.backgroundColor = GS_COLOR_BLACK;
        self.loadview.layer.cornerRadius = 8;
        [self addSubview:self.loadview];

        self.ivActivety = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 41)];
        
        self.ivActivety.animationImages = animationImages;
        self.ivActivety.animationDuration = 0.8;
        self.ivActivety.animationRepeatCount = 0;
        [self.loadview addSubview:self.ivActivety];
        
        self.title = [[UILabel alloc] init];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.lineBreakMode = NSLineBreakByCharWrapping;
        self.title.textColor = GS_COLOR_WHITE;
        self.title.font = [UIFont gs_font:NSAppFontM];
        [self.loadview addSubview:self.title];
    }
    return self;
}

- (void)showWating:(NSString *)tips{
    if([tips length] == 0){
        tips = kDefalutLoadingText;
    }
    
    self.title.text = tips;
    self.title.size = [self.title.text boundingRectWithSize:CGSizeMake(self.maxLoadingViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.title.font} context:nil].size;
    self.loadview.size = CGSizeMake(self.title.width + 120, self.title.height + 60);
    self.loadview.center = CGPointMake(self.width * 0.5, self.height * 0.4);
    
    self.ivActivety.left = 20;
    self.ivActivety.centerY = self.loadview.height * 0.5;
    self.title.left = self.ivActivety.right + 10;
    self.title.centerY = self.ivActivety.centerY;
    
    self.hidden = NO;
    [self.ivActivety startAnimating];
    
    [self.viewController.view bringSubviewToFront:self];
    self.loadview.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    [UIView animateWithDuration:0.2 animations:^{
        self.loadview.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideWaiting{
    [UIView animateWithDuration:0.2 animations:^{
        self.loadview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.ivActivety stopAnimating];
        self.hidden = YES;
    }];
}


@end
