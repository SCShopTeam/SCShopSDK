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

#import "WKWebView + DeleteMenuItems.h"
#import "WKWebView + ExternalNavigationDelegates.h"
#import "WKWebView + SafeClearCache.h"
#import "WKWebView + SafeCookies.h"
#import "WKWebView + SafeEvaluateJS.h"
#import "WKWebView + SafeScrollTo.h"
#import "WKWebView + SupportProtocol.h"
#import "WKWebView + SyncConfigUA.h"
#import "WKWebViewExtensionsDef.h"

FOUNDATION_EXPORT double WKWebViewExtensionVersionNumber;
FOUNDATION_EXPORT const unsigned char WKWebViewExtensionVersionString[];

