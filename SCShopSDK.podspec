#
# Be sure to run `pod lib lint SCShopSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SCShopSDK'
    s.version          = '1.8.7'
    s.summary          = 'shopping'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = "A shopping framework demo"
    
    s.homepage         = 'https://github.com/SCShopTeam/SCShopSDK'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'gejunyu5' => '393864523@qq.com' }
    s.source           = { :git => 'https://github.com/SCShopTeam/SCShopSDK.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '9.0'
    
    #####代码
    s.source_files = 'SCShopSDK/Classes/**/*.{h,m,pch}','SCShopSDK/Classes/**/**/*.{h,m}','SCShopSDK/Classes/**/**/**/*.{h,m}','SCShopSDK/Classes/**/**/**/**/*.{h,m}'
    
    s.public_header_files = 'SCShopSDK/Classes/Util/SCShoppingManager.h', 'SCShopSDK/Classes/ViewControllers/WebView/SCURLSerialization.h','SCShopSDK/Classes/Util/SCShopSDK.h','SCShopSDK/Classes/Views/SCCustomAlertController.h'
    s.prefix_header_file = 'SCShopSDK/Classes/Util/SCCommonPrefix.pch'
    ######
    
    ## 图片资源 打包时注释,否则图片会打包进framework
    #    s.resource_bundles = {
    #        'SCShopResource' => ['SCShopSDK/Assets/*.png']
    #    }
    ###
    
    #framework
#    s.vendored_framework   = 'SCShopSDK/Framework/AgoraRtcCryptoLoader.framework'
    #####
    
#    s.user_target_xcconfig = {'OTHER_LDFLAGS' => ['-ObjC','-all_load']}
    s.user_target_xcconfig = {'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
    s.static_framework = true;
    s.requires_arc = true
    
    s.libraries = 'z', 'sqlite3'
    s.frameworks = 'UIKit', 'MapKit', 'CoreGraphics', 'MobileCoreServices', 'Security', 'SystemConfiguration', 'CoreTelephony', 'MessageUI', 'QuartzCore', 'CoreFoundation', 'CoreText', 'CoreImage', 'ImageIO', 'AssetsLibrary', 'Accelerate', 'WebKit', 'CoreLocation' , 'EventKit', 'JavaScriptCore', 'AdSupport'
    
    s.dependency 'AFNetworking', '~> 3.2.0'
    s.dependency 'FMDB', '~> 2.7.2'
    s.dependency 'YYModel', '~> 1.0.4'
    s.dependency 'SDWebImage', '~> 5.8.1'
    s.dependency 'SDCycleScrollView', '~> 1.82'
    s.dependency 'MJRefresh', '~> 3.4.3'
    s.dependency 'Masonry', '~> 1.1.0'
    s.dependency 'WebViewJavascriptBridge', '~> 6.0.3'
    s.dependency 'WKWebViewExtension', '~> 0.1'
end
