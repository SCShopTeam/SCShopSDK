//
//  SCMyOrderHeaderView.h
//  shopping
//
//  Created by zhangtao on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCMyOrderHeaderView : UIView

@property(nonatomic,copy)void(^orderHeaderCallBack)(NSString *detailUrl);

@property(nonatomic,strong)UILabel *nameLab;

@property(nonatomic,strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
