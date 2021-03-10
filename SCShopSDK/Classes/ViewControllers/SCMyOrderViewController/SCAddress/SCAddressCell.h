//
//  SCAddressCell.h
//  shopping
//
//  Created by zhangtao on 2020/7/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAddressModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum{
    addressEditType,
    addressDeleteType,
}addressClickType;
@protocol SCAddressDelegaate <NSObject>

@optional
-(void)scAddressDoneClick:(addressClickType)type cell:(UITableViewCell *)cell;
@end
@interface SCAddressCell : UITableViewCell

@property(nonatomic,strong)UILabel *useName;
@property(nonatomic,strong)UILabel *phoneNumber;
@property(nonatomic,strong)UILabel *defaultAdMark;
@property(nonatomic,strong)UILabel *detailAddress;

@property(nonatomic,weak)id <SCAddressDelegaate> delegate;

@property(nonatomic,strong)SCAddressModel *model;

@end

NS_ASSUME_NONNULL_END
