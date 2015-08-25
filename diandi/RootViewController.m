//
//  RootViewController.m
//  MyShoping
//
//  Created by boyu on 14-3-1.
//  Copyright (c) 2014年 boyu. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
@interface RootViewController ()
@property (nonatomic, readonly) AppDelegate *shareDelegate;
@end

@implementation RootViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = GS_COLOR_WHITE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

+ (AppDelegate *)shareDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (NSManagedObjectContext *)managedObjectContext{
    return [[self shareDelegate] managedObjectContext];
}

+ (NSManagedObjectModel *)managedObjectModel{
    return [[self shareDelegate] managedObjectModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
