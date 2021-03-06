//
//  ASPickerView.m
//  astro
//
//  Created by kjubo on 14-7-7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPickerView.h"
#import "NSDate+Addition.h"

#define kPickerViewHeight   216.0 //162.0

@interface ASPickerView ()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnOk;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *maskerView;

@end

@implementation ASPickerView

- (id)initWithParentViewController:(UIViewController *)vc
{
    self = [super initWithFrame:CGRectMake(0, 0, DF_WIDTH, kPickerViewHeight + 40)];
    if (self) {
        self.parentVc = vc;
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self.parentVc.view addSubview:self];
        
        self.maskerView = [[UIView alloc] init];
        self.maskerView.backgroundColor = [UIColor blackColor];
        self.maskerView.alpha = 0.5;
        self.maskerView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickerView)];
        [self.maskerView addGestureRecognizer:tap];
        [self.parentVc.view addSubview:self.maskerView];
        [self.maskerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.parentVc.view);
        }];
        
        UIView *btnView = [[UIView alloc] init];
        btnView.backgroundColor = GS_COLOR_LIGHT;
        [self addSubview:btnView];
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(DF_WIDTH, 40));
            make.top.equalTo(self);
        }];
        
        self.btnCancel = [[UIButton alloc]init];
        self.btnCancel.right = DF_WIDTH;
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:GS_COLOR_MAIN forState:UIControlStateNormal];
        [self.btnCancel addTarget:self action:@selector(btnClick_cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.right.centerY.equalTo(btnView);
        }];
        
        self.btnOk = [[UIButton alloc]init];
        [self.btnOk setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnOk setTitleColor:GS_COLOR_MAIN forState:UIControlStateNormal];
        [self.btnOk addTarget:self action:@selector(btnClick_submit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnOk];
        [self.btnOk mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 40));
            make.left.centerY.equalTo(btnView);
        }];
        
        self.datePicker = [[UIDatePicker alloc] init];
        [self addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(DF_WIDTH, kPickerViewHeight));
            make.top.equalTo(btnView.mas_bottom);
            make.left.equalTo(self);
        }];
        
        self.picker = [[UIPickerView alloc] init];
        self.picker.showsSelectionIndicator = YES;
        self.picker.delegate = self;
        [self addSubview:self.picker];
        [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(DF_WIDTH, kPickerViewHeight));
            make.top.equalTo(btnView.mas_bottom);
            make.left.equalTo(self);
        }];
    }
    return self;
}

- (void)setDataSource:(NSArray *)data selected:(id)selected{
    if(!data){
        return;
    }
    self.datePickerMode = -1;
    id firstObj = [data firstObject];
    if(firstObj && [firstObj isKindOfClass:[NSArray class]]){
        _dataSource = [data copy];
    }else{
        _dataSource = [NSArray arrayWithObjects:data, nil];
    }
    if(selected){
        NSArray *sl = nil;
        if(![selected isKindOfClass:[NSArray class]]){
            sl = @[selected];
        }else{
            sl = selected;
        }
        for(int i = 0; i < [sl count]; i++){
            NSInteger index = [sl[i] intValue];
            if(index < 0){
                index = 0;
            }
            [self.picker selectRow:index inComponent:i animated:YES];
        }
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
    _datePickerMode = datePickerMode;
    [self reloadPicker];
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode selected:(NSDate *)date{
    self.datePickerMode = datePickerMode;
    _dataSource = nil;
    if(date){
        self.datePicker.date = date;
    }else{
        self.datePicker.date = [NSDate date];
    }
    self.datePicker.minimumDate = [self.datePicker.date dateByAddingTimeInterval:-D_DAY * 180];
    self.datePicker.maximumDate = [self.datePicker.date dateByAddingTimeInterval:D_DAY * 180];
}

- (NSDate *)pickerDate{
    return [self.datePicker.date copy];
}

- (void)reloadPicker{
    if(self.datePickerMode < 0){    //自定义模式
        self.picker.hidden = NO;
        self.datePicker.hidden = YES;
        [self.picker reloadAllComponents];
    }else{
        self.picker.hidden = YES;
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode = self.datePickerMode;
        if(self.datePickerMode == UIDatePickerModeDate){
            self.datePicker.minimumDate = [NSDate dateWithYear:1900 month:1 day:1 hour:0 minute:0 second:0];
            self.datePicker.maximumDate = [NSDate date];
        }
        self.datePicker.date = [NSDate date];
    }
}

- (void)showPickerView{
    self.top = self.parentVc.view.height;
    self.maskerView.hidden = NO;
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottom = self.parentVc.view.height;
    } completion:nil];
    [self.parentVc.view bringSubviewToFront:self];
}

- (void)hidePickerView{
    self.bottom = self.parentVc.view.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.top = self.parentVc.view.height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.maskerView.hidden = YES;
    }];
}

#pragma mark - UIPickerView DataSource
- (NSInteger)selectedRowInComponent:(NSInteger)component{
    return [self.picker selectedRowInComponent:component];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.dataSource count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *items = [self.dataSource objectAtIndex:component];
    return [items count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *items = [self.dataSource objectAtIndex:component];
    if (row > items.count -1) {
        return nil;
    }
    return [items objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (void)btnClick_cancel:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(asPickerViewDidCancel:)]){
        [self.delegate asPickerViewDidCancel:self];
    }
    [self hidePickerView];
}

- (void)btnClick_submit:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(asPickerViewDidSelected:)]){
        [self.delegate asPickerViewDidSelected:self];
    }
    [self hidePickerView];
}
@end
