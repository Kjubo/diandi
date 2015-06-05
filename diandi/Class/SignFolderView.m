//
//  SignFolderView.m
//  diandi
//
//  Created by kjubo on 15/6/2.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "SignFolderView.h"

@interface SignFolderView ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;

@end

@implementation SignFolderView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    
}

@end
