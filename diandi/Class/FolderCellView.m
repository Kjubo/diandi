//
//  FolderCellView.m
//  diandi
//
//  Created by kjubo on 15/6/11.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "FolderCellView.h"

@interface FolderCellView ()
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *lbTitle;
@end

@implementation FolderCellView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor redColor];
        
        self.iconView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.iconView];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:self.bounds];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = [UIColor whiteColor];
        self.lbTitle.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.lbTitle];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    self.lbTitle.text = [title copy];
}

- (NSString *)title{
    return self.lbTitle.text;
}

@end
