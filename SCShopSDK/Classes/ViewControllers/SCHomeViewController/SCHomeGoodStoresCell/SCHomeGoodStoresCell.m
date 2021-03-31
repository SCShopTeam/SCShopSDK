//
//  SCHomeGoodStoresCell.m
//  shopping
//
//  Created by gejunyu on 2021/3/2.
//  Copyright © 2021 jsmcc. All rights reserved.
//

#import "SCHomeGoodStoresCell.h"
#import "SCGoodStoresSubCell.h"
#import "NSData+SCBase64.h"

#define kGrayLineH SCREEN_FIX(4)
#define kTopViewH  SCREEN_FIX(38)
#define kBottomH   SCREEN_FIX(40)

static NSInteger kMaxGoodShopCount = 3;

@interface SCHomeGoodStoresCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *grayLine;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIControl *moreButton;

@end

@implementation SCHomeGoodStoresCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setGoodStoreList:(NSArray<SCGoodStoresModel *> *)goodStoreList
{
    if (goodStoreList == _goodStoreList || goodStoreList.count == 0) {
        return;
    }

    _goodStoreList = goodStoreList.count > kMaxGoodShopCount ? [goodStoreList subarrayWithRange:NSMakeRange(0, kMaxGoodShopCount)] : goodStoreList;
    
    self.tableView.height = kGoodStoreRowH * _goodStoreList.count;
    self.moreButton.top = self.tableView.bottom;

    [self.tableView reloadData];
}

+ (CGFloat)getRowHeight:(NSInteger)rowNum
{
    if (rowNum <= 0) {
        return 0;
        
    }else {
        NSInteger count = MIN(rowNum, kMaxGoodShopCount);
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
    SCGoodStoresSubCell *cell = (SCGoodStoresSubCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCGoodStoresSubCell.class) forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    if (row < self.goodStoreList.count) {
        SCGoodStoresModel *model = self.goodStoreList[row];
        cell.model = model;
    }
    
    @weakify(self)
//    cell.enterShopBlock = ^(SCGShopInfoModel * _Nonnull shopModel) {
//        @strongify(self)
//        if (self.enterShopBlock) {
//            self.enterShopBlock(indexPath.row, shopModel);
//        }
//    };
    
    cell.imgBlock = ^(NSInteger index, SCGActImageModel * _Nonnull imgModel) {
        @strongify(self)
        if (self.imgBlock) {
            self.imgBlock(indexPath.row, index, imgModel);
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.enterShopBlock && indexPath.row < self.goodStoreList.count) {
        SCGoodStoresModel *model = self.goodStoreList[indexPath.row];
        self.enterShopBlock(indexPath.row, model.shopInfo);
    }
}


#pragma mark -ui
- (UIView *)grayLine
{
    if (!_grayLine) {
        _grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kGrayLineH)];
        _grayLine.backgroundColor = HEX_RGB(@"#F6F6F6");
        [self.contentView addSubview:_grayLine];
    }
    return _grayLine;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.grayLine.bottom, SCREEN_WIDTH, kTopViewH)];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_topView];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.font = SCFONT_SIZED(18);
        label.text = @"发现好店";
        [label sizeToFit];
        label.center = CGPointMake(_topView.width/2, _topView.height/2);
        [_topView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.height-1, _topView.width, 1)];
        line.backgroundColor = HEX_RGB(@"#EEEEEE");
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:SCGoodStoresSubCell.class forCellReuseIdentifier:NSStringFromClass(SCGoodStoresSubCell.class)];
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (UIControl *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kBottomH)];
//        [_moreButton setBackgroundImage:[UIImage sd_imageWithGIFData:[NSData bundleResource:@"sc_more_stores" type:@"gif"]] forState:UIControlStateNormal];
        [self.contentView addSubview:_moreButton];
        
        //sdwebimage的gif加载方式有bug,当tableview滚动时动画会失效，所以使用wkwebview
        WKWebView *webView = [[WKWebView alloc] initWithFrame:_moreButton.bounds];
        webView.userInteractionEnabled = NO;
        [webView loadData:[NSData bundleResource:@"sc_more_stores" type:@"gif"] MIMEType:@"image/gif" characterEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
        [_moreButton addSubview:webView];

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
