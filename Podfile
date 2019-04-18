# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IFoundU' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  pod 'ReactiveCocoa', '~> 8.0'
  pod 'ReactiveObjC', '~> 3.1.0'
  pod 'Masonry', '~> 1.1.0'
  pod 'SnapKit', '~> 4.2.0'
  pod 'AFNetworking', '~> 3.2.1'
  pod "BaiduMapKit" #百度地图SDK
  # Pods for IFoundU
  pod 'React', :path => '../../node_modules/react-native', :subspecs => [
  'Core',
  'CxxBridge', # 如果RN版本 >= 0.45则加入此行
  'DevSupport', # 如果RN版本 >= 0.43，则需要加入此行才能开启开发者菜单
  'RCTText',
  'RCTNetwork',
  'RCTWebSocket', # 这个模块是用于调试功能的
  'RCTAnimation',
  'RCTActionSheet',
  'RCTImage',
  'RCTVibration',
  'RCTSettings',
  'RCTGeolocation',
  'RCTLinkingIOS'
  ]
  # 如果你的RN版本 >= 0.42.0，则加入下面这行
  pod "yoga", :path => "../../node_modules/react-native/ReactCommon/yoga"
  
  # 如果RN版本 >= 0.45则加入下面三个第三方编译依赖
  pod 'DoubleConversion', :podspec => '../../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
  pod 'glog', :podspec => '../../node_modules/react-native/third-party-podspecs/glog.podspec'
  pod 'Folly', :podspec => '../../node_modules/react-native/third-party-podspecs/Folly.podspec'
  

  target 'IFoundUTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IFoundUUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
