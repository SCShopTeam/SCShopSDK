//
//  SCGoodShopView.m
//  shopping
//
//  Created by gejunyu on 2020/8/17.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCGoodShopView.h"
#import "SCGoodShopCell.h"
 
#define kGrayLineH SCREEN_FIX(13.5)
#define kTopViewH  SCREEN_FIX(41.5)

static NSInteger kMaxGoodShopCount = 3;

@interface SCGoodShopView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *grayLine;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SCGoodShopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.height = self.height - self.tableView.top;
}

- (void)setGoodShopList:(NSArray<SCHomeShopModel *> *)goodShopList
{
    if (!VALID_ARRAY(goodShopList)) {
        _goodShopList = nil;
        return;
    }
    
    _goodShopList = goodShopList.count > kMaxGoodShopCount ? [goodShopList subarrayWithRange:NSMakeRange(0, kMaxGoodShopCount)] : goodShopList;

    [self.tableView reloadData];
}

+ (CGFloat)sectionHeight:(NSInteger)rowNumber
{
    if (rowNumber <= 0) {
        return 0;
        
    }else {
        NSInteger count = MIN(rowNumber, kMaxGoodShopCount);
        return kGrayLineH + kTopViewH + kGoodShopRowH*count;
    }
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodShopList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGoodShopRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCGoodShopCell *cell = (SCGoodShopCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCGoodShopCell.class) forIndexPath:indexPath];
    
    SCHomeShopModel *model = self.goodShopList[indexPath.row];
    cell.model = model;
    
    @weakify(self)
    cell.enterShopBlock = ^(SCHShopInfoModel * _Nonnull shopModel) {
        @strongify(self)
        if (self.enterShopBlock) {
            self.enterShopBlock(indexPath.row, shopModel);
        }
    };
    
    cell.imgBlock = ^(NSInteger index, SCHActImageModel * _Nonnull imgModel) {
        @strongify(self)
        if (self.imgBlock) {
            self.imgBlock(indexPath.row, index, imgModel);
        }
    };
    
    return cell;
}


#pragma mark -ui
- (UIView *)grayLine
{
    if (!_grayLine) {
        _grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kGrayLineH)];
        _grayLine.backgroundColor = HEX_RGB(@"#F5F3F6");
        [self addSubview:_grayLine];
    }
    return _grayLine;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.grayLine.bottom, self.width, kTopViewH)];
        _topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topView];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.font = SCFONT_SIZED(18);
        label.text = @"发现好店";
        [label sizeToFit];
        label.center = CGPointMake(_topView.width/2, _topView.height/2);
        [_topView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.height-0.5, _topView.width, 0.5)];
        line.backgroundColor = HEX_RGB(@"#DBDBDB");
        [_topView addSubview:line];
        
        //按钮
        CGFloat w = SCREEN_FIX(60);
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_topView.width-w, 0, w, _topView.height)];
        [btn setTitleColor:HEX_RGB(@"#999999") forState:UIControlStateNormal];
        btn.titleLabel.font = SCFONT_SIZED(12);
        [btn setTitle:@"更多 >" forState:UIControlStateNormal];
        [_topView addSubview:btn];
        
        @weakify(self)
        [btn sc_addEventTouchUpInsideHandle:^(UIButton * _Nonnull sender) {
            @strongify(self)
            if (self.moreBlock) {
                self.moreBlock();
            }
        }];
    }
    return _topView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.width, 0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:SCGoodShopCell.class forCellReuseIdentifier:NSStringFromClass(SCGoodShopCell.class)];
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
