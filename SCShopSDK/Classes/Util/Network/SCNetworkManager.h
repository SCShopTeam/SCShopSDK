//
//  SCNetworkManager.h
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SCRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    SCRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    SCRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, SCResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    SCResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    SCResponseSerializerHTTP,
};

/** 请求成功的Block */
typedef void(^SCHttpRequestSuccess) (id _Nullable responseObject);

/** 请求失败的Block */
typedef void(^SCHttpRequestFailed) (NSString * _Nullable errorMsg);

/** 合并请求结果*/
//typedef void(^SCHttpRequestCompletion)(id _Nullable responseObject, NSString * _Nullable errorMsg);
typedef void(^SCHttpRequestCompletion)(NSString * _Nullable errorMsg);

/** 缓存的Block */
typedef void(^SCHttpRequestCache) (id responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^SCHttpProgress) (NSProgress *progress);


@interface SCNetworkManager : NSObject

/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest;

/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(SCHttpRequestSuccess)success
                           failure:(SCHttpRequestFailed)failure;
/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(nullable NSDictionary *)parameters
                            success:(SCHttpRequestSuccess)success
                            failure:(SCHttpRequestFailed)failure;

//JSON请求
//+ (NSURLSessionTask *)JSON:(NSString *)URL
//                parameters:(NSDictionary *)parameters
//                   success:(SCHttpRequestSuccess)success
//                   failure:(SCHttpRequestFailed)failure;

/**
 *  上传文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param filePath   文件本地的沙盒路径
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                                      parameters:(NSDictionary *)parameters
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(SCHttpProgress)progress
                                         success:(SCHttpRequestSuccess)success
                                         failure:(SCHttpRequestFailed)failure;

/**
 *  上传单/多张图片
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                                        parameters:(NSDictionary *)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(SCHttpProgress)progress
                                           success:(SCHttpRequestSuccess)success
                                           failure:(SCHttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(SCHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(SCHttpRequestFailed)failure;


#pragma mark - 重置AFHTTPSessionManager相关属性
/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer RWRequestSerializerJSON(JSON格式), RWRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(SCRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer RWResponseSerializerJSON(JSON格式), RWResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(SCResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为15S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

@end

NS_ASSUME_NONNULL_END
