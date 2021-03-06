//
//  DDPopGradeView.h
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDArea.h"


@class DDGradeView;
@protocol DDGradeViewDelegate <NSObject>
@optional
- (void)ddGradeView:(DDGradeView *)gradeView didTagSelected:(DDArea *)data;
- (void)ddGradeView:(DDGradeView *)gradeView didTableSelected:(DDArea *)data;
@end

@interface DDGradeView : UIView

@property (nonatomic, assign) id<DDGradeViewDelegate> delegate;

@end
