//
//  SCMainCategoryController.m
//  shopping
//
//  Created by zhangtao on 2020/7/8.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCMainCategoryController.h"

@interface SCMainCategoryController ()

@end

@implementation SCMainCategoryController
{
    UILabel *leftMarkLab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(@"F6F6F6");
    leftMarkLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 15)];
    leftMarkLab.backgroundColor = [UIColor redColor];
    [self.tableView addSubview:leftMarkLab];
    
}

//-(void)setSourceArrs:(NSArray *)sourceArrs{
//    if ([SCUtilities isValidArray:sourceArrs]) {
//        _sourceArrs = sourceArrs;
//    }
//}

-(void)setSourceArrs:(NSMutableArray<SCCategoryModel *> *)sourceArrs{
    if ([SCUtilities isValidArray:sourceArrs]) {
        _sourceArrs = sourceArrs;
    }
}

-(void)reloadData{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceArrs.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
   mainCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[mainCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SCCategoryModel *model = _sourceArrs[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.typeName?model.typeName:@""];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainCategorySelect:)]) {
        SCCategoryModel *model = _sourceArrs[indexPath.row];
        [self.delegate mainCategorySelect:model];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect frame = cell.frame;
        leftMarkLab.frame = CGRectMake(0, frame.origin.y+10, 5, frame.size.height-20);
    }

}
@end





@interface mainCategoryCell()

@end
@implementation mainCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:12];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 177*m6Scale);
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}
@end


