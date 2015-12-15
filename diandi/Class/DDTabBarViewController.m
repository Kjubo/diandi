//
//  DDTabBarViewController.m
//  diandi
//
//  Created by kjubo on 15/8/25.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "DDTabBarViewController.h"
#import "DDNoteViewController.h"
#import "DDUserCenterViewController.h"
#import "UITabBarItem+Universal.h"
#import "DDLoginViewController.h"

@interface DDTabBarViewController ()<UITabBarControllerDelegate, DDLoginViewControllerDelegate>
@property (nonatomic, strong)UINavigationController *ncMain;
@property (nonatomic, strong)UINavigationController *ncSpot;
@property (nonatomic, strong)UINavigationController *ncNote;
@end

@implementation DDTabBarViewController

- (id)init{
    if(self = [super init]){
        self.delegate = self;
        
        self.ncMain = [[UINavigationController alloc] initWithRootViewController:[DDUserCenterViewController new]];
        self.ncMain.tabBarItem =[UITabBarItem itemWithTitle:@"我" image:[UIImage imageNamed:@"ic_tab2"] selectedImage:[UIImage imageNamed:@"ic_tab2_hl"]];
        
        self.ncSpot = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
        self.ncSpot.tabBarItem =[UITabBarItem itemWithTitle:@"目的地" image:[UIImage imageNamed:@"ic_tab1"] selectedImage:[UIImage imageNamed:@"ic_tab1_hl"]];
        
        DDNoteViewController *noteViewController = [[DDNoteViewController alloc] initWithNoteViewType:DDNoteView_Spot];
        self.ncNote = [[UINavigationController alloc] initWithRootViewController:noteViewController];
        self.ncNote.tabBarItem = [UITabBarItem itemWithTitle:@"游记" image:[UIImage imageNamed:@"ic_tab0"] selectedImage:[UIImage imageNamed:@"ic_tab0_hl"]];
        
        [self setViewControllers:@[self.ncNote, self.ncSpot, self.ncMain]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)openLoginViewController{
    UIViewController *rootVc = self.selectedViewController;
    DDLoginViewController *loginVc = [DDLoginViewController new];
    loginVc.delegate = self;
    [rootVc presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVc] animated:YES completion:nil];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if(viewController == self.ncSpot){
        [self openLoginViewController];
        return NO;
    }
    return YES;
}

#pragma mark - DDLoginViewControllerDelegate
- (void)ddLoginViewControllerCancel{
    [self.selectedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)ddLoginViewControllerVerify{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
