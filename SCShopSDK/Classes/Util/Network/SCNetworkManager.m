//
//  SCNetworkManager.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "SCNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "SCRequestParams.h"
#import "SCLocationService.h"
#import <WebKit/WebKit.h>
@implementation SCNetworkManager

static BOOL _isOpenLog;   // 是否已开启日志打印
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(SCNetworkStatus)networkStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(SCNetworkStatusUnknown) : nil;
                    DDLOG(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(SCNetworkStatusNotReachable) : nil;
                    DDLOG(@"无网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(SCNetworkStatusReachableViaWWAN) : nil;
                    DDLOG(@"手机自带网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(SCNetworkStatusReachableViaWiFi) : nil;
                    DDLOG(@"WIFI");
                    break;
            }
        }];
    });
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)openLog {
    _isOpenLog = YES;
}

+ (void)closeLog {
    _isOpenLog = NO;
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GET请求

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(SCHttpRequestSuccess)success
                  failure:(SCHttpRequestFailed)failure {
    
    NSString *requestURL = [_sessionManager.requestSerializer requestBySerializingRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]] withParameters:parameters error:nil].URL.absoluteString;
    //    requestURL = [requestURL jsbcInterfaceUrl]; //加密操作
    
    if (_isOpenLog) {
        DDLOG(@"%@", NSStringFormat(@"requestURL = %@",requestURL));
    }
    
    NSString *appPwd = [SCRequestParams shareInstance].appPwd;
    [_sessionManager.requestSerializer setValue:appPwd?:@"" forHTTPHeaderField:@"appPwd"];
    
    NSString *cmtokenid = [SCRequestParams shareInstance].sessionId ?: @"";
    if ([SCUtilities isValidString:cmtokenid]) {
        cmtokenid = [NSString stringWithFormat:@"cmtokenid=%@",cmtokenid];
    }
//    [_sessionManager.requestSerializer setValue:cmtokenid forHTTPHeaderField:@"Cookie"];
    
    
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLOG(@"%@", _isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"success");
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLOG(@"%@", _isOpenLog ? NSStringFormat(@"error = %@",error) : @"failure");
        [[self allSessionTask] removeObject:task];
        failure ? failure(error.why) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - POST请求

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(SCHttpRequestSuccess)success
                   failure:(SCHttpRequestFailed)failure {
    
    NSMutableDictionary *param = [[SCRequestParams shareInstance]getParams];
    if (VALID_DICTIONARY(parameters)) {
        for (NSString *key in parameters.allKeys) {
            id value = parameters[key];
            param[key] = value;
        }
    }
    
//    if ([URL containsString:@"order/queryMyOrders"]) {
//        [SCNetworkManager setRequestSerializer:SCRequestSerializerHTTP];
//    }else{
        [SCNetworkManager setRequestSerializer:SCRequestSerializerJSON];
//    }
    
    NSString *appPwd    = [SCRequestParams shareInstance].appPwd ?: @"";
    NSString *cmtokenid = [SCRequestParams shareInstance].sessionId ?: @"";
    
    if ([URL containsString:APOLLO_HOST] || [URL isEqualToString:SC_MYORDER_LIST_MD]) {
        NSString *userRegion = [SCRequestParams shareInstance].userRegion ?: ([SCLocationService sharedInstance].cityCode ?: @"14");
        [_sessionManager.requestSerializer setValue:cmtokenid forHTTPHeaderField:@"B2C-Token"];
        [_sessionManager.requestSerializer setValue:userRegion forHTTPHeaderField:@"B2C-AreaNum"];
    }
    if ([SCUtilities isValidString:cmtokenid]) {
        cmtokenid = [NSString stringWithFormat:@"cmtokenid=%@",cmtokenid];
    }
    [_sessionManager.requestSerializer setValue:appPwd forHTTPHeaderField:@"appPwd"];
    
    //>>>>删
//    [_sessionManager.requestSerializer setValue:cmtokenid forHTTPHeaderField:@"Cookie"];
    
    
    
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLOG(@"%@", _isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"success");
        
        [[self allSessionTask] removeObject:task];
        
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLOG(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"failure");
        [[self allSessionTask] removeObject:task];
        failure ? failure(error.why) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    
    return sessionTask;
}

////#pragma mark - JSON请求
////
//+ (NSURLSessionTask *)JSON:(NSString *)URL
//                parameters:(NSDictionary *)parameters
//                   success:(SCHttpRequestSuccess)success
//                   failure:(SCHttpRequestFailed)failure {
//
//    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//    _sessionManager.requestSerializer.timeoutInterval = 15;
////    [_sessionManager.requestSerializer setValue:[NISystemInfo appShortVersion] forHTTPHeaderField:@"App-Version"];
//    [_sessionManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"client"];
//    //    manager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
//    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/JavaScript",@"text/html",@"text/plain",nil];
//    NSLog(@"httpHeader -> %@",_sessionManager.requestSerializer.HTTPRequestHeaders);
//    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLOG(@"%@", _isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"success");
//
//        [[self allSessionTask] removeObject:task];
//
//        success ? success(responseObject) : nil;
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DDLOG(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"failure");
//        [[self allSessionTask] removeObject:task];
//        failure ? failure(error) : nil;
//    }];
//
//    // 添加最新的sessionTask到数组
//    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
//
//    return sessionTask;
//}

#pragma mark - 上传文件

+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(NSDictionary *)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(SCHttpProgress)progress
                                success:(SCHttpRequestSuccess)success
                                failure:(SCHttpRequestFailed)failure {
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name error:&error];
        (failure && error) ? failure(error.why) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLOG(@"%@",_isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"success");
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLOG(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"failure");
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error.why) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 上传多张图片

+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(NSDictionary *)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(SCHttpProgress)progress
                                  success:(SCHttpRequestSuccess)success
                                  failure:(SCHttpRequestFailed)failure {
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSUInteger i = 0; i < images.count; i++) {
            NSData *imageData = [SCNetworkManager compressOriginalImage:images[i] toMaxDataSizeKBytes:2];
            [dataArr addObject:imageData];
        }
        for (NSUInteger i = 0; i < dataArr.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            //            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            NSData *imageData = dataArr[i];
            NSLog(@"---%ld---",imageData.length);
            // 默认图片的文件名, 若fileNames为nil就使用
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = NSStringFormat(@"IMG%@%ld.%@",str,i,imageType?:@"jpg");
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];  // @"applicaiton/json"
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLOG(@"%@",_isOpenLog ? NSStringFormat(@"responseObject = %@",[self jsonToString:responseObject]) : @"success");
        
        [[self allSessionTask] removeObject:task];
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLOG(@"%@",_isOpenLog ? NSStringFormat(@"error = %@",error) : @"failure");
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error.why) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}
//压缩图片
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1024.0;
    CGFloat maxQuality = size-0.01;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1024.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(SCHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(SCHttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *downloadDir = [cachePath stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [self cancelRequestWithURL:URL];
        if(failure && error) {failure(error.why) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil;
    
    return downloadTask;
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data {
    if(!data) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}


#pragma mark - 初始化AFHTTPSessionManager相关属性

/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 15.f;
    [_sessionManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"client"];
    
    //    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    
    //    [_sessionManager.requestSerializer setValue:@"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    /*test*/
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    [SCNetworkManager setSecurityPolicyWithCerPath:cerPath validatesDomainName:YES];
    
}




#pragma mark - 重置AFHTTPSessionManager相关属性
+ (void)setRequestSerializer:(SCRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = (requestSerializer == SCRequestSerializerHTTP) ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(SCResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = (responseSerializer == SCResponseSerializerHTTP) ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}

@end


#pragma mark - NSDictionary,NSArray的分类

/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    return strM;
}

@end

@implementation NSDictionary (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    [strM appendString:@"}\n"];
    return strM;
}

@end
#endif
