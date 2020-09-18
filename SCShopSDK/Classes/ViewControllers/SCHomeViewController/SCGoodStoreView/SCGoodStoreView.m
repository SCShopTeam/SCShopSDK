//
//  SCGoodStoreView.m
//  shopping
//
//  Created by gejunyu on 2020/8/17.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCGoodStoreView.h"
#import "SCGoodStoreCell.h"
 
#define kGrayLineH SCREEN_FIX(13.5)
#define kTopViewH  SCREEN_FIX(41.5)
#define kBottomH   SCREEN_FIX(29.5)

static NSInteger kMaxGoodShopCount = 3;

@interface SCGoodStoreView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *grayLine;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation SCGoodStoreView

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
    self.tableView.height = self.height - self.tableView.top - kBottomH;
}

- (void)setGoodStoreList:(NSArray<SCHomeStoreModel *> *)goodStoreList
{
    if (!VALID_ARRAY(goodStoreList)) {
        _goodStoreList = nil;
        return;
    }
    
    _goodStoreList = goodStoreList.count > kMaxGoodShopCount ? [goodStoreList subarrayWithRange:NSMakeRange(0, kMaxGoodShopCount)] : goodStoreList;

    [self.tableView reloadData];
}

+ (CGFloat)sectionHeight:(NSInteger)rowNumber
{
    if (rowNumber <= 0) {
        return 0;
        
    }else {
        NSInteger count = MIN(rowNumber, kMaxGoodShopCount);
        return kGrayLineH + kTopViewH + kGoodStoreRowH *count + kBottomH;
    }
}


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodStoreList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGoodStoreRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCGoodStoreCell *cell = (SCGoodStoreCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCGoodStoreCell.class) forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    if (row < self.goodStoreList.count) {
        SCHomeStoreModel *model = self.goodStoreList[row];
        cell.model = model;
        cell.isLast = row == self.goodStoreList.count-1;
    }
    
    @weakify(self)
//    cell.enterShopBlock = ^(SCHShopInfoModel * _Nonnull shopModel) {
//        @strongify(self)
//        if (self.enterShopBlock) {
//            self.enterShopBlock(indexPath.row, shopModel);
//        }
//    };
    
    cell.imgBlock = ^(NSInteger index, SCHActImageModel * _Nonnull imgModel) {
        @strongify(self)
        if (self.imgBlock) {
            self.imgBlock(indexPath.row, index, imgModel);
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCHomeStoreModel *model = self.goodStoreList[indexPath.row];
    if (self.enterShopBlock) {
        self.enterShopBlock(indexPath.row, model.shopInfo);
    }
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
        CGFloat y = self.topView.bottom;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.width, self.height - y - self.moreButton.height)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:SCGoodStoreCell.class forCellReuseIdentifier:NSStringFromClass(SCGoodStoreCell.class)];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        CGFloat w = SCREEN_FIX(362);
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake((self.width-w)/2, self.height-kBottomH, w, kBottomH)];
        [_moreButton setBackgroundImage:SCIMAGE(@"sc_more_store") forState:UIControlStateNormal];
        [self addSubview:_moreButton];
        
        @weakify(self)
        [_moreButton sc_addEventTouchUpInsideHandle:^(id  _Nonnull sender) {
           @strongify(self)
            if (self.moreBlock) {
                self.moreBlock();
            }
        }];
    }
    return _moreButton;
}

@end
