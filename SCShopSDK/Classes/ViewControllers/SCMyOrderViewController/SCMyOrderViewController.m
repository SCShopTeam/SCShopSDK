//
//  SCMyOrderViewController.m
//  shopping
//
//  Created by zhangtao on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCMyOrderViewController.h"
#import "SCMyOrderTopItemView.h"
#import "SCMyOrderCell.h"
#import "SCMyOrderHeaderView.h"
#import "SCAddressController.h"
#import "SCFavouriteViewController.h"
#import "SCWebViewCustom.h"
#import "SCURLSerialization.h"
#import "SCApolloOrderModel.h"
#import "MJRefresh.h"
#import "SCAlertViewController.h"
#import "SCTagShopsViewController.h"
@interface SCMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,scMyOrderTopItemDelegate>
@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong) SCMyOrderTopItemView *topItemView;
@property(nonatomic,strong)NSMutableArray <SCSCOrderModel *> *scOrders;  //商城
@property(nonatomic,strong)NSMutableArray <SCApolloOrderModel *> *mdOrders;  //门店
@property(nonatomic,assign)BOOL isMDStyle;  //是否是门店订单

@property(nonatomic,assign)int pageNum;
@property(nonatomic,assign)BOOL isLoadMore; //是否是下拉加载更多
@end

@implementation SCMyOrderViewController
{
    SCOrderTopItemClickType currentType;
    UIView *emptyView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //        self.navigationController.navigationBar.hidden = YES;
    if (currentType && currentType > itemServiceType) {
        [self itemClick:currentType];
    }else{
         currentType = itemWaitPayType_SC;
    }
    
    
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.pageNum = 1;
    [self prepareUI];
    self.hideNavigationBar = YES;
    
    [self sc_requestOrderListWithStatus:@"XSDD_DZF"];
   
    NSString *userPhone = [SCUserInfo currentUser].phoneNumber;
    DDLOG(@"---- 商城的用户手机号码     :::  %@ :::",userPhone);
}

- (void)prepareUI
{
    _topItemView = [[SCMyOrderTopItemView alloc]init];
    [self.view addSubview:_topItemView];
    _topItemView.delegate = self;
    
    [_topItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_FIX(301));
    }];
    
    /**优惠券角标*/
//    UIButton *btn = [_topItemView viewWithTag:itemCouponType];
//    [btn badgeNum:5 fontSize:12 bgColor:HEX_RGB(@"#FF8A00")];
    
    
    _listTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_listTable];
    _listTable.layer.cornerRadius = 10;
    _listTable.separatorColor = [UIColor clearColor];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    [_listTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_topItemView.mas_bottom).mas_offset(15);
        make.bottom.equalTo(self.view);
    }];
    
    _listTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    emptyView = [[UIView alloc]init];
    [_listTable.superview addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_listTable.mas_centerX);
        make.centerY.mas_equalTo(_listTable.mas_centerY).mas_offset(-15);
//        make.center.mas_equalTo(_listTable.center);
        make.height.mas_equalTo(_listTable.mas_height);
        make.width.mas_equalTo(_listTable.mas_width);
    }];
    
    UILabel *emptyLab = [[UILabel alloc]init];
       [emptyView addSubview:emptyLab];
       emptyLab.textColor = HEX_RGB(@"#888888");
       emptyLab.text = @"竟然是空的";
       emptyLab.numberOfLines = 2;
       emptyLab.font = [UIFont systemFontOfSize:15];
       emptyLab.textAlignment = NSTextAlignmentCenter;
       [emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.mas_equalTo(emptyView.mas_centerX);
           make.top.mas_equalTo(_listTable).mas_offset(50);
       }];
    
    
    UILabel *emptyLab1 = [[UILabel alloc]init];
    [emptyView addSubview:emptyLab1];
    emptyLab1.textColor = HEX_RGB(@"#888888");
    emptyLab1.text = @"在忙，也要买点什么犒赏自己~";
    emptyLab1.numberOfLines = 2;
    emptyLab1.font = [UIFont systemFontOfSize:12];
    emptyLab1.textAlignment = NSTextAlignmentCenter;
    emptyLab1.font = [UIFont boldSystemFontOfSize:12];
    [emptyLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(emptyView.mas_centerX);
        make.top.mas_equalTo(emptyLab.mas_bottom).mas_offset(10);
    }];
    
    UIButton *emptybtn = [[UIButton alloc]init];
    [emptyView addSubview:emptybtn];
    emptybtn.layer.borderWidth = 1;
    emptybtn.layer.borderColor = HEX_RGB(@"#888888").CGColor;
    [emptybtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    emptybtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [emptybtn setTitleColor:HEX_RGB(@"888888") forState:UIControlStateNormal];
    [emptybtn addTarget:self action:@selector(toGuangGuang) forControlEvents:UIControlEventTouchUpInside];
    [emptybtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_listTable.mas_centerX);
        make.top.mas_equalTo(emptyLab1.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    //                if (floorView == self.serviceFloor) {
    //                    //只有顶部圆角
    //                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:floorView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    //                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //                    maskLayer.frame = floorView.bounds;
    //                    maskLayer.path = maskPath.CGPath;
    //                    floorView.layer.mask = maskLayer;
    //                }else if (floorView == self.thirdServiceFloor){
    //                    //只有底部圆角
    //                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:floorView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    //                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //                    maskLayer.frame = floorView.bounds;
    //                    maskLayer.path = maskPath.CGPath;
    //                    floorView.layer.mask = maskLayer;
    //                }
}

-(void)toGuangGuang{
    SCTagShopsViewController *tag = [[SCTagShopsViewController alloc]init];
    [self.navigationController pushViewController:tag animated:YES];
}

-(void)loadMore{
    if (currentType) {
        ++_pageNum;
        _isLoadMore = YES;
        [_listTable.mj_footer endRefreshing];
        [self itemClick:currentType];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_isMDStyle) {
        if (_mdOrders && [SCUtilities isValidArray:_mdOrders[section].ordOrderItemsAppVOList]) {
         
            return _mdOrders[section].ordOrderItemsAppVOList.count;
        }
    }else{
        if (_scOrders && [SCUtilities isValidArray:_scOrders[section].goodsList]) {
           
               return _scOrders[section].goodsList.count;
           }
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num = 0;
    if (_isMDStyle) {
       num = _mdOrders?_mdOrders.count : 0;
    }else{
        num = _scOrders?_scOrders.count:0;
    }
    
    if (num == 0) {
        emptyView.hidden = NO;
    }else{
        emptyView.hidden = YES;
    }
  
    return num;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SCMyOrderHeaderView *headerView = [[SCMyOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, _listTable.frame.size.width, 45)];
//    headerView.dataDic = @{};
    headerView.nameLab.text = _scOrders[section].tenantName;
    __weak typeof(self)wkSelf = self;
    headerView.orderHeaderCallBack = ^(NSString * _Nonnull detailUrl) {
        NSLog(@"%@",detailUrl);
        NSString *url;
        if (wkSelf.isMDStyle) {
            url = SC_APOLLO_ORDER_DETAIL(wkSelf.mdOrders[section].orderId);
        }else{
           url =  SC_SC_ORDER_DETAIL(wkSelf.scOrders[section].orderNum);
        }
        
        if ([SCUtilities isValidString:url]) {

            [[SCURLSerialization shareSerialization]gotoWebcustom:url title:@"订单详情" navigation:self.navigationController];
        }
        
       
    };
    return headerView;
}

-(void)headClick:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_FIX(104);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifierCell";
    SCMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SCMyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self tableView:_listTable numberOfRowsInSection:indexPath.section]-1) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(_listTable.frame), SCREEN_FIX(104)) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }else{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(_listTable.frame), SCREEN_FIX(104)) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(0, 0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    
    
    cell.imageView.image = nil;
    cell.nameLab.text = @"";
    cell.desLab.text = @"";
    cell.priceLab.text = @"";
    cell.numLab.text = @"";
//    cell.goodModel = _scOrders[indexPath.section].goodsList[indexPath.row];
    if (_isMDStyle) {
        
        if (!_mdOrders ||
            indexPath.section >= _mdOrders.count ||
            indexPath.row >= _mdOrders[indexPath.section].ordOrderItemsAppVOList.count) {
            return cell;
        }
        
        ordOrderItemModel *model = _mdOrders[indexPath.section].ordOrderItemsAppVOList[indexPath.row];
        if ([SCUtilities isValidString:model.comGoodsPicturesUrl]) {
            [cell.commodityImgV sd_setImageWithURL:[NSURL URLWithString:model.comGoodsPicturesUrl] placeholderImage:/*[UIImage bundleImageNamed:@"childCategory"]*/nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                CGSize size;
                if (image.size.width>image.size.height) {
                    size = CGSizeMake(image.size.height, image.size.height);
                }else if(image.size.width<image.size.height){
                    size = CGSizeMake(image.size.width, image.size.width);
                }else{
                    size = image.size;
                }
                
                UIImage *img = [image thumbWithSize:size];
                cell.commodityImgV.image = img;
            }];
        }else{
            cell.commodityImgV.image = nil;//[UIImage bundleImageNamed:@"childCategory"];
            
        }
        cell.nameLab.text = [SCUtilities isValidString:model.skuName]?model.skuName:@"";
        cell.desLab.text =  [SCUtilities isValidString:model.purchasePriceDesc]?model.purchasePriceDesc:@"";
        cell.priceLab.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat: model.retailPrice]];
        cell.numLab.text = [NSString stringWithFormat:@"%ld",model.quantity];
    }else{
        
        if (!_scOrders ||
            indexPath.section >= _scOrders.count ||
            indexPath.row >= _scOrders[indexPath.section].goodsList.count) {
            return cell;
        }
        
        
        SCOrderGoodsModel *model = _scOrders[indexPath.section].goodsList[indexPath.row];
        if ([SCUtilities isValidString:model.picUrl]) {
            [cell.commodityImgV sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:/*[UIImage bundleImageNamed:@"childCategory"]*/nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

                UIImage *img = [image thumbWithSize:CGSizeZero];
                cell.commodityImgV.image = img;
            }];
          }else{
              cell.commodityImgV.image = nil;//[UIImage bundleImageNamed:@"childCategory"];

          }
        cell.nameLab.text =  [SCUtilities isValidString:model.goodsName]?model.goodsName:@"";
        cell.desLab.text =  [SCUtilities isValidString:model.goodsTitle]?model.goodsTitle:@"";
        cell.priceLab.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat: model.dealMoney]];
          cell.numLab.text = [NSString stringWithFormat:@"%ld",model.goodsCount];
    }
    
    
    return cell;;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSString *url = @"";
    if (self.isMDStyle) {
        url = SC_APOLLO_ORDER_DETAIL(self.mdOrders[section].orderId);
    }else{
        url =  SC_SC_ORDER_DETAIL(self.scOrders[section].orderNum);
    }
    
    if ([SCUtilities isValidString:url]) {
        
        [[SCURLSerialization shareSerialization]gotoWebcustom:url title:@"订单详情" navigation:self.navigationController];
    }
}

#pragma mark ----scMyOrderTopItemDelegate
-(void)itemClick:(SCOrderTopItemClickType)type{

    if (type > itemServiceType) {
        currentType = type;
    }
    
    NSString *scderStyle = @"";
    NSArray *mdStatusArr = [NSArray array];
    
    switch (type) {
        case itemCollectionType:
        {
            SCFavouriteViewController *vc = [SCFavouriteViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            return;
//            break;
            
        case itemCouponType:
        {
            NSString *URL = SC_MYCOUPON_URL;
            [[SCURLSerialization shareSerialization]gotoWebcustom:URL title:@"优惠券" navigation:self.navigationController];
                  
//            SCWebViewCustom *web = [[SCWebViewCustom alloc]init];
//            web.urlString = URL;
//            [self.navigationController pushViewController:web animated:YES];
        }
            return;
//            break;
        case itemAddressType:
        {
            SCAddressController *address = [[SCAddressController alloc]init];
            [self.navigationController pushViewController:address animated:NO];
        }
            return;
//            break;
        case itemServiceType:
        {
            //phoneNum=18880000001&tenantId=1&skillId=1&requestSource=2 这个字串BASE64编码
            SCUserInfo *userInfo = [SCUserInfo currentUser];
            NSString *param = [NSString stringWithFormat:@"phoneNum=%@&tenantId=1&skillId=1&requestSource=2",userInfo.phoneNumber];
            NSString *base64Param = [NSString base64StringFromText:param];
            NSString *fullUrl = [NSString stringWithFormat:@"%@%@",SC_KEFU_URL,base64Param];
            [[SCURLSerialization shareSerialization]gotoWebcustom:fullUrl title:@"客服" navigation:self.navigationController];
                  
//            SCWebViewCustom *web = [[SCWebViewCustom alloc]init];
//            web.urlString = fullUrl;
//            [self.navigationController pushViewController:web animated:YES];
        }
            return;
//            break;
        case itemWaitPayType_SC:
        {
            scderStyle = @"XSDD_DZF";   //待付款
            _isMDStyle = NO;
        }
            break;
        case itemWaitAcceptType_SC:
        {
            scderStyle =@"XSDD_YFH,XSDD_DFH";   //已发货/待收货
            _isMDStyle = NO;
        }
            break;
            
        case itemFinishedType_SC:
        {
            scderStyle = @"XSDD_YWC";  //已完成
            _isMDStyle = NO;
        }
            break;
        case itemAllOrderType_SC:
        {
            scderStyle = @"";
            _isMDStyle = NO;
        }
            break;
        case itemWaitPayType_MD:
        {
            mdStatusArr = @[@"0",@"01",@"17",@"20"];
            _isMDStyle = YES;
        }
            break;
        case itemWaitAcceptType_MD:
        {
//            mdStatusArr = @[@"8",@"9",@"10",@"11",@"13",@"21",@"25"]; //待发货
            mdStatusArr = @[@"1",@"12",@"14",@"26"];    //待收货
             _isMDStyle = YES;
        }
            break;
        case itemFinishedType_MD:
        {
            mdStatusArr = @[@"2",@"3",@"4",@"15",@"16"];  //已完成
             _isMDStyle = YES;
        }
            break;
        case itemAllOrderType_MD:
        {
           mdStatusArr = @[];  //已完成
             _isMDStyle = YES;
        }
            break;
        default:
            break;
    }
    
    if (!_isLoadMore) {
        _pageNum = 1;
    }
    
    if (_isMDStyle) {
        if (self.mdOrders && !_isLoadMore) {
            [self.mdOrders removeAllObjects];
        }
        [self md_requestOrderListWithStatus:mdStatusArr];
    }else{
        
        if (self.scOrders && !_isLoadMore) {
            [self.scOrders removeAllObjects];
        }
        [self sc_requestOrderListWithStatus:scderStyle];
        
    }
    
    _isLoadMore = NO;   //每次点击或者加载更多之后都要赋值为NO
    
}

-(void)sc_requestOrderListWithStatus:(NSString *)status{
    [self showLoading];
    NSDictionary *dic = @{@"pageNum":[NSNumber numberWithInt:_pageNum],@"pageSize":[NSNumber numberWithInt:10],@"orderStatus":status};
    
    __weak typeof(self)wkSelf = self;
    if(!self.scOrders){
        self.scOrders = [NSMutableArray arrayWithCapacity:0];
    }
    [SCRequest scMyOrderList_scParam:dic block:^(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg) {
        [self stopLoading];
        if (success) {
           
            NSArray *records = objDic[@"records"];
            if ([SCUtilities isValidArray:records]) {
                for (NSDictionary *dic in records) {
                    if ([SCUtilities isValidDictionary:dic]) {
                        SCSCOrderModel *model = [SCSCOrderModel yy_modelWithDictionary:dic];
                        [wkSelf.scOrders addObject:model];
                    }
                }
            }
        }
        [wkSelf.listTable reloadData];
    }];
}

-(void)md_requestOrderListWithStatus:(NSArray *)status{
    [self showLoading];
    NSDictionary *dic = @{@"pageArg":@{@"pageNum":[NSNumber numberWithInt:_pageNum],@"pageSize":[NSNumber numberWithInt:10]},@"orderStatusList":@[@"0",@"01",@"17",@"20"]};
    
    __weak typeof(self)wkSelf = self;
    if(!self.mdOrders){
        self.mdOrders = [NSMutableArray arrayWithCapacity:0];
    }
    [SCRequest mdMyOrderList_mdParam:dic block:^(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg) {
         [self stopLoading];
        if (success) {
            NSArray *result = objDic[@"result"];
            if ([SCUtilities isValidArray:result]) {
                for (NSDictionary *dic in result) {
                    SCApolloOrderModel *model = [SCApolloOrderModel yy_modelWithDictionary:dic];
                    if ([SCUtilities isValidDictionary:dic[@"ordOrderInfoVO"]] && [SCUtilities isValidString:dic[@"ordOrderInfoVO"][@"storeName"]]) {
                        model.storeName = dic[@"ordOrderInfoVO"][@"storeName"];
                        model.orderId = [NSString stringWithFormat:@"%@", dic[@"ordOrderInfoVO"][@"orderId"]];
                    }
                    [wkSelf.mdOrders addObject:model];
                }
            }
        }
        [wkSelf.listTable reloadData];
        
    }];
    

}

@end
