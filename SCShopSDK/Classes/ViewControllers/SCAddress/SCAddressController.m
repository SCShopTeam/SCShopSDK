//
//  SCAddressController.m
//  shopping
//
//  Created by zhangtao on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCAddressController.h"
#import "SCAddressCell.h"
#import "SCAddAddressController.h"
#import "SCAlertViewController.h"
//#import "SCAddressModel.h"
@interface SCAddressController ()<UITableViewDelegate,UITableViewDataSource,SCAddressDelegaate>

@end

@implementation SCAddressController
{
    UITableView *table;
    NSMutableArray <SCAddressModel *> *addressList;
    
    UIView *noOrderView;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EDIT_ADDRESS_SUCCESS" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    if (@available(iOS 11.0, *)) {
        table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createUI];
    [self requestData];
}

-(void)createUI{
    if (!table) {
        table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        table.backgroundColor = HEX_RGB(@"#F7F7F7");
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.mas_equalTo(-84);
        }];
    }
    
    noOrderView = [[UIView alloc]init];
    [self.view addSubview:noOrderView];
    noOrderView.backgroundColor = [UIColor clearColor];
    [noOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(table).mas_offset(SCREEN_WIDTH/4);
        make.left.right.bottom.mas_equalTo(table);
    }];
    
    UIImageView *noImgV = [[UIImageView alloc]init];
    noImgV.image = [UIImage bundleImageNamed:@"sc_noAddress_icon"];
    [noOrderView addSubview:noImgV];
    [noImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noOrderView);
        make.width.height.mas_equalTo(SCREEN_WIDTH/4);
        make.centerX.mas_equalTo(noOrderView.mas_centerX);
    }];

    UILabel *noOrderLab = [[UILabel alloc]init];
    [noOrderView addSubview:noOrderLab];
    noOrderLab.numberOfLines = 2;
    noOrderLab.text = @"暂无可用的收货地址\n请新增一个地址";
    noOrderLab.font = [UIFont systemFontOfSize:15];
    noOrderLab.textColor = HEX_RGB(@"#888888");
    noOrderLab.textAlignment = NSTextAlignmentCenter;
    [noOrderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noImgV.mas_bottom).mas_offset(10);
        make.centerX.equalTo(noOrderView.mas_centerX);
    }];
    
    noOrderView.hidden = YES;
    
    UIButton *addBtn = [[UIButton alloc]init];
    [self.view addSubview:addBtn];
    addBtn.layer.cornerRadius = 17;
    addBtn.layer.masksToBounds = YES;
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       WithFrame:CGRectMake(20, SCREEN_HEIGHT-100, SCREEN_WIDTH-40, 50)
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(34);
        make.bottom.mas_equalTo(self.view).mas_offset(-50);
    }];
    addBtn.titleLabel.textColor = HEX_RGB(@"#FFFFFF");
    addBtn.backgroundColor = HEX_RGB(@"#F2180B");
    [addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 11.0, *)) {
        table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)requestData{
    __weak typeof(self) weakSelf = self;
//    [self showLoading];
    [SCRequest scAddressList:^(BOOL success, NSArray * _Nullable objArr, NSString * _Nullable errMsg) {
//        [self stopLoading];
        if (success) {
            [weakSelf handleAddressData:objArr];
        }
    }];
}

-(void)deleteAddress:(NSString *)addressNum{
    if (![SCUtilities isValidString:addressNum]) {
        return;
    }
    [self showLoading];
    addressList = [NSMutableArray arrayWithObjects:@"", nil];
    [SCRequest scAddressDelete:addressNum block:^(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg) {
        [self stopLoading];
        if (success) {
            [self requestData];
        }
    }];
}

-(void)handleAddressData:(NSArray *)objArr{
    addressList = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in objArr) {
//            SCAddressModel *model = [[SCAddressModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
            SCAddressModel *model = [SCAddressModel yy_modelWithDictionary:dic];
            [addressList addObject:model];
        }
    [table reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (addressList.count>0) {
        noOrderView.hidden = YES;
    }else{
        noOrderView.hidden = NO;
    }
    return addressList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230 * m6Scale;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    SCAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SCAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    cell.model = addressList[indexPath.row];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [addressList removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    }
}

#pragma mark --新增
-(void)addAddress{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"EDIT_ADDRESS_SUCCESS" object:nil];
    SCAddAddressController *add = [[SCAddAddressController alloc]init];
    [self.navigationController pushViewController:add animated:NO];
}

#pragma mark -- 地址操作（删除、编辑）
-(void)scAddressDoneClick:(addressClickType)type cell:(nonnull UITableViewCell *)cell{
    SCAddressCell *addressCell = (SCAddressCell *)cell;
    NSIndexPath *indexpath = [table indexPathForCell:addressCell];
    NSString *addressNum = addressList[indexpath.row].addressNum;
    if (type == addressEditType) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"EDIT_ADDRESS_SUCCESS" object:nil];
        SCAddAddressController *add = [[SCAddAddressController alloc]init];
           add.addressNum = addressNum;
           [self.navigationController pushViewController:add animated:NO];
    }else if (type == addressDeleteType){
        
        __block typeof(self) wkSelf = self;
           SCAlertViewController *alert = [SCAlertViewController alertControllerWithTitle:@"提示" message:@"确定删除" preferredStyle:UIAlertControllerStyleAlert];
        
           [alert showAlertAct1:@"取消" act2:@"确定" act1Back:nil act2Back:^{
                //请求删除，重新加载数据刷新table
               [wkSelf deleteAddress:addressNum];
               
               
            }];
           [self presentViewController:alert animated:YES completion:nil];
        
        
      
//        [mulArr removeObjectAtIndex:indexpath.row];
//        [table deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
