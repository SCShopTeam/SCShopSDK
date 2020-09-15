//
//  SCCategoryViewController.m
//  shopping
//
//  Created by zhangtao on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCCategoryViewController.h"
#import "SCMainCategoryController.h"
//#import "SCCategoryCommodityController.h"
//#import "SCCategoryCommodityCtr.h"
#import "SCCateCommodityCtr.h"
#import "SCWebViewCustom.h"
//#import "SCCategoryModel.h"
#import "MJRefresh.h"
#import "SCShoppingManager.h"
@interface SCCategoryViewController ()<MainCategoryDelegate,CagegoryCommodityDelegte,UIScrollViewDelegate>

@end

#define view_width self.view.frame.size.width
#define view_height self.view.frame.size.height

#define  leftSpace 177*m6Scale
#define  btn_space  10
#define  btn_width (view_width-leftSpace)/3
#define  btn_height SCREEN_FIX(68)+5  //+5 ->  上下按钮的间距
#define navHeight self.navigationController.navigationBar.frame.size.height
#define statusHeight [UIApplication sharedApplication].statusBarFrame.size.height

@implementation SCCategoryViewController
{
    SCMainCategoryController *mainCategoryTable;
    UIScrollView *scroll;
    UIPageControl *pageCtr;
    UIView *childCategoryView;
   
    SCCateCommodityCtr *commodityCtr;
    
    NSMutableArray <SCCategoryModel *>*mainCategorys;
    NSArray <SecondCategoryModel *>*childCategorys;
    NSMutableArray<SCCommodityModel *> *commodities;
        
    NSInteger pageNum;
    NSString *currenttypeNum;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分类";
   
    mainCategoryTable = [[SCMainCategoryController alloc]initWithStyle:UITableViewStyleGrouped];
//    [self addChildViewController:mainCategoryTable];
    mainCategoryTable.view.frame = CGRectMake(0, 0, leftSpace, view_height);
    mainCategoryTable.delegate = self;
    [self.view addSubview:mainCategoryTable.view];
    
    
    
    
    UILabel *scrollName = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace+15, 0, view_width-leftSpace-15, 38)];
    scrollName.text = @"    品牌";
    scrollName.textColor = [UIColor blackColor];
    scrollName.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:scrollName];

    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(leftSpace, 38,view_width-leftSpace,2*btn_height+30)];
    scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll];
    scroll.pagingEnabled = YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;

    pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(scroll.frame)-30, view_width-leftSpace, 30)];
    [pageCtr setPageIndicatorTintColor:HEX_RGB(@"F2F2F2")];
    [pageCtr setCurrentPageIndicatorTintColor:HEX_RGB(@"F0250F")];
    [self.view addSubview:pageCtr];
    
    
    commodityCtr = [[SCCateCommodityCtr alloc]initWithStyle:UITableViewStyleGrouped];
//    [self addChildViewController:commodityTable];
    commodityCtr.view.frame = CGRectMake(CGRectGetWidth(mainCategoryTable.view.frame), CGRectGetMaxY(scroll.frame), view_width-mainCategoryTable.view.frame.size.width, view_height-CGRectGetMaxY(scroll.frame));
    [self.view addSubview:commodityCtr.view];
    commodityCtr.delegate = self;
//    __block typeof(currenttypeNum)wkcurrenttypeNum = currenttypeNum;
    commodityCtr.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommodity)];
    
//    commodityCtr.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
//
    pageNum = 1;
    [self requestData];
}

-(void)loadMoreCommodity{
    [commodityCtr.tableView.mj_footer endRefreshing];

    ++pageNum;
    [self requestCommodities:currenttypeNum];
}

//-(void)reloadData{
//    [commodityCtr.tableView.mj_header endRefreshing];
//     pageNum = 1;
//    [self requestData];
//}

#pragma mark   ----request----
-(void)requestData{
    mainCategorys = [NSMutableArray arrayWithCapacity:0];
    __weak typeof(mainCategorys) weakMains = mainCategorys;
    __weak typeof(self) wkself = self;
    __weak typeof(mainCategoryTable)wkMainTable = mainCategoryTable;
    [SCRequest scCategoryListBlock:^(BOOL success, NSArray * _Nullable objArr, NSString * _Nullable errMsg) {
        NSLog(@"...");
      
        for (NSDictionary *dic in objArr) {
            SCCategoryModel *model = [SCCategoryModel yy_modelWithDictionary:dic];
            [weakMains addObject:model];
        }
        
        [wkself configMainCategory];
        
        //模拟默认选中
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];


        wkMainTable.sourceArrs = weakMains;
        [wkMainTable reloadData];
//        if ([SCUtilities isValidArray:weakMains]) {
//            [wkself mainCategorySelect:weakMains.firstObject];
//        }
        
        [wkMainTable.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [wkMainTable tableView:wkMainTable.tableView didSelectRowAtIndexPath:indexPath];
    }];
    

    
//
//    mainCategoryCell *cell = (mainCategoryCell *)[mainCategoryTable.tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = YES;
////
////    [mainCategoryTable tableView:mainCategoryTable.tableView didSelectRowAtIndexPath:indexPath];
//    [mainCategoryTable tableView:mainCategoryTable.tableView didSelectRowAtIndexPath:indexPath];
//    cell.selected = NO;
////    [mainCategoryTable.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
////    cell.backgroundColor = [UIColor whiteColor];
////       cell.selected = YES;
}

#pragma mark --请求商品
-(void)requestCommodities:(NSString *)num{
    if (![SCUtilities isValidString:num]) {
        return;
    }
    [self showLoading];
    currenttypeNum = num;
    NSDictionary *param = @{@"typeNum":currenttypeNum,
                            @"isPreSale":@"0",
                            @"sort":@"SALE",
                            @"sortType":@"DESC",
                            @"pageNum":[NSNumber numberWithInteger:pageNum],
                            @"pageSize":@"20"};
    
    if (!commodities) {
        commodities = [NSMutableArray arrayWithCapacity:0];
    }
    __weak typeof(commodities) wkcommodities = commodities;
    [SCRequest scCategoryCommoditiesList:param block:^(BOOL success, NSDictionary * _Nullable objDic, NSString * _Nullable errMsg) {
        [self stopLoading];
        if (success && [SCUtilities isValidDictionary:objDic]) {
            NSArray *resultArr = objDic[@"records"];
            if ([SCUtilities isValidArray:resultArr]) {
                for (NSDictionary *dic in resultArr) {
                    SCCommodityModel *model = [SCCommodityModel yy_modelWithDictionary:dic];
                    [wkcommodities addObject:model];
                }
            }
            
        }
        [self configCommodities];
    }];
}

-(void)configMainCategory{
      childCategorys = [NSMutableArray arrayWithCapacity:0];
      commodities = [NSMutableArray arrayWithCapacity:0];
      
}

#pragma mark   ----重置子类
-(void)configChildCategory:(NSArray <SecondCategoryModel *>*)models{
    
    childCategorys = [models copy];
    
    //默认选中请求第一个
//    if ([SCUtilities isValidArray:childCategorys]) {
//        SecondCategoryModel *model = childCategorys.firstObject;
//        if ([SCUtilities isValidString:model.secondNum]) {
//            [self requestCommodities:model.secondNum];
//        }
//    }
    scroll.contentOffset = CGPointZero;

    CGFloat leftX = 0;
    CGFloat currentY = 0;
    
    CGFloat tureW = SCREEN_FIX(53);
    CGFloat tureH = SCREEN_FIX(68);
    
    for (int i = 0; i<childCategorys.count; i++) {
        SecondCategoryModel *model = childCategorys[i];
        
        leftX = i%3*btn_width;
        currentY = i/3*btn_height;
        
        CGRect fitFrame = CGRectMake(leftX, currentY, btn_width, btn_height);
        //CGRectMake(leftX + btn_width*(i%3), currentY, btn_width, btn_height);
        
        UIView *bgView = [[UIView alloc]initWithFrame:fitFrame];
        bgView.backgroundColor = [UIColor clearColor];
        [scroll addSubview:bgView];
        [bgView setTag:1000];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((btn_width-tureW)/2,0,tureW,tureH)];
        [btn setTag:1000+i];
        
   
        
        [btn addTarget:self action:@selector(childCategoryClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.size.width, btn.frame.size.width, btn.frame.size.height-btn.frame.size.width)];
            lb.font = [UIFont systemFontOfSize:12];
              lb.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:lb];
        if ([SCUtilities isValidString:model.secondName]) {
            lb.text = model.secondName;
        }else{
            lb.text = @"";
        }
        
        if (![SCUtilities isValidString:model.secondPic]) {
            [btn setImage:[UIImage bundleImageNamed:@"childCategory"] forState:UIControlStateNormal];

        }else{
            [btn sd_setImageWithURL:[NSURL URLWithString:model.secondPic] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

            }];
        }
       
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                 
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, btn.frame.size.height-btn.frame.size.width, 0)];

        [bgView addSubview:btn];
    }
    
    
    if (!childCategorys || childCategorys.count == 0) {
        scroll.frame = CGRectMake(leftSpace, 0,view_width-leftSpace,0);

    }else{
        scroll.frame = CGRectMake(leftSpace, 38,view_width-leftSpace,currentY+btn_height);
    }
    
        commodityCtr.view.frame = CGRectMake(CGRectGetWidth(mainCategoryTable.view.frame), CGRectGetMaxY(scroll.frame), view_width-mainCategoryTable.view.frame.size.width, view_height-CGRectGetMaxY(scroll.frame));
}

#pragma mark  重置子类下商品
-(void)configCommodities{
    
   
    
    commodityCtr.sourceArrs = commodities;
    [commodityCtr reloadData];
//    if (commodityCtr.tableView.mj_footer) {
//           [commodityCtr.tableView.mj_footer endRefreshing];
//       }
}

-(void)removeChildCategory{
    childCategorys = nil;
    for (id obj in scroll.subviews) {
        if ([obj isKindOfClass:[UIView class]] &&  ((UIView *)obj).tag == 1000) {
            [obj removeFromSuperview];
        }
        
        if ([obj isKindOfClass:[UIButton class]]) {
                   [obj removeFromSuperview];
        }
    }
}

-(void)removeCommodity{
    pageNum = 1;
     if (commodities && commodities.count>0) {
         [commodities removeAllObjects];
          commodities = nil;
     }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == scroll) {
        NSInteger pageNum = (NSInteger)scroll.contentOffset.x/(NSInteger)scroll.frame.size.width;
        [pageCtr setCurrentPage:pageNum];
    }
}


#pragma mark 点击子类事件，重置商品
-(void)childCategoryClick:(UIButton *)sender{
    NSInteger index = sender.tag-1000;
    NSLog(@"...%ld",index);
    [self removeCommodity];
//    [self configCommodities];
    SecondCategoryModel *model = childCategorys[index];
    [self requestCommodities:model.secondNum];
    
    //插码
    NSString *code = [NSString stringWithFormat:@"IOS_T_NZDSCFL_A0%ld",index+1];
    SCShoppingManager *manager = [SCShoppingManager sharedInstance];
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(scXWMobStatMgrStr:url:inPage:)]) {
        [manager.delegate scXWMobStatMgrStr:code url:@"" inPage:NSStringFromClass([self class])];
    }
}

#pragma mark MainCategoryDelegate  点击主类事件，重置子类和商品
-(void)mainCategorySelect:(SCCategoryModel *)categoryModel{
    if (childCategorys && childCategorys.count > 0) {
        [self removeChildCategory];

    }
    
        [self removeCommodity];
    
   
    if (!categoryModel) {
        return;
    }
    
    //只展示第一个大类下的子类
    NSString *firstCategoryNum = mainCategorys.firstObject.typeNum;
    if (categoryModel && [SCUtilities isValidArray:categoryModel.secondList] && [categoryModel.typeNum isEqualToString:firstCategoryNum]) {
        [self configChildCategory:categoryModel.secondList];
        
        [self requestCommodities:categoryModel.typeNum];
    }else{
        NSString *typeNum = categoryModel.typeNum;
        if ([SCUtilities isValidString:typeNum]) {
            [self configChildCategory:nil]; //为了布局页面
            [self requestCommodities:typeNum];
        }
    }
}

#pragma mark CagegoryCommodityDelegte  点击商品事件
-(void)cagegoryCommodityClick:(SCCommodityModel *)model{
    
    if ([SCUtilities isValidString:model.detailUrl]) {
        
        [[SCURLSerialization shareSerialization]gotoWebcustom:model.detailUrl title:@"" navigation:self.navigationController];
       
//        SCWebViewCustom *web = [[SCWebViewCustom alloc]init];
//        web.urlString = model.detailUrl;
//        [self.navigationController pushViewController:web animated:YES];
    }
}

@end
