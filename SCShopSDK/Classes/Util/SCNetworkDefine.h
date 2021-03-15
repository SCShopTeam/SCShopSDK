//
//  SCNetworkDefine.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#ifndef SCNetworkDefine_h
#define SCNetworkDefine_h

//是否是正式环境
#define IS_RELEASE_ENVIRONMENT   YES
//host
#define BASE_WEB_URL (IS_RELEASE_ENVIRONMENT ? @"http://wap.js.10086.cn/ex" : @"http://wap.js.10086.cn/ex/test")
#define BASE_HOST (IS_RELEASE_ENVIRONMENT ? @"http://wap.js.10086.cn/ex/mall/api/v1" : @"http://wap.js.10086.cn/ex/test/mall/api/v1")

#define APOLLO_HOST (IS_RELEASE_ENVIRONMENT ? @"https://wx.apollojs.cn/apollosrv/api/othersystem/terminal/v1.0" : @"https://cnr.asiainfo.com/apollosrv/api/othersystem/terminal/v1.0")
#define A_MEMBER_HOST (IS_RELEASE_ENVIRONMENT ? @"https://wx.apollojs.cn/membersrv/api/othersystem/terminal/v1.0" : @"https://cnr.asiainfo.com/membersrv/api/othersystem/terminal/v1.0")



//b2c接口 参数
#define B_SUCCESS_CODE      @"0"
#define B_CODE              @"resCode"
#define B_MESSAGE           @"resMessage"
#define B_RESULT            @"result"

#define kCurPageKey         @"curPage"
#define kCountCurPageKey    @"count"
#define kCountCurPage       10 //每页数据数量

//接口格式2 参数
#define S_SUCCESS_CODE      @"1";
#define S_CODE              @"code"
#define S_MESSAGE           @"message"
#define S_DATA              @"data"

#define kPageNumKey         @"pageNum"
#define kPageSizeKey        @"pageSize"

//apollo 参数
#define A_SUCCESS_CODE      @"000000"
#define A_CODE              @"resultCode"
#define A_MESSAGE           @"resultMessage"
#define A_RESULT            @"result"



//优惠券
#define SC_MYCOUPON_URL  @"https://wap.js.10086.cn/kqzx/resource/wap/html_mycard/my_mall_coupon.html"
//客服
#define SC_KEFU_URL @"https://cnr.asiainfo.com/xin_ucfront/uc_channel_access/h5webchat/webChat.html?param="
#define SC_ONLINE_SERVICE_URL @"https://wap.js.10086.cn/OnLine.thtml?&ent=5b95a47f84f94b718c36d1818b1feaac"
//商城订单详情
#define SC_SC_ORDER_DETAIL(orderId) [NSString stringWithFormat:@"%@/mall/pages/orderDetail.html?orderNum=%@",BASE_WEB_URL,orderId]
//一小时达公告
#define SC_ONE_HOUR_URL  @"http://wap.js.10086.cn/ex/mall/pages/notice.html"
                    //  @"http://wap.js.10086.cn/ex/test/mall/pages/notice.html"

//门店订单详情
//#define SC_APOLLO_ORDER_DETAIL(orderId) [NSString stringWithFormat:@"https://cnr.asiainfo.com/cnr-web/orderDetail?orderId=%@&terminal=1",orderId] //废弃
/*-----------------------------请求地址都写在下方----------------------------*/
//登录
#define SC_LOGIN   NSStringFormat(@"%@/user/user/login",BASE_HOST)
//购物车列表
#define SC_CART_LIST                NSStringFormat(@"%@/user/cart/list",BASE_HOST)
//省市县列表
#define SC_ADMIN_LIST               NSStringFormat(@"%@/user/address/adminlist",BASE_HOST)
//收藏商品列表
#define SC_FAVORITE_LIST            NSStringFormat(@"%@/user/favorite/list",BASE_HOST)
//购物车 商品新增/修改
#define SC_CART_MERGE               NSStringFormat(@"%@/user/cart/merge",BASE_HOST)
//购物车 商品删除
#define SC_CART_DELETE              NSStringFormat(@"%@/user/cart/delete",BASE_HOST)
//用户 收藏商品 新增
#define SC_FAVORITE_ADD             NSStringFormat(@"%@/user/favorite/add",BASE_HOST)
//用户 收藏商品 删除
#define SC_FAVORITE_DELETE          NSStringFormat(@"%@/user/favorite/delete",BASE_HOST)
//推荐店铺 (现发现好店)
#define SC_SHOP_RECOMMEND           NSStringFormat(@"%@/user/shop/recommend",BASE_HOST)
//推荐门店 (新) http://ip/mallb2c/api/v1/ apollo/queryStoreFloor
#define SC_STORE_FLOOR             NSStringFormat(@"%@/user/apollo/queryStoreFloor",BASE_HOST)

//地址列表EDIT
#define SC_ADDRESS_LIST NSStringFormat(@"%@/user/address/list",BASE_HOST)
//地址详情
#define SC_ADDRESS_DETAIL NSStringFormat(@"%@/user/address/detail",BASE_HOST)
//地址 编辑/新增
#define SC_ADDRESS_EDIT NSStringFormat(@"%@/user/address/merge",BASE_HOST)
//地址 删除
#define SC_ADDRESS_DELETE NSStringFormat(@"%@/user/address/delete",BASE_HOST)
//分类查询（大类）
#define SC_GOODTYPE_LIST NSStringFormat(@"%@/goods/goodsType/queryGoodsTypeList?tenantNum=00000000",BASE_HOST)
//品类列表查询
#define SC_COMMODITY_LIST NSStringFormat(@"%@/goods/goods/queryCategoryList",BASE_HOST)
//商铺
#define SC_GOODTENANT_INFO NSStringFormat(@"%@/goods/tenant/info",BASE_HOST)
//商城订单列表
#define SC_MYORDER_LIST_SC  NSStringFormat(@"%@/order/order/queryMyOrders",BASE_HOST)

/**阿波罗接口**/
//门店订单列表  http://wap.js.10086.cn/ex/mall/api/v1/order/apollo/orderList
#define SC_MYORDER_LIST_MD   NSStringFormat(@"%@/order/apollo/orderList",BASE_HOST)   // NSStringFormat(@"%@/queryOrderListTerminal",BASE_HOST)
//地市列表
#define SC_AREA_LIST_AT        NSStringFormat(@"%@/queryAreaListAppTerminal",APOLLO_HOST)
//聚合页门店
#define SC_AGGREGATE_STORE     NSStringFormat(@"%@/getAggregateStore",A_MEMBER_HOST)
//批量查询门店优惠券
#define SC_STO_COU             NSStringFormat(@"%@/batchQueryStoCou",A_MEMBER_HOST)
//门店排队信息
#define SC_QUEUE_INFO          NSStringFormat(@"%@/qryHallQueueInfo",A_MEMBER_HOST)
//推荐商品
#define SC_GOODS_TERMINAL      NSStringFormat(@"%@/pageQueryGoodsTerminal",APOLLO_HOST)
//推荐门店
#define SC_PROFESSIONAL_STORE  NSStringFormat(@"%@/getProfessionalStore",A_MEMBER_HOST)
//立即取号
#define SC_VOUCH_NUMBER        NSStringFormat(@"%@/getByVouchNumber",A_MEMBER_HOST)

#endif /* SCNetworkDefine_h */
