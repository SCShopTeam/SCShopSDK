//
//  SCAddressSelectView.m
//  shopping
//
//  Created by gejunyu on 2020/7/31.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAddressSelectView.h"
#import "SCAddressViewModel.h"

#define kMargin      SCREEN_FIX(10)
#define kRowH        SCREEN_FIX(40)
#define kSelectColor HEX_RGB(@"#FC6C22")

@interface AddressButton : UIButton
@property (nonatomic, strong) UIView *line;
- (void)setText:(NSString *)text;
@end

@interface AddressCell : UITableViewCell
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, strong) UIImageView *icon;
@end

@interface SCAddressSelectView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) AddressButton *provinceBtn;
@property (nonatomic, strong) AddressButton *cityBtn;
@property (nonatomic, strong) AddressButton *regionBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) SCAdminType currentAdminType;

@property (nonatomic, copy) SCAddressBlock addressBlock;
@property (nonatomic, strong) SCAddressModel *addressModel;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation SCAddressSelectView
+ (void)show:(SCAddressModel *)addressModel addressBlock:(SCAddressBlock)addressBlock
{
    UIViewController *vc = [SCUtilities currentViewController];
    if (!vc) {
        return;
    }
    SCAddressSelectView *addressView = [[SCAddressSelectView alloc] initWithFrame:vc.view.bounds];
    addressView.addressBlock = addressBlock;
    [addressView.addressModel copyData:addressModel];

    [vc.view addSubview:addressView];
    [addressView showAnimation];
}

+ (void)show:(SCAddressBlock)addressBlock
{
    [self show:nil addressBlock:addressBlock];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self cancelButton];
    [self topBtnSelected:SCAdminTypeProvince checkData:YES];
}


- (void)requestData:(BOOL)checkData
{
    [self showLoading];
    [[SCAddressViewModel sharedInstance] requestAdminList:_currentAdminType provinceNum:self.addressModel.provinceNum cityNum:self.addressModel.cityNum success:^(id  _Nullable responseObject) {
        [self stopLoading];
        if (checkData) {
            [self checkData];
        }else {
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSString * _Nullable errorMsg) {
        [self stopLoading];
    }];
}

//检测数据完整性
- (void)checkData
{
    //请求完省，还需要市的数据
    if (_currentAdminType == SCAdminTypeProvince && VALID_STRING(self.addressModel.provinceNum) ) {
        [_provinceBtn setText:self.addressModel.provinceName];
        [_cityBtn setText:@"请选择"];
        [self topBtnSelected:SCAdminTypeCity checkData:YES];
        
    }else if (_currentAdminType == SCAdminTypeCity && VALID_STRING(self.addressModel.cityNum)) {
        [_cityBtn setText:self.addressModel.cityName];
        [_regionBtn setText:@"请选择"];
        [self topBtnSelected:SCAdminTypeRegion checkData:YES];
        
        
    }else {
        [self.tableView reloadData];
    }
}

//弹出动画
- (void)showAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.bottom = self.height;
    }];
}

#pragma mark -btn
- (void)topBtnSelected:(SCAdminType)adminType checkData:(BOOL)checkData
{
    _provinceBtn.selected = adminType == SCAdminTypeProvince;
    _cityBtn.selected     = adminType == SCAdminTypeCity;
    _regionBtn.selected   = adminType == SCAdminTypeRegion;
    
    _currentAdminType = adminType;
    
    _cityBtn.left   = _provinceBtn.right + 15;
    _regionBtn.left = _cityBtn.right + 15;

    [self requestData:checkData];
    
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self currentList].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AddressCell.class) forIndexPath:indexPath];
    
    SCAdminListModel *model = [self currentList][indexPath.row];
    
    cell.textLabel.text = model.adminName;

    if (_currentAdminType == SCAdminTypeProvince) {
        cell.isDefault = [model.adminNum isEqualToString:self.addressModel.provinceNum];
        
    }else if (_currentAdminType == SCAdminTypeCity) {
        cell.isDefault = [model.adminNum isEqualToString:self.addressModel.cityNum];
        
    }else {
        cell.isDefault = [model.adminNum isEqualToString:self.addressModel.regionNum];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCAdminListModel *defaultModel = [self currentList][indexPath.row];

    if (_currentAdminType == SCAdminTypeProvince) {
        [_provinceBtn setText:defaultModel.adminName];
        _cityBtn.hidden = NO;
        _regionBtn.hidden = YES;
        self.addressModel.provinceName = defaultModel.adminName;
        self.addressModel.provinceNum  = defaultModel.adminNum;
        self.addressModel.cityNum      = @"";
        self.addressModel.cityName     = @"";
        [_cityBtn setText:@"请选择"];
        [self topBtnSelected:SCAdminTypeCity checkData:NO];
        
    }else if (_currentAdminType == SCAdminTypeCity) {
        [_cityBtn setText:defaultModel.adminName];
        _regionBtn.hidden = NO;
        self.addressModel.cityName   = defaultModel.adminName;
        self.addressModel.cityNum    = defaultModel.adminNum;
        self.addressModel.regionNum  = @"";
        self.addressModel.regionName = @"";
        [_regionBtn setText:@"请选择"];
        [self topBtnSelected:SCAdminTypeRegion checkData:NO];
        
    }else {
        self.addressModel.regionName = defaultModel.adminName;
        self.addressModel.regionNum = defaultModel.adminNum;
        if (_addressBlock) {
            _addressBlock(self.addressModel);
            [self removeFromSuperview];
        }
    }
}

- (NSArray <SCAdminListModel *> *)currentList
{
    NSArray *adminList = [SCAddressViewModel sharedInstance].adminList;
    if (_currentAdminType == SCAdminTypeProvince) {
        return adminList;
        
    }else if (_currentAdminType == SCAdminTypeCity) {
        for (SCAdminListModel *province in adminList) {
            if ([province.adminNum isEqualToString:self.addressModel.provinceNum]) {
                return province.children;
            }
        }
        
    }else {
        for (SCAdminListModel *province in adminList) {
            if ([province.adminNum isEqualToString:self.addressModel.provinceNum]) {
                for (SCAdminListModel *city in province.children) {
                    if ([city.adminNum isEqualToString:self.addressModel.cityNum]) {
                        return city.children;
                    }
                }
            }
        }
    }
    
    return @[];
}



#pragma mark -ui
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, (self.height/5*3))];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
//        //标题
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, SCREEN_FIX(50))];
//        _titleLabel.text = @"新增收货地址";
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_contentView addSubview:_titleLabel];
        
        //省市县按钮
        CGFloat btnH = SCREEN_FIX(40);
        for (int i=SCAdminTypeProvince; i<=SCAdminTypeRegion; i++) {
            AddressButton *btn = [[AddressButton alloc] initWithFrame:CGRectMake(0, 0, 0, btnH)];
            if (i==SCAdminTypeProvince) {
                [btn setText:@"请选择"];
                _provinceBtn = btn;
                
            }else if (i==SCAdminTypeCity) {
                _cityBtn = btn;
                
            }else {
                _regionBtn = btn;
            }
            
            @weakify(self)
            [btn sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
                @strongify(self)
                [self topBtnSelected:(SCAdminType)i checkData:NO];
            }];
            
            [_contentView addSubview:btn];
            

        }
        
        //分割线
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(kMargin, btnH - 0.5, _contentView.width-kMargin*2, 0.5)];
        sepLine.backgroundColor = [UIColor lightGrayColor];
        [_contentView addSubview:sepLine];
        [_contentView sendSubviewToBack:sepLine];
        
        //列表
        CGFloat tbY = sepLine.bottom;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tbY, _contentView.width, _contentView.height - tbY)];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:AddressCell.class forCellReuseIdentifier:NSStringFromClass(AddressCell.class)];
        [_contentView addSubview:_tableView];
        
    }
    return _contentView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.contentView.height)];
        
        @weakify(self)
        [_cancelButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
            @strongify(self)
            [self removeFromSuperview];
        }];
        
        [self addSubview:_cancelButton];
        [self sendSubviewToBack:_cancelButton];
    }
    return _cancelButton;
}

- (SCAddressModel *)addressModel
{
    if (!_addressModel) {
        _addressModel = [SCAddressModel new];
    }
    return _addressModel;
}

@end



@implementation AddressButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = SCFONT_SIZED(15);
        [self setTitleColor:kSelectColor forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, 0, 1)];
        _line.backgroundColor = kSelectColor;
        [self addSubview:_line];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setTitle:text forState:UIControlStateNormal];
    
    CGFloat textW = [self.currentTitle calculateWidthWithFont:self.titleLabel.font height:self.height];
    self.width = textW + kMargin * 2;
    
    _line.width = textW;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _line.hidden = !self.selected;
    _line.centerX = self.width/2;
}

@end


@implementation AddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = SCFONT_SIZED(15);
    
    CGFloat iconWH = SCREEN_FIX(30);
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kRowH-iconWH)/2, iconWH, iconWH)];
    [self.contentView addSubview:_icon];
}

- (void)setIsDefault:(BOOL)isDefault
{
    _isDefault = isDefault;
    self.textLabel.textColor = isDefault ? kSelectColor : [UIColor blackColor];
    self.icon.hidden = !isDefault;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.contentView.height/2;
    self.textLabel.left = kMargin;
    self.icon.left = self.textLabel.right + 5;
}

@end
