//
//  SCCategoryCommodityController.m
//  shopping
//
//  Created by zhangtao on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCategoryCommodityController.h"
#import "SCCategoryCommodityCell.h"
@interface SCCategoryCommodityController ()

@end

@implementation SCCategoryCommodityController

-(void)reloadData{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArrs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200 * m6Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    SCCategoryCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[SCCategoryCommodityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.dataDic = @{};
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cagegoryCommodityClick:)]) {
        [self.delegate cagegoryCommodityClick:indexPath];
    }
}
@end
