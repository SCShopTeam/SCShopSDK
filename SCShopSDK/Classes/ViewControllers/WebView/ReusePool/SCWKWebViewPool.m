//
//  MSWKWebViewPool.h
//  ecmc
//
//  Created by gaoleyu on 2019/11/29.
//  Copyright © 2019年 gaoleyu. All rights reserved.
//

#import "SCWKWebViewPool.h"
#import "SCWebView.h"


@interface SCWKWebViewPool()
@property(nonatomic, strong, readwrite) dispatch_semaphore_t lock;
@property(nonatomic, strong, readwrite) NSMutableSet<__kindof SCWebView *> *visiableWebViewSet;
@property(nonatomic, strong, readwrite) NSMutableSet<__kindof SCWebView *> *reusableWebViewSet;
@end

@implementation SCWKWebViewPool

//+ (void)load {
//    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//        [self prepareWebView];
//        [[NSNotificationCenter defaultCenter] removeObserver:observer];
//    }];
//}

//+ (void)prepareWebView {
//    [[SCWKWebViewPool sharedInstance] _prepareReuseWebView];
//}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static SCWKWebViewPool *webViewPool = nil;
    dispatch_once(&once,^{
        webViewPool = [[SCWKWebViewPool alloc] init];
    });
    return webViewPool;
}

- (instancetype)init{
    self = [super init];
    if(self){
        _prepare = YES;
        _visiableWebViewSet = [NSSet set].mutableCopy;
        _reusableWebViewSet = [NSSet set].mutableCopy;
        
        _lock = dispatch_semaphore_create(1);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_clearReusableWebViews) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

#pragma mark - Public Method
- (__kindof SCWebView *)getReusedWebViewForHolder:(id)holder{
    if (!holder) {
        #if DEBUG
        NSLog(@"MSWKWebViewPool must have a holder");
        #endif
        return nil;
    }
    
    [self _tryCompactWeakHolders];
    
    SCWebView *webView;
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    if (_reusableWebViewSet.count > 0) {
        webView = (SCWebView *)[_reusableWebViewSet anyObject];
        // 网页销毁结束时间与下次创建webview时间过短，
        // 重新创建新webview 为了保证webview 不会显示前一个webview内容
        NSTimeInterval timespace = CFAbsoluteTimeGetCurrent() - webView.endTime;
        if (timespace > 2)
        {
            [_reusableWebViewSet removeObject:webView];
            [_visiableWebViewSet addObject:webView];
            
//            [webView webViewWillReuse];
            NSLog(@"我不是创建出来的");
        }
        else
        {
            [_reusableWebViewSet removeObject:webView];
            webView = [[SCWebView alloc] init];
            [_visiableWebViewSet addObject:webView];
            NSLog(@"我是创建出来的");
        }
        
    } else {
        webView = [[SCWebView alloc] init];
        [_visiableWebViewSet addObject:webView];
        NSLog(@"我是创建出来的");
    }
    webView.holderObject = holder;
    
    dispatch_semaphore_signal(_lock);
    
    return webView;
}

- (void)recycleReusedWebView:(__kindof SCWebView *)webView{
    if (!webView) {
        return;
    }
   
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    if ([_visiableWebViewSet containsObject:webView]) {
        //将webView重置为初始状态
        [webView webViewEndReuse];
        
        [_visiableWebViewSet removeObject:webView];
        [_reusableWebViewSet addObject:webView];
        // 网页销毁结束时间与下次创建webview时间过短，
        // 重新创建新webview 为了保证webview 不会显示前一个webview内容
        webView.endTime = CFAbsoluteTimeGetCurrent();
        
    } else {
        if (![_reusableWebViewSet containsObject:webView]) {
            #if DEBUG
            NSLog(@"MSWKWebViewPool没有在任何地方使用这个webView");
            #endif
        }
    }
    dispatch_semaphore_signal(_lock);
}

// 未加载完成的webview,此时退出
- (void)recycleReusedWebViewNotLoad:(__kindof SCWebView *)webView{
    if (!webView) {
        return;
    }
  
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    if ([_visiableWebViewSet containsObject:webView]) {
        //将webView重置为初始状态
        [webView webViewEndReuse];
        
        [_visiableWebViewSet removeObject:webView];
//        [_reusableWebViewSet addObject:webView];
        [webView cleanInstanceWebview];
        webView = nil;
        
    } else {
        if (![_reusableWebViewSet containsObject:webView]) {
            #if DEBUG
            NSLog(@"MSWKWebViewPool没有在任何地方使用这个webView");
            #endif
        }
    }
    dispatch_semaphore_signal(_lock);
}

- (void)cleanReusableViews{
    [self _clearReusableWebViews];
}

#pragma mark - Private Method
- (void)_tryCompactWeakHolders {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    NSMutableSet<SCWebView *> *shouldreusedWebViewSet = [NSMutableSet set];
    
    for (SCWebView *webView in _visiableWebViewSet) {
        if (!webView.holderObject) {
            [shouldreusedWebViewSet addObject:webView];
        }
    }
    
    for (SCWebView *webView in shouldreusedWebViewSet) {
//        [webView webViewEndReuse];
        
        [_visiableWebViewSet removeObject:webView];
        [_reusableWebViewSet addObject:webView];
    }
    
    dispatch_semaphore_signal(_lock);
}

- (void)_clearReusableWebViews {
    [self _tryCompactWeakHolders];
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_reusableWebViewSet removeAllObjects];
    dispatch_semaphore_signal(_lock);
    
//    [WKWebView safeClearAllCache];
}

- (void)_prepareReuseWebView {
    if (!_prepare) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SCWebView *webView = [[SCWebView alloc] init];
        [self->_reusableWebViewSet addObject:webView];
    });
}

#pragma mark - Other
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
