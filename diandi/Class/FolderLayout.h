//
//  FolderLayout.h
//  diandi
//
//  Created by kjubo on 15/6/12.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderLayout : UICollectionViewLayout
@property (nonatomic, readonly) NSInteger cellCount;
@property (nonatomic, readonly) CGSize cellSize;
@property (nonatomic, readonly) CGFloat cellMargin;
@end
