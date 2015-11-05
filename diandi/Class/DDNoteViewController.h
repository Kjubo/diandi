//
//  DDSpotViewController.h
//  diandi
//
//  Created by kjubo on 15/8/24.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDNoteViewType) {
    DDNoteView_Note = 1,
    DDNOteView_Spot = 2,
};

@interface DDNoteViewController : RootViewController
@property (nonatomic, readonly) DDNoteViewType type;
- (instancetype)initWithNoteViewType:(DDNoteViewType)type;
@end
