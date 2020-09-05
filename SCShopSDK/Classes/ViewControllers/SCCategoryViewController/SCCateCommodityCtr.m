//
//  SCCateCommodityCtr.m
//  shopping
//
//  Created by zhangtao on 2020/7/24.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCateCommodityCtr.h"
@interface SCCateCommodityCtr ()

@end

@implementation SCCateCommodityCtr
{
    UILabel *emptyLab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.view.backgroundColor = [UIColor whiteColor];
     self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    emptyLab = [[UILabel alloc]init];
    [self.tableView addSubview:emptyLab];
    emptyLab.textColor = HEX_RGB(@"#888888");
    emptyLab.font = [UIFont systemFontOfSize:20];
    emptyLab.text = @"暂无商品";
    [emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tableView);
        make.centerX.equalTo(self.tableView);
    }];
}

-(void)setSourceArrs:(NSArray<SCCommodityModel *> *)sourceArrs{
        _sourceArrs = sourceArrs;
}

-(void)reloadData{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([SCUtilities isValidArray:_sourceArrs] && _sourceArrs.count>0) {
        emptyLab.hidden = YES;
    }else{
        emptyLab.hidden = NO;
    }
    return _sourceArrs?_sourceArrs.count:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_FIX(95);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    SCCateCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SCCateCommodityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row >= _sourceArrs.count) {
        cell.model = nil;
    }else{
        SCCommodityModel *model = _sourceArrs[indexPath.row];
        cell.model = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cagegoryCommodityClick:)]) {
        SCCommodityModel *model = _sourceArrs[indexPath.row];
          [self.delegate cagegoryCommodityClick:model];
      }
}
 
 

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
