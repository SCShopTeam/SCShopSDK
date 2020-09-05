//
//  SCAreaSelectView.m
//  shopping
//
//  Created by gejunyu on 2020/9/2.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAreaSelectView.h"
#import "SCAreaModel.h"

@interface SCAreaSelectView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) SCAreaBlock selectBlock;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSArray<SCAreaModel *> *areaList;
@property (nonatomic, assign) NSInteger selectedIndex;
@end


@implementation SCAreaSelectView

+ (void)show:(NSArray<SCAreaModel *> *)areaList selectBlock:(SCAreaBlock)selectBlock
{
    UIViewController *vc = [SCUtilities currentViewController];
    if (!vc) {
        return;
    }
    
    SCAreaSelectView *view = [[SCAreaSelectView alloc] initWithFrame:vc.view.bounds];
    view.selectBlock = selectBlock;
    view.areaList = areaList;
    [vc.view addSubview:view];
    [view showAnimation];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self cancelButton];
    }
    return self;
}

- (void)setAreaList:(NSArray<SCAreaModel *> *)areaList
{
    _areaList = areaList;
    
    [self.pickView reloadAllComponents];
    
    __block NSInteger index = 0;
    
    [self.areaList enumerateObjectsUsingBlock:^(SCAreaModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.selected) {
            index = idx;
            *stop = YES;
        }
    }];
    
    [self.pickView selectRow:index inComponent:0 animated:NO];
}

//弹出动画
- (void)showAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.bottom = self.height;
    }];
}

- (void)dissmiss
{
    [self removeFromSuperview];
}

#pragma mark -UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.areaList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SCAreaModel *model = self.areaList[row];
    return model.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}

- (void)sureClicked
{
    [self.areaList enumerateObjectsUsingBlock:^(SCAreaModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.selected = idx == self.selectedIndex;
    }];
    
    if (self.selectBlock) {
        self.selectBlock(self.areaList[_selectedIndex]);
    }
    
    [self dissmiss];
}

#pragma mark -ui
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, self.height/7*3)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, SCREEN_FIX(50))];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = SCFONT_SIZED(18);
        titleLabel.centerX = _contentView.width/2;
        titleLabel.text = @"选择区域";
        [_contentView addSubview:titleLabel];
        
        //取消按钮
        UIButton *dissmissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, SCREEN_FIX(50))];
        dissmissBtn.titleLabel.font = SCFONT_SIZED(15);
        [dissmissBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [dissmissBtn setTitle:@"取消" forState:UIControlStateNormal];
        [dissmissBtn addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:dissmissBtn];
        
        //确认
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.width - 50, 0, 50, SCREEN_FIX(50))];
        sureBtn.titleLabel.font = SCFONT_SIZED(15);
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:sureBtn];
        
        //选择器
        CGFloat pY = titleLabel.bottom;
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, pY, _contentView.width, _contentView.height-pY)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [_contentView addSubview:_pickView];
    }
    return _contentView;
}


- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.contentView.height)];
        [_cancelButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

@end
