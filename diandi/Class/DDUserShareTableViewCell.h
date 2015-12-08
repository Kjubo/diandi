//
//  DDUserShareTableViewCell.h
//  diandi
//
//  Created by kjubo on 15/12/7.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDShareInfoModel.h"
@interface DDUserShareTableViewCell : UITableViewCell

- (void)setDataModel:(DDShareInfoModel *)data;
+ (CGFloat)heightForDetail:(NSString *)detail;
@end
