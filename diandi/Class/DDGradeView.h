//
//  DDPopGradeView.h
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPopTags        @[@"上海", @"突尼斯", @"拜占庭", @"捷克斯诺伐克", @"布达拉宫", @"土耳其帝国", @"拜占庭"]
#define kPopTagColor    @[HEXRGBCOLOR(0xC2185B), HEXRGBCOLOR(0x4CAF50), HEXRGBCOLOR(0xE91E63), HEXRGBCOLOR(0x2196F3), HEXRGBCOLOR(0x4CAF50), HEXRGBCOLOR(0x009688), HEXRGBCOLOR(0x7B1FA2)]

@class DDGradeView;
@protocol DDGradeViewDelegate <NSObject>
@optional
- (void)ddGradeView:(DDGradeView *)gradeView didTagSelected:(NSInteger)index;
- (void)ddGradeView:(DDGradeView *)gradeView didTableSelected:(NSInteger)index;
@end

@interface DDGradeView : UIView

@property (nonatomic, assign) id<DDGradeViewDelegate> delegate;

@end
