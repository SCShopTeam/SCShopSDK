#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SCShoppingManager.h"
#import "SCURLSerialization.h"
#import "SCShopSDK.h"
#import "SCCustomAlertController.h"

FOUNDATION_EXPORT double SCShopSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char SCShopSDKVersionString[];

