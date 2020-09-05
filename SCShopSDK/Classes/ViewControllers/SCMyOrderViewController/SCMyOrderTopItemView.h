//
//  SCMyOrderTopItemView.h
//  shopping
//
//  Created by zhangtao on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SCOrderTopItemClickType){
    itemCollectionType = 0,      //收藏
    itemCouponType,     //优惠券
    itemAddressType,   //  地址管理
    itemServiceType,   //客服   ，已经去掉
    
    itemWaitPayType_SC = 4,    //商城  待付款
    itemWaitAcceptType_SC,         //未完成（待发货，已发货）
    itemFinishedType_SC,  //
    itemAllOrderType_SC,
    
    itemWaitPayType_MD = 8,
    itemWaitAcceptType_MD,
    itemFinishedType_MD,
    itemAllOrderType_MD,
};

@protocol scMyOrderTopItemDelegate <NSObject>

-(void)itemClick:(SCOrderTopItemClickType) type;

@end

@interface SCMyOrderTopItemView : UIView

@property(nonatomic,strong)UIImageView *headImgV;
@property(nonatomic,strong)UILabel *phoneLab;

@property(nonatomic,assign)id <scMyOrderTopItemDelegate> delegate;

//-(void)masonryLay;

@end

NS_ASSUME_NONNULL_END
