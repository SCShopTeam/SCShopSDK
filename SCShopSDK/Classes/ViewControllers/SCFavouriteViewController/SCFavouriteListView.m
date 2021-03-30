//
//  SCFavouriteListView.m
//  shopping
//
//  Created by gejunyu on 2020/8/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCFavouriteListView.h"
#import "SCFavouriteCell.h"

@interface SCFavouriteListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SCFavouriteListView


#pragma mark -UITableViewDelegate, UITableViewDataSource
- (void)setFavouriteList:(NSMutableArray<SCFavouriteModel *> *)favouriteList
{
    _favouriteList = favouriteList;
    
    self.tableView.frame = self.bounds;
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favouriteList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFavouriteRowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCFavouriteCell *cell = (SCFavouriteCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SCFavouriteCell.class) forIndexPath:indexPath];
    
    if (indexPath.row < self.favouriteList.count) {
        SCFavouriteModel *model = self.favouriteList[indexPath.row];
        cell.model = model;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectBlock) {
        _selectBlock(indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.deleteBlock) {
            self.deleteBlock(indexPath.row);
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [_tableView registerClass:SCFavouriteCell.class forCellReuseIdentifier:NSStringFromClass(SCFavouriteCell.class)];
    }
    return _tableView;
}

@end
