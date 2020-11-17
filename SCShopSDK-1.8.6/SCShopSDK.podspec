Pod::Spec.new do |s|
  s.name = "SCShopSDK"
  s.version = "1.8.6"
  s.summary = "shopping"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"gejunyu5"=>"393864523@qq.com"}
  s.homepage = "https://github.com/SCShopTeam/SCShopSDK"
  s.description = "A shopping framework demo"
  s.frameworks = ["UIKit", "MapKit", "CoreGraphics", "MobileCoreServices", "Security", "SystemConfiguration", "CoreTelephony", "MessageUI", "QuartzCore", "CoreFoundation", "CoreText", "CoreImage", "ImageIO", "AssetsLibrary", "Accelerate", "WebKit", "CoreLocation", "EventKit", "JavaScriptCore", "AdSupport"]
  s.libraries = ["z", "sqlite3"]
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/SCShopSDK.framework'
end
