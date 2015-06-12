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
@end

@implementation FolderCellView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor redColor];
        
        self.iconView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.iconView];
        
    }
    return self;
}




@end
