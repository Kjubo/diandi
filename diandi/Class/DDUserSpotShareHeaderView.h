//
//  DDUserSpotShareHeaderView.h
//  diandi
//
//  Created by kjubo on 15/12/10.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSpotModel.h"
@interface DDUserSpotShareHeaderView : UITableViewHeaderFooterView
- (void)setDataModel:(DDSpotModel *)data showArrowLine:(BOOL)showTag;
@property (nonatomic, readonly) DDSpotModel *spotModel;
@end
