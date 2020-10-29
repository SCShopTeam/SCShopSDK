//
//  SCPopupManager.h
//  shopping
//
//  Created by gejunyu on 2020/10/26.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHomeTouchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCPopupManager : UIView

+ (BOOL)validPopup:(SCHomeTouchModel *)touchModel type:(SCPopupType)type;

@end

NS_ASSUME_NONNULL_END
