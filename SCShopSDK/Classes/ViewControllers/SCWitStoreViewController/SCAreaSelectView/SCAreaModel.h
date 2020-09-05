//
//  SCAreaModel.h
//  shopping
//
//  Created by gejunyu on 2020/8/29.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCAppVoModel;

NS_ASSUME_NONNULL_BEGIN

@interface SCAreaModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray <SCAppVoModel *> *areaAppVoList;

//自定义属性
@property (nonatomic, assign) BOOL selected;

@end


@interface SCAppVoModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;

@end

NS_ASSUME_NONNULL_END
