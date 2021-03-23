//
//  SCCartStoreCell.m
//  shopping
//
//  Created by gejunyu on 2020/7/9.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCartStoreCell.h"
#import "SCStoreItemCell.h"
#import "SCStoreTopView.h"
#import "SCStoreBottomView.h"

#define kCartStoreTopH         SCREEN_FIX(34)
#define kCartStoreBottomH      SCREEN_FIX(43)

@interface SCCartStoreCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SCStoreTopView *topView;
@property (nonatomic, strong) SCStoreBottomView *bottomView;
@end

@implementation SCCartStoreCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

+ (CGFloat)calculateRowHeight:(SCCartModel *)model
{
    return kCartStoreTopH + model.cartItems.count * kCartStoreRowH + kCartStoreBottomH;
}

- (void)setModel:(SCCartModel *)model
{
    _model = model;

    [self updateHeaderAndFooter];
    
    self.tableView.height = model.rowHeight;
    
    //cell
    [self.tableView reloadData];
}

- (void)updateHeaderAndFooter
{
    [_model updateData];
    //header
    self.topView.selected = _model.selectedAll;
    self.topView.title = _model.busiName;
    
    //bottom
    self.bottomView.price      = _model.sumPrice;
    self.bottomView.balanceNum = _model.balanceNum;
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.cartItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCartStoreRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCStoreItemCell *cell = (SCStoreItemCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCStoreItemCell.class) forIndexPath:indexPath];
    
    SCCartItemModel *item = _model.cartItems[indexPath.row];
    cell.item = item;
    
    @weakify(self)
    cell.numBlock = ^{
        @strongify(self)
        [self updateHeaderAndFooter];
    };
    
    cell.selectBlock = ^{
        @strongify(self)
        [self updateHeaderAndFooter];
    };
    
    cell.deleteBlock = ^(SCCartItemModel * _Nonnull item) {
        @strongify(self)
        if (self.deleteBlock) {
            self.deleteBlock(item, NO);
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.rowClickBlock) {
        SCCartItemModel *item = _model.cartItems[indexPath.row];
        self.rowClickBlock(item.categoryUrl);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.deleteBlock) {
            SCCartItemModel *item = self.model.cartItems[indexPath.row];
            self.deleteBlock(item, YES);
        }
    }
}

#pragma mark -ui
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.scrollEnabled  = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:SCStoreItemCell.class forCellReuseIdentifier:NSStringFromClass(SCStoreItemCell.class)];
        

        _tableView.tableHeaderView = self.topView;
        _tableView.tableFooterView = self.bottomView;
        
        
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (SCStoreTopView *)topView
{
    if (!_topView) {
        _topView = [[SCStoreTopView alloc] initWithFrame:CGRectMake(0, 0, self.width, kCartStoreTopH)];
        @weakify(self)
        _topView.selectActionBlock = ^{
            @strongify(self)
            self.model.selectedAll ^=1;
            self.model = self.model;
        };
    }
    return _topView;
}

- (SCStoreBottomView *)bottomView
{
    if (!_bottomView) {
        @weakify(self)
        _bottomView = [[SCStoreBottomView alloc] initWithFrame:CGRectMake(0, 0, self.width, kCartStoreBottomH)];
        _bottomView.balanceBlock = ^{
            @strongify(self)
            if (self.commitBlock) {
                self.commitBlock();
            }
        };
    }
    return _bottomView;
}

@end
