//
//  DDNoteModel.h
//  diandi
//
//  Created by kjubo on 15/11/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@interface DDNoteModel : JSONModel

@property (nonatomic) NSInteger travelNoteId;
@property (nonatomic, strong) NSString *previewImage;
@property (nonatomic, strong) NSString *avaterName;
@property (nonatomic, strong) NSString *avaterImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *suitperson;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic) NSInteger favor;

@end
