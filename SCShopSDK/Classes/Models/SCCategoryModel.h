//
//  SCCategoryModel.h
//  shopping
//
//  Created by zhangtao on 2020/8/6.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SecondCategoryModel;

@interface SCCategoryModel : NSObject

@property(nonatomic,strong)NSString *typeNum;
@property(nonatomic,strong)NSString *typeName;
@property(nonatomic,strong)NSString *typePic;
@property(nonatomic,strong)NSArray<SecondCategoryModel *> *secondList;

//自定义
@property (nonatomic, assign) CGFloat tagWidth;
@property (nonatomic, assign) BOOL selected;

+ (NSArray <SCCategoryModel *> *)parsingModelsFromData:(NSArray *)data;

@end

@interface SecondCategoryModel : NSObject

@property(nonatomic,strong)NSString *secondName;
@property(nonatomic,strong)NSString *secondNum;
@property(nonatomic,strong)NSString *secondPic;

@end

