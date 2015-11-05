//
//  DDMddListModel.h
//  diandi
//
//  Created by kjubo on 15/11/5.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "DDArea.h"
@interface DDMddListModel : JSONModel
@property (nonatomic, strong) NSArray<DDArea, Optional> *mddlist;
@property (nonatomic, strong) NSArray<DDArea, Optional> *hotplace;
@property (nonatomic, strong) NSArray<Optional> *hotsearch;
@end
