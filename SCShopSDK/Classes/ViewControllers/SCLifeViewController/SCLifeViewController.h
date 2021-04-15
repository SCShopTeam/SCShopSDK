//
//  SCLifeViewController.h
//  shopping
//
//  Created by gejunyu on 2020/7/13.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface SCLifeViewController : SCBaseViewController

/**
 paramDic：
 包含以下一种：
 指定类别 typeNum：分类编码[一级、二级编码都可以]
 指定品牌 brandNum：品牌编码
 */
@property(nonatomic, copy) NSDictionary *paramDic;

@end

NS_ASSUME_NONNULL_END
