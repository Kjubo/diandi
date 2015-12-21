//
//  DDTopMenuView.h
//  diandi
//
//  Created by kjubo on 15/10/6.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDTopMenuType){
    DDTopMenuTypeNone = 0,
    DDTopMenuTypeArea,
    DDTopMenuTypeCategory,
    DDTopMenuTypeSort,
    DDTopMenuTypeSearch,
};

@protocol DDTopMenuViewDelegate <NSObject>

@optional
- (void)ddTopMenuViewDidSelected:(DDTopMenuType)type;
- (void)ddTopMenuViewDidCancel:(DDTopMenuType)type;
@end

@interface DDTopMenuView : UIView
@property (nonatomic) DDTopMenuType menuType;
@property (nonatomic, assign) id<DDTopMenuViewDelegate> delegate;
@end
