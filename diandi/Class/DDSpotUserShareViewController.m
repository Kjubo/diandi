//
//  DDSpotUserShareViewController.m
//  diandi
//
//  Created by kjubo on 15/12/4.
//  Copyright © 2015年 kjubo. All rights reserved.
//

#import "DDSpotUserShareViewController.h"
#import "DDUserShareTableViewCell.h"
#import "MJRefresh.h"
#import "AHKActionSheet.h"
#import "DDCustomShareInfoModel.h"
#import "UITextView+Placeholder.h"

@interface DDSpotUserShareViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISegmentedControl *segType;
@property (nonatomic, strong) UILabel *lbSpotName;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIButton *btnShareType;
@property (nonatomic, strong) UITextView *tvShareContent;
@property (nonatomic, strong) UITableView *tbShareInfo;
@property (nonatomic, strong) AHKActionSheet *actShareType;

@property (nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic) BOOL isEditing;
@property (nonatomic) DDShareInfoType shareType;
@end

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@implementation DDSpotUserShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segType = [[UISegmentedControl alloc] initWithItems:@[@"我的分享", @"我的收藏"]];
    self.segType.selectedSegmentIndex = 0;
    self.segType.size = CGSizeMake(140, 30);
    self.segType.tintColor = GS_COLOR_WHITE;
    [self.segType setTitleTextAttributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontS]} forState:UIControlStateNormal];
    [self.segType setTitleTextAttributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontS]} forState:UIControlStateHighlighted];
    [self.segType addTarget:self action:@selector(segment_changed:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segType;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_eye"]];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 14));
        make.top.equalTo(self.view).offset(14);
        make.left.equalTo(self.view).offset(15);
    }];
    
    self.lbSpotName = [UILabel new];
    self.lbSpotName.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lbSpotName.backgroundColor = [UIColor clearColor];
    self.lbSpotName.textColor = GS_COLOR_BLACK;
    self.lbSpotName.font = [UIFont gs_font:NSAppFontM];
    [self.view addSubview:self.lbSpotName];
    [self.lbSpotName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(icon);
    }];
    
    self.headerView = [self newHeaderView];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbSpotName.mas_bottom).offset(14);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    
    self.editView = [self newEditView];
    self.editView.hidden = YES;
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@100);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    self.tbShareInfo = [UITableView new];
    self.tbShareInfo.backgroundColor = GS_COLOR_WHITE;
    self.tbShareInfo.delegate = self;
    self.tbShareInfo.dataSource = self;
    self.tbShareInfo.separatorColor = [UIColor clearColor];
    self.tbShareInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbShareInfo registerClass:[DDUserShareTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    [self.tbShareInfo addFooterWithTarget:self action:@selector(loadMore)];
    [self.view addSubview:self.tbShareInfo];
    [self.tbShareInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.actShareType = [AHKActionSheet new];
    self.actShareType.cancelButtonHeight = 54;
    self.actShareType.cancelButtonTitle = @"取消";
    self.actShareType.automaticallyTintButtonImages = @NO;
    self.actShareType.animationDuration = 0.2;
    self.actShareType.title = @"分享类型";
    self.actShareType.titleTextAttributes = @{NSFontAttributeName : [UIFont gs_font:NSAppFontM]};
    self.actShareType.selectedBackgroundColor = GS_COLOR_MAIN;
    for(int i = 0; i < [kShareTypeTitles count]; i++){
        __block __typeof(self) sl = self;
        [self.actShareType addButtonWithTitle:kShareTypeTitles[i] image:[UIImage imageNamed:[NSString stringWithFormat:@"ic_share_%@", kShareTypeIconNames[i]]] type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
            [sl setShareType:i + 1];
        }];
    }
    
    _isEditing = NO;
    self.dataList = [NSMutableArray array];
    [self loadMore];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lbSpotName.text = [self.spotModel.title copy];
}

- (void)hideKeyBoard{
    [self.tvShareContent resignFirstResponder];
}

- (void)setShareType:(DDShareInfoType)shareType{
    _shareType = shareType;
    if(shareType == DDShareInfoNone){
        [self.btnShareType setImage:[UIImage imageNamed:@"ic_share_none"] forState:UIControlStateNormal];
    }else{
        [self.btnShareType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_share_%@", kShareTypeIconNames[shareType - 1]]] forState:UIControlStateNormal];
    }
}

- (void)setIsEditing:(BOOL)isEditing{
    if(_isEditing == isEditing) return;
    _isEditing = isEditing;
    self.btnAdd.hidden = _isEditing;
    self.btnCancel.hidden = !_isEditing;
    self.btnSubmit.hidden = !_isEditing;
    self.editView.hidden = !_isEditing;
    if(_isEditing){
        [self.tbShareInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.editView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }else{
        self.shareType = DDShareInfoNone;
        self.tvShareContent.text = nil;
        [self hideKeyBoard];
        [self.tbShareInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)segment_changed:(UISegmentedControl *)sender{
    self.pageIndex = 0;
    [self loadMore];
}

- (void)loadMore{
    NSString *uri = nil;
    if(self.segType.selectedSegmentIndex == 0){
        uri = @"api/mypllist.php";
    }else{
        uri = @"api/myfavorpllist.php";
    }
    if(self.pageIndex == 0){
        [self loadingShow];
    }
    [HttpUtil load:uri params:@{@"poi_uuid" : self.spotModel.uuid,
                                @"pagenum" : @(self.pageIndex)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self.tbShareInfo footerEndRefreshing];
            if(succ){
                NSError *error;
                NSArray *lst = [DDShareInfoModel arrayOfModelsFromDictionaries:json error:&error];
                if([lst count] > 0){
                    if(self.pageIndex == 0){
                        [self.dataList removeAllObjects];
                    }
                    [self.dataList addObjectsFromArray:lst];
                    self.pageIndex = [self.dataList count];
                    self.tbShareInfo.footerHidden = [json[@"islast"] boolValue];
                    [self.tbShareInfo reloadData];
                }
            }
            [self loadingHidden];
        }];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDUserShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    DDShareInfoModel *item = self.dataList[indexPath.row];
    [cell setDataModel:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDShareInfoModel *item = self.dataList[indexPath.row];
    return [DDUserShareTableViewCell heightForDetail:item.content];
}

#pragma mark - UIButton Click
- (void)btnClick_beginEdit{
    self.isEditing = YES;
}

- (void)btnClick_endEdit{
    self.isEditing = NO;
}

- (void)btnClick_submit{
    if([self.tvShareContent.text length] <= 0){
        [RootViewController showAlert:@"填写评论内容"];
        return;
    }
    
    if(self.shareType == DDShareInfoNone){
        [RootViewController showAlert:@"请选择评论类型"];
        return;
    }
    [self loadingShow];
    NSString *content = [self.tvShareContent.text copy];
    [HttpUtil post:@"apiupdate/newuserpl.php"
            params:@{@"poi_uuid" : self.spotModel.uuid,
                     @"type" : @(self.shareType),
                     @"content" : content}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                
            }else{
                [RootViewController showAlert:message];
            }
            [self loadingHidden];
        }];
}

- (void)btnClick_changeShareType{
    [self.actShareType show];
}

#pragma mark - view init
- (UIView *)newEditView{
    UIView *view = [UIView new];
    view.backgroundColor = GS_COLOR_WHITE;
    
    UIView *line = [UIView new];
    line.backgroundColor = GS_COLOR_LIGHT;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(view);
        make.height.mas_equalTo(@1);
    }];
    
    self.btnShareType = [UIButton new];
    [self.btnShareType addTarget:self action:@selector(btnClick_changeShareType) forControlEvents:UIControlEventTouchUpInside];
    [self.btnShareType setImage:[UIImage imageNamed:@"ic_share_none"] forState:UIControlStateNormal];
    self.btnShareType.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [view addSubview:self.btnShareType];
    [self.btnShareType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.left.equalTo(view).offset(10);
    }];
    
    self.tvShareContent = [UITextView new];
    self.tvShareContent.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"添加我的分享~" attributes:@{NSFontAttributeName : [UIFont gs_font:NSAppFontM], NSForegroundColorAttributeName : GS_COLOR_LIGHTGRAY}];
    self.tvShareContent.backgroundColor = [UIColor clearColor];
    self.tvShareContent.font = [UIFont gs_font:NSAppFontM];
    [view addSubview:self.tvShareContent];
    [self.tvShareContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnShareType);
        make.left.equalTo(self.btnShareType.mas_right).offset(10);
        make.bottom.equalTo(view).offset(-10);
        make.right.equalTo(view).offset(-10);
    }];
    
    return view;
}

- (UIView *)newHeaderView{
    CGSize buttonSize = CGSizeMake(50, 20);
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = GS_COLOR_WHITE;
    
    UILabel *lbPrefix = [UILabel new];
    lbPrefix.backgroundColor = [UIColor clearColor];
    lbPrefix.textColor = GS_COLOR_BLACK;
    lbPrefix.font = [UIFont gs_font:NSAppFontM];
    lbPrefix.text = @"我的分享";
    [headerView addSubview:lbPrefix];
    [lbPrefix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView).insets(UIEdgeInsetsMake(0, 20, 0, 180));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = GS_COLOR_LIGHT;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headerView);
        make.height.mas_equalTo(@1);
    }];
    
    line = [UIView new];
    line.backgroundColor = GS_COLOR_LIGHT;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(headerView);
        make.height.mas_equalTo(@1);
    }];
    
    self.btnAdd = [self newHeaderButton:@"新增"];
    [self.btnAdd addTarget:self action:@selector(btnClick_beginEdit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.btnAdd];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-10);
    }];
    
    self.btnCancel = [self newHeaderButton:@"取消"];
    self.btnCancel.hidden = YES;
    [self.btnCancel addTarget:self action:@selector(btnClick_endEdit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.btnCancel];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-10);
    }];
    
    self.btnSubmit = [self newHeaderButton:@"确定"];
    self.btnSubmit.hidden = YES;
    [self.btnSubmit addTarget:self action:@selector(btnClick_submit) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.btnSubmit];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-60);
    }];
    return headerView;
}

- (UIButton *)newHeaderButton:(NSString *)title{
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont gs_font:NSAppFontM];
    [btn setTitleColor:GS_COLOR_MAIN forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

@end
