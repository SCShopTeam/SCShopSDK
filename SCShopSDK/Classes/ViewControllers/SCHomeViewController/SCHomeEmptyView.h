//
//  SCHomeEmptyView.h
//  shopping
//
//  Created by gejunyu on 2020/9/5.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCHomeEmptyStatus) {
    SCHomeEmptyStatusLoading,
    SCHomeEmptyStatusNull
};

NS_ASSUME_NONNULL_BEGIN

@interface SCHomeEmptyView : UICollectionReusableView

@property (nonatomic, assign) SCHomeEmptyStatus status;

@end

NS_ASSUME_NONNULL_END
